# kb.ps1 v3 - stateless Tatkowski KB helper. Self-timeouts so a hung gh call can never block Desktop Commander.
# Usage: .\kb.ps1 read   |   .\kb.ps1 read -Section 11   |   .\kb.ps1 write -By Maciej -Message "what changed"
param(
  [Parameter(Mandatory)][ValidateSet("read","write")][string]$Action,
  [string]$Message, [string]$By = "Maciej", [switch]$Force,
  [string]$Section,
  [string]$File="tatkowski_knowledge_base.md",
  [string]$Repo="satanhimself2137/tatkowski-kb",
  [string]$Branch="main", [int]$TimeoutSec=20
)
$ErrorActionPreference="Stop"
$env:GH_PROMPT_DISABLED=1; $env:GIT_TERMINAL_PROMPT=0; $env:CLICOLOR=0
function Gh($cmdArgs){
  $j = Start-Job { param($a) & gh @a 2>&1 } -ArgumentList @(,$cmdArgs)
  if(Wait-Job $j -Timeout $TimeoutSec){ $out=Receive-Job $j; Remove-Job $j; return $out }
  Stop-Job $j; Remove-Job $j -Force; throw "gh timed out after ${TimeoutSec}s (network/auth?). Aborted so the bridge stays alive."
}$work=Join-Path $env:TEMP "kb_work.md"; $shaF=Join-Path $env:TEMP "kb_work.sha"
function Get-Sha { (Gh @("api","repos/$Repo/contents/${File}?ref=${Branch}","--jq",".sha")).Trim() }
if($Action -eq "read"){
  $b64=((Gh @("api","repos/$Repo/contents/${File}?ref=${Branch}","--jq",".content")) -join "") -replace "\s",""
  [IO.File]::WriteAllBytes($work,[Convert]::FromBase64String($b64))
  (Get-Sha)|Out-File -Encoding ascii $shaF
  if($Section){
    $lines=([IO.File]::ReadAllText($work)) -split "`n"
    $start=-1; $end=$lines.Count
    for($i=0;$i -lt $lines.Count;$i++){ if($lines[$i] -match "^##\s+$([regex]::Escape($Section))\b"){ $start=$i; break } }
    if($start -lt 0){ throw "Section '$Section' not found. Full file still at $work." }
    for($i=$start+1;$i -lt $lines.Count;$i++){ if($lines[$i] -match "^##\s+\d+\."){ $end=$i; break } }
    "----- SECTION $Section (full file on disk at $work, edit there) -----"
    ($lines[$start..($end-1)] -join "`n")
  } else {
    "READ ok -> $work ($((Get-Item $work).Length) bytes). Edit it, then: kb.ps1 write -By $By -Message ..."
  }
} else {
  if(-not $Message){throw "write needs -Message"}
  if(-not(Test-Path $work)){throw "no working file at $work - run read first"}
  $cur=Get-Sha; $old=if(Test-Path $shaF){(Get-Content $shaF -Raw).Trim()}else{""}
  if($cur -ne $old -and -not $Force){throw "repo changed since read ($old -> $cur). Re-read, re-apply edit, write. -Force to override."}
  $b64=[Convert]::ToBase64String([IO.File]::ReadAllBytes($work))
  $msg="[Claude/$By] - $Message - $(Get-Date -Format dd/MM/yy)"
  $payload=@{message=$msg;content=$b64;sha=$cur;branch=$Branch}|ConvertTo-Json -Compress
  $pf=Join-Path $env:TEMP "kb_payload.json"
  [IO.File]::WriteAllText($pf,$payload,(New-Object System.Text.UTF8Encoding $false))
  $url=Gh @("api","repos/$Repo/contents/$File","-X","PUT","--input",$pf,"--jq",".commit.html_url")
  (Get-Sha)|Out-File -Encoding ascii $shaF
  "WRITE ok -> $url"
}