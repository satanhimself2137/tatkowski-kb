# issues.ps1 v1 - Tatkowski issues & gotchas log helper. Self-timeouts, atomic gh API writes.
# Pure ASCII separators (--) by design so encoding can't break the regex matching.
# Usage:
#   .\issues.ps1 read [-Search "kw"] [-Status open|resolved|all] [-Category TECH]
#   .\issues.ps1 log -Category TECH -Title "..." -Symptom "..." [-Context "..."] [-By Claude]
#   .\issues.ps1 resolve -Id 4 -Resolution "..." [-By Maciej]
#   .\issues.ps1 bump -Id 4
param(
  [Parameter(Mandatory)][ValidateSet("read","log","resolve","bump")][string]$Action,
  [string]$Category, [string]$Title, [string]$Symptom, [string]$Context,
  [string]$Resolution, [string]$By = "Claude",
  [int]$Id, [string]$Search,
  [ValidateSet("open","resolved","all")][string]$Status = "all",
  [string]$File = "issues_log.md",
  [string]$Repo = "satanhimself2137/tatkowski-kb",
  [string]$Branch = "main", [int]$TimeoutSec = 20
)
$ErrorActionPreference = "Stop"
$env:GH_PROMPT_DISABLED = 1; $env:GIT_TERMINAL_PROMPT = 0; $env:CLICOLOR = 0

function Gh($cmdArgs) {
  $j = Start-Job { param($a) & gh @a 2>&1 } -ArgumentList @(, $cmdArgs)
  if (Wait-Job $j -Timeout $TimeoutSec) { $out = Receive-Job $j; Remove-Job $j; return $out }
  Stop-Job $j; Remove-Job $j -Force; throw "gh timed out after ${TimeoutSec}s (network/auth?). Aborted."
}

function Get-FileContent {
  $b64 = ((Gh @("api", "repos/$Repo/contents/${File}?ref=${Branch}", "--jq", ".content")) -join "") -replace "\s", ""
  $sha = (Gh @("api", "repos/$Repo/contents/${File}?ref=${Branch}", "--jq", ".sha")).Trim()
  $content = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64))
  return @{ content = $content; sha = $sha }
}

function Put-FileContent($content, $sha, $message) {
  $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($content))
  $msg = "[Claude/$By] issues - $message - $(Get-Date -Format dd/MM/yy)"
  $payload = @{ message = $msg; content = $b64; sha = $sha; branch = $Branch } | ConvertTo-Json -Compress
  $pf = Join-Path $env:TEMP "issues_payload.json"
  [IO.File]::WriteAllText($pf, $payload, (New-Object System.Text.UTF8Encoding $false))
  $url = Gh @("api", "repos/$Repo/contents/$File", "-X", "PUT", "--input", $pf, "--jq", ".commit.html_url")
  return $url
}

$fileData = Get-FileContent
$body = $fileData.content
$marker = "<!-- ENTRIES BELOW (newest first) -->"

switch ($Action) {

  "read" {
    $parts = [regex]::Split($body, "(?m)(?=^## #\d{3} )")
    $entries = if ($parts.Count -gt 1) { $parts[1..($parts.Count - 1)] } else { @() }

    if ($Search) {
      $entries = $entries | Where-Object { $_ -match [regex]::Escape($Search) }
    }
    if ($Category) {
      $cat = $Category.ToUpper()
      $entries = $entries | Where-Object { $_ -match "\[$cat\]" }
    }
    if ($Status -ne "all") {
      $needle = if ($Status -eq "open") { "-- OPEN" } else { "-- RESOLVED" }
      $entries = $entries | Where-Object { $_ -match [regex]::Escape($needle) }
    }

    if (-not $entries -or $entries.Count -eq 0) {
      "No matching entries."
      return
    }
    "----- $($entries.Count) entr$(if ($entries.Count -eq 1) { 'y' } else { 'ies' }) -----"
    $entries | ForEach-Object { $_.TrimEnd() }
  }

  "log" {
    if (-not $Category) { throw "log requires -Category" }
    if (-not $Title) { throw "log requires -Title" }
    if (-not $Symptom) { throw "log requires -Symptom" }

    $ids = [regex]::Matches($body, "(?m)^## #(\d{3}) ") | ForEach-Object { [int]$_.Groups[1].Value }
    $nextId = if ($ids) { ($ids | Measure-Object -Maximum).Maximum + 1 } else { 1 }
    $idStr = "{0:D3}" -f $nextId
    $date = (Get-Date).ToString("dd/MM/yy")
    $ctx = if ($Context) { $Context } else { "(none)" }

    $entry = @"
## #$idStr [$($Category.ToUpper())] $Title -- $date -- OPEN
- Logged by: $By
- Symptom: $Symptom
- Context: $ctx
- Resolution: (open)
- Recurrence: 1

"@

    if ($body -notmatch [regex]::Escape($marker)) {
      throw "Marker '$marker' missing in $File. File integrity broken -- fix before logging."
    }
    $new = $body -replace [regex]::Escape($marker), "$marker`n`n$entry"
    $url = Put-FileContent $new $fileData.sha "log #$idStr [$($Category.ToUpper())] $Title"
    "LOGGED #$idStr -> $url"
  }

  "resolve" {
    if (-not $Id) { throw "resolve requires -Id" }
    if (-not $Resolution) { throw "resolve requires -Resolution" }
    $idStr = "{0:D3}" -f $Id
    $date = (Get-Date).ToString("dd/MM/yy")

    $entryRegex = "(?ms)^## #$idStr \[[^\]]+\] [^\r\n]+ -- OPEN.*?(?=^## #\d{3} |\z)"
    $m = [regex]::Match($body, $entryRegex)
    if (-not $m.Success) {
      throw "Issue #$idStr not found or already resolved."
    }

    $block = $m.Value
    $block = $block -replace " -- OPEN", " -- RESOLVED"
    $block = $block -replace "(?m)^- Resolution: \(open\)$", "- Resolution: RESOLVED $date by $By -- $Resolution"

    $new = $body.Substring(0, $m.Index) + $block + $body.Substring($m.Index + $m.Length)
    $url = Put-FileContent $new $fileData.sha "resolve #$idStr"
    "RESOLVED #$idStr -> $url"
  }

  "bump" {
    if (-not $Id) { throw "bump requires -Id" }
    $idStr = "{0:D3}" -f $Id

    $entryRegex = "(?ms)^## #$idStr \[[^\]]+\] [^\r\n]+.*?(?=^## #\d{3} |\z)"
    $m = [regex]::Match($body, $entryRegex)
    if (-not $m.Success) { throw "Issue #$idStr not found." }

    $block = $m.Value
    $bumpPattern = "(?m)^(- Recurrence: )(\d+)$"
    $bm = [regex]::Match($block, $bumpPattern)
    if (-not $bm.Success) { throw "Recurrence line missing in #$idStr -- file format broken." }
    $newCount = [int]$bm.Groups[2].Value + 1
    $block = [regex]::Replace($block, $bumpPattern, "`${1}$newCount")

    $new = $body.Substring(0, $m.Index) + $block + $body.Substring($m.Index + $m.Length)
    $url = Put-FileContent $new $fileData.sha "bump #$idStr to $newCount"
    "BUMPED #$idStr -> recurrence=$newCount -> $url"
  }
}
