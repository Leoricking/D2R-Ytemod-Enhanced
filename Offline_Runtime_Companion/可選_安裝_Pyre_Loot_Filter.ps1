$ErrorActionPreference = "Stop"
$game = "C:\Program Files (x86)\Diablo II Resurrected"
$loader = Join-Path $game "d2rloader"
if (-not (Test-Path $loader)) { throw "找不到 d2rloader，請先安裝 D2RLoader。" }

$pluginDir = Join-Path $loader "plugins"
$downloads = Join-Path $PSScriptRoot "downloads"
$zip = Join-Path $downloads "Pyre-Loot-Filter-1.3.1+rev.2-PyreFly.zip"
if (-not (Test-Path $zip)) {
    throw "尚未下載 Pyre Loot Filter。請先執行 安裝_Item_Roll_Ranges.ps1 讓下載檔建立。"
}

$temp = Join-Path $env:TEMP "yte_v451_loot_filter"
Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive -Path $zip -DestinationPath $temp -Force

Get-ChildItem -Path $temp -Recurse -Filter "*.dll" | ForEach-Object {
    Copy-Item $_.FullName -Destination $pluginDir -Force
}

Write-Host "Pyre Loot Filter 已安裝。" -ForegroundColor Green
Write-Host "此插件支援 runtime 條件，如 ethereal / sockets / tier。"
Write-Host "請只在單機 / 離線環境使用。" -ForegroundColor Yellow
