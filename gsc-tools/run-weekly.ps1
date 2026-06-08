# run-weekly.ps1 - Tatkowski GSC weekly job. Invoked by Task Scheduler (Sundays 14:00).
# Flow: pull GSC -> export CSVs -> sync to repo gsc/ (idempotent). Logs to .\logs\.
$ErrorActionPreference = "Stop"
$root = "D:\tatkowski-gsc"
Set-Location $root
$logDir = Join-Path $root "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$log = Join-Path $logDir "weekly_$stamp.log"

function Log($m){ $line = "{0}  {1}" -f (Get-Date -Format "HH:mm:ss"), $m; $line | Tee-Object -FilePath $log -Append }

Log "=== GSC weekly job start ==="
try {
  Log "STEP 1/3 pull"
  npm run pull   2>&1 | Tee-Object -FilePath $log -Append
  Log "STEP 2/3 export"
  npm run export 2>&1 | Tee-Object -FilePath $log -Append
  Log "STEP 3/3 sync to repo"
  python (Join-Path $root "gsc-sync.py") --by Maciej 2>&1 | Tee-Object -FilePath $log -Append
  Log "=== done OK ==="
} catch {
  Log "ERROR: $_"
  Log "=== done WITH ERRORS ==="
  exit 1
}
