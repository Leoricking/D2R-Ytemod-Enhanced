$ErrorActionPreference = "Stop"

Write-Host "Ytemod v4.50 OFFLINE Runtime Companion" -ForegroundColor Cyan
Write-Host "用途：單機/離線測試。不要用於 Battle.net 線上角色。" -ForegroundColor Yellow
Write-Host ""

$dest = Join-Path $PSScriptRoot "downloads"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

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
    $out = Join-Path $dest $f.Name
    Write-Host "下載 $($f.Name) ..."
    Invoke-WebRequest -Uri $f.Url -OutFile $out -UseBasicParsing
    $hash = (Get-FileHash -Algorithm SHA256 $out).Hash.ToLowerInvariant()
    if ($hash -ne $f.Sha256) {
        Remove-Item $out -Force -ErrorAction SilentlyContinue
        throw "SHA256 驗證失敗：$($f.Name)`n預期：$($f.Sha256)`n實際：$hash"
    }
    Write-Host "  SHA256 OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "下載完成：" -ForegroundColor Green
Write-Host $dest
Write-Host ""
Write-Host "下一步："
Write-Host "1. 先安裝 D2RLoader（官方 Plugin SDK / Loader 生態）。"
Write-Host "2. 將兩個 ZIP 解壓到 D2RLoader 使用的 active mod 目錄。"
Write-Host "3. Item Roll Ranges：遊戲內按住 Ctrl 顯示 Roll 範圍。"
Write-Host "4. 可用 /AlwaysShowRolls on 讓 Roll 範圍持續顯示。"
Write-Host "5. Pyre Loot Filter 可用 ethereal / sockets 條件建立地面標籤規則。"
Write-Host ""
Write-Host "再次提醒：此 Runtime Companion 只建議離線/單機測試。" -ForegroundColor Yellow
