# gsc-fetch.ps1 - pull GSC data for a property from the repo to %TEMP%\gsc\<prop>
# Usage: .\gsc-fetch.ps1 ie    (or: uk | es | pt | analysis | all)
param([Parameter(Mandatory)][string]$Prop,
      [string]$Repo="satanhimself2137/tatkowski-kb",[string]$Branch="main",[int]$TimeoutSec=30)
$ErrorActionPreference="Stop"
$env:GH_PROMPT_DISABLED=1; $env:GIT_TERMINAL_PROMPT=0
$map=@{ ie="ie_tatkowski.com"; uk="uk_tatkowski.co.uk"; es="es_tatkowski.es"; pt="pt_tatkowski.pt"; analysis="_analysis_ie" }
$folders = if($Prop -eq "all"){ "ie_tatkowski.com","uk_tatkowski.co.uk","es_tatkowski.es","pt_tatkowski.pt","_analysis_ie" } elseif($map.ContainsKey($Prop)){ ,$map[$Prop] } else { ,$Prop }
function Gh($a){ $j=Start-Job { param($x) & gh @x 2>&1 } -ArgumentList @(,$a); if(Wait-Job $j -Timeout $TimeoutSec){ $o=Receive-Job $j; Remove-Job $j; $o } else { Stop-Job $j; Remove-Job $j -Force; throw "gh timed out ${TimeoutSec}s" } }
$root=Join-Path $env:TEMP "gsc"
foreach($folder in $folders){
  $list = Gh @("api","repos/$Repo/contents/gsc/${folder}?ref=$Branch","--jq",".[].name")
  $dst = Join-Path $root $folder; New-Item -ItemType Directory -Force -Path $dst | Out-Null
  foreach($name in ($list -split "`n" | Where-Object { $_ })){
    $raw = Gh @("api","repos/$Repo/contents/gsc/$folder/${name}?ref=$Branch","--jq",".content")
    $b64 = (($raw -join "") -replace "\s","")
    [IO.File]::WriteAllBytes((Join-Path $dst $name),[Convert]::FromBase64String($b64))
  }
  Write-Output "fetched gsc/$folder -> $dst"
}
Write-Output "Done. Load CSVs from $root with pandas."
