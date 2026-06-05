# kb.ps1 - Tatkowski KB read/write helper. Stateless: repo is the only source of truth.
# Usage:
#   .\kb.ps1 read
#   .\kb.ps1 write -By Maciej -Message "what changed"
param(
  [Parameter(Mandatory)][ValidateSet("read","write")][string]$Action,
  [string]$Message,
  [string]$By = "Maciej",
  [switch]$Force,
  [string]$File   = "tatkowski_knowledge_base.md",
  [string]$Repo   = "satanhimself2137/tatkowski-kb",
  [string]$Branch = "main"
)
$ErrorActionPreference = "Stop"
$work = Join-Path $env:TEMP "kb_work.md"
$shaF = Join-Path $env:TEMP "kb_work.sha"
function Get-Sha { gh api "repos/$Repo/contents/${File}?ref=${Branch}" --jq ".sha" }
if ($Action -eq "read") {
  $b64 = (gh api "repos/$Repo/contents/${File}?ref=${Branch}" --jq ".content") -replace "\s",""
  [IO.File]::WriteAllBytes($work, [Convert]::FromBase64String($b64))
  (Get-Sha) | Out-File -Encoding ascii $shaF
  Write-Output "READ ok -> $work ($((Get-Item $work).Length) bytes). Edit this file, then: kb.ps1 write -By $By -Message ..."
} else {
  if (-not $Message) { throw "write needs -Message" }
  if (-not (Test-Path $work)) { throw "no working file at $work - run read first" }
  $cur = Get-Sha
  $old = if (Test-Path $shaF) { (Get-Content $shaF -Raw).Trim() } else { "" }
  if ($cur -ne $old -and -not $Force) {
    throw "repo changed since read (sha $old -> $cur). Re-run read, re-apply your edit, then write. Use -Force only to deliberately overwrite."
  }
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($work))
  $msg = "[Claude/$By] - $Message - $(Get-Date -Format dd/MM/yy)"
  $payload = @{ message=$msg; content=$b64; sha=$cur; branch=$Branch } | ConvertTo-Json -Compress
  $pf = Join-Path $env:TEMP "kb_payload.json"
  [IO.File]::WriteAllText($pf, $payload, (New-Object System.Text.UTF8Encoding $false))
  $url = gh api "repos/$Repo/contents/$File" -X PUT --input $pf --jq ".commit.html_url"
  (Get-Sha) | Out-File -Encoding ascii $shaF
  Write-Output "WRITE ok -> $url"
}