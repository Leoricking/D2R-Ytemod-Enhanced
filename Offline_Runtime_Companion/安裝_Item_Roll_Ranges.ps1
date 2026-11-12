$ErrorActionPreference = "Stop"

Write-Host "Ytemod v4.51 OFFLINE Runtime Companion" -ForegroundColor Cyan
Write-Host "用途：單機 / 離線測試。不要用於 Battle.net 線上角色。" -ForegroundColor Yellow
Write-Host ""

$game = "C:\Program Files (x86)\Diablo II Resurrected"
if (-not (Test-Path $game)) {
    throw "找不到 D2R 預設路徑：$game"
}

$loader = Join-Path $game "d2rloader"
if (-not (Test-Path $loader)) {
    Write-Host "尚未偵測到 d2rloader 目錄。" -ForegroundColor Yellow
    Write-Host "請先安裝 D2RLoader，再重新執行此腳本。"
    exit 1
}

$pluginDir = Join-Path $loader "plugins"
$configDir = Join-Path $loader "config"
New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

$downloads = Join-Path $PSScriptRoot "downloads"
New-Item -ItemType Directory -Force -Path $downloads | Out-Null

$files = @(
    @{
        Name = "Item-Roll-Ranges-1.3.1+rev.56-PyreFly.zip"
        Url  = "https://github.com/Pyre-Flies/D2R-Mods/releases/download/release-2026.10.29.1/Item-Roll-Ranges-1.3.1%2Brev.56-PyreFly.zip"
        Sha256 = "8a6bb4612d83fe6c0c7253f42809702ff4521a4bf5b01d47645e31ffb3ed59e1"
    },
    @{
        Name = "Pyre-Loot-Filter-1.3.1+rev.2-PyreFly.zip"
        Url  = "https://github.com/Pyre-Flies/D2R-Mods/releases/download/release-2026.10.29.1/Pyre-Loot-Filter-1.3.1%2Brev.2-PyreFly.zip"
        Sha256 = "bde52301b5d7b7771e6149fe98e2eecc4cd767dcbdadfed96cf80f87e5d7a4f9"
    }
)

foreach ($f in $files) {
    $out = Join-Path $downloads $f.Name
    if (-not (Test-Path $out)) {
        Write-Host "下載 $($f.Name) ..."
        Invoke-WebRequest -Uri $f.Url -OutFile $out -UseBasicParsing
    }
    $hash = (Get-FileHash -Algorithm SHA256 $out).Hash.ToLowerInvariant()
    if ($hash -ne $f.Sha256) {
        Remove-Item $out -Force -ErrorAction SilentlyContinue
        throw "SHA256 驗證失敗：$($f.Name)`n預期：$($f.Sha256)`n實際：$hash"
    }
    Write-Host "SHA256 OK: $($f.Name)" -ForegroundColor Green
}

# Install Item Roll Ranges only by default
$irr = Join-Path $downloads "Item-Roll-Ranges-1.3.1+rev.56-PyreFly.zip"
$tempIrr = Join-Path $env:TEMP "yte_v451_item_roll_ranges"
Remove-Item $tempIrr -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive -Path $irr -DestinationPath $tempIrr -Force

Get-ChildItem -Path $tempIrr -Recurse -Filter "*.dll" | ForEach-Object {
    Copy-Item $_.FullName -Destination $pluginDir -Force
}

# Item Roll Ranges config: always show ranges
@"
[display]
always_show_ranges = true
"@ | Set-Content -Encoding UTF8 (Join-Path $configDir "item-roll-ranges.toml")

# Ensure D2RCore native range support in effective config, if config exists.
$coreConfig = Join-Path $configDir "d2rloader.toml"
if (Test-Path $coreConfig) {
    $txt = Get-Content $coreConfig -Raw
    if ($txt -match "(?ms)^\[d2rcore\.items\].*?item_stat_ranges\s*=") {
        $txt = [regex]::Replace(
            $txt,
            "(?ms)(^\[d2rcore\.items\].*?item_stat_ranges\s*=\s*)\w+",
            '${1}true'
        )
    } elseif ($txt -match "(?m)^\[d2rcore\.items\]\s*$") {
        $txt = [regex]::Replace(
            $txt,
            "(?m)^\[d2rcore\.items\]\s*$",
            "[d2rcore.items]`r`nitem_stat_ranges = true"
        )
    } else {
        $txt += "`r`n[d2rcore.items]`r`nitem_stat_ranges = true`r`n"
    }
    Set-Content -Encoding UTF8 $coreConfig $txt
} else {
    @"
[d2rcore.items]
item_stat_ranges = true
"@ | Set-Content -Encoding UTF8 $coreConfig
}

Write-Host ""
Write-Host "Item Roll Ranges 已安裝完成。" -ForegroundColor Green
Write-Host "預設：always_show_ranges = true"
Write-Host ""
Write-Host "Pyre Loot Filter 沒有自動安裝。" -ForegroundColor Yellow
Write-Host "原因：避免一口氣啟用兩個 runtime plugin，先驗證 Roll Range 穩定性。"
Write-Host ""
Write-Host "驗收："
Write-Host "1. 用 D2RLoader 啟動單機角色"
Write-Host "2. 打開暗金 / 黃裝 / 藍裝 / 符文組 Tooltip"
Write-Host "3. 有可靠 min/max 的屬性應顯示範圍"
Write-Host "4. 若遇到 ? 或 (?) 代表該來源無法可靠反推，不應強行顯示假範圍"
