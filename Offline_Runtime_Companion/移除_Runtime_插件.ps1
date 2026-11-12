$ErrorActionPreference = "Stop"
$game = "C:\Program Files (x86)\Diablo II Resurrected"
$pluginDir = Join-Path $game "d2rloader\plugins"
$configDir = Join-Path $game "d2rloader\config"

if (Test-Path $pluginDir) {
    Get-ChildItem $pluginDir -Filter "*item*roll*range*.dll" -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem $pluginDir -Filter "*pyre*loot*filter*.dll" -ErrorAction SilentlyContinue | Remove-Item -Force
}
Remove-Item (Join-Path $configDir "item-roll-ranges.toml") -Force -ErrorAction SilentlyContinue

Write-Host "Runtime Companion 插件已移除。" -ForegroundColor Green
Write-Host "Ytemod 主包本身不受影響。"
