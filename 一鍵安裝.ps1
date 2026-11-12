$ErrorActionPreference = "Stop"

function Say($msg, $color="Gray") {
    Write-Host $msg -ForegroundColor $color
}

Say "Ytemod v4.52 Rossi - 一鍵安裝" "Cyan"
Say "用途：主 Ytemod + D2RLoader + Item Roll Ranges + Pyre Loot Filter" "Cyan"
Say "Runtime 插件建議只用於單機 / 離線。不要用於 Battle.net 線上角色。" "Yellow"
Write-Host ""

# ---- Locate D2R ----
$candidates = @(
    "C:\Program Files (x86)\Diablo II Resurrected",
    "C:\Program Files\Diablo II Resurrected"
)

# Try Battle.net uninstall registry entries too
$regRoots = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
foreach ($rr in $regRoots) {
    try {
        Get-ItemProperty $rr -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "*Diablo II*Resurrected*" } |
            ForEach-Object {
                if ($_.InstallLocation) { $candidates += $_.InstallLocation }
            }
    } catch {}
}

$game = $null
foreach ($c in ($candidates | Select-Object -Unique)) {
    if ($c -and (Test-Path (Join-Path $c "D2R.exe"))) {
        $game = $c
        break
    }
}

if (-not $game) {
    Add-Type -AssemblyName System.Windows.Forms
    $dlg = New-Object System.Windows.Forms.FolderBrowserDialog
    $dlg.Description = "選擇 Diablo II Resurrected 安裝資料夾（裡面要有 D2R.exe）"
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        throw "沒有選擇 D2R 資料夾。"
    }
    $game = $dlg.SelectedPath
    if (-not (Test-Path (Join-Path $game "D2R.exe"))) {
        throw "選擇的資料夾裡找不到 D2R.exe：$game"
    }
}
Say "D2R 路徑：$game" "Green"

# ---- Install Ytemod ----
$sourceYte = Join-Path $PSScriptRoot "Mods\yte"
if (-not (Test-Path $sourceYte)) {
    throw "安裝包缺少 Mods\yte。請確認 ZIP 有完整解壓。"
}
$modsDir = Join-Path $game "Mods"
$destYte = Join-Path $modsDir "yte"
New-Item -ItemType Directory -Force -Path $modsDir | Out-Null
if (Test-Path $destYte) {
    Say "移除舊版 Mods\yte ..." "DarkGray"
    Remove-Item $destYte -Recurse -Force
}
Say "安裝 Ytemod 主包 ..." "Gray"
Copy-Item $sourceYte $destYte -Recurse -Force
if (-not (Test-Path (Join-Path $destYte "yte.mpq"))) {
    throw "Ytemod 安裝失敗：找不到 Mods\yte\yte.mpq"
}
Say "Ytemod 主包 OK" "Green"

# ---- Working download folder ----
$dl = Join-Path $env:TEMP "Ytemod_v452_setup"
Remove-Item $dl -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $dl | Out-Null

function Download-Verified($Name, $Url, $Sha256) {
    $out = Join-Path $dl $Name
    Say "下載 $Name ..." "Gray"
    Invoke-WebRequest -Uri $Url -OutFile $out -UseBasicParsing
    $hash = (Get-FileHash -Algorithm SHA256 $out).Hash.ToLowerInvariant()
    if ($hash -ne $Sha256.ToLowerInvariant()) {
        Remove-Item $out -Force -ErrorAction SilentlyContinue
        throw "SHA256 驗證失敗：$Name`n預期：$Sha256`n實際：$hash"
    }
    Say "  SHA256 OK" "Green"
    return $out
}

# ---- Install / update D2RLoader ----
$loaderExe = Join-Path $game "D2RLoader.exe"
if (-not (Test-Path $loaderExe)) {
    $installer = Download-Verified `
        "D2RLoader-Installer-0.1.0-unsigned.exe" `
        "https://github.com/D2RLoader/Installer/releases/download/v0.1.0/D2RLoader-Installer-0.1.0-unsigned.exe" `
        "a83122f95b4b594917f85b952abae765eff58f2767538e64e2f99f720f8283ee"

    Say "靜默安裝 D2RLoader ..." "Gray"
    $p = Start-Process -FilePath $installer `
        -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/DIR=$game", "/LANG=chinesetraditional" `
        -Wait -PassThru
    if ($p.ExitCode -ne 0) {
        throw "D2RLoader 安裝器失敗，ExitCode=$($p.ExitCode)"
    }
} else {
    Say "已偵測到 D2RLoader，保留現有安裝。" "Green"
}
if (-not (Test-Path $loaderExe)) {
    throw "D2RLoader 安裝後仍找不到：$loaderExe"
}
Say "D2RLoader OK" "Green"

# ---- Download and install Item Roll Ranges ----
$irrZip = Download-Verified `
    "Item-Roll-Ranges-1.3.1+rev.56-PyreFly.zip" `
    "https://github.com/Pyre-Flies/D2R-Mods/releases/download/release-2026.10.29.1/Item-Roll-Ranges-1.3.1%2Brev.56-PyreFly.zip" `
    "8a6bb4612d83fe6c0c7253f42809702ff4521a4bf5b01d47645e31ffb3ed59e1"

$irrTemp = Join-Path $dl "irr"
Expand-Archive -Path $irrZip -DestinationPath $irrTemp -Force
Say "安裝 Item Roll Ranges ..." "Gray"
Get-ChildItem $irrTemp -Force | ForEach-Object {
    Copy-Item $_.FullName $game -Recurse -Force
}

# ---- Download and install Pyre Loot Filter ----
$lfZip = Download-Verified `
    "Pyre-Loot-Filter-1.3.1+rev.2-PyreFly.zip" `
    "https://github.com/Pyre-Flies/D2R-Mods/releases/download/release-2026.10.29.1/Pyre-Loot-Filter-1.3.1%2Brev.2-PyreFly.zip" `
    "bde52301b5d7b7771e6149fe98e2eecc4cd767dcbdadfed96cf80f87e5d7a4f9"

$lfTemp = Join-Path $dl "loot"
Expand-Archive -Path $lfZip -DestinationPath $lfTemp -Force
Say "安裝 Pyre Loot Filter ..." "Gray"
Get-ChildItem $lfTemp -Force | ForEach-Object {
    Copy-Item $_.FullName $game -Recurse -Force
}

# ---- Configure runtime ranges ----
$configDir = Join-Path $game "d2rloader\config"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

@"
[display]
always_show_ranges = true
"@ | Set-Content -Encoding UTF8 (Join-Path $configDir "item-roll-ranges.toml")

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

# ---- Create desktop shortcut ----
try {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $ws = New-Object -ComObject WScript.Shell
    $sc = $ws.CreateShortcut((Join-Path $desktop "D2RLoader - Ytemod Offline.lnk"))
    $sc.TargetPath = $loaderExe
    $sc.WorkingDirectory = $game
    $sc.Description = "D2RLoader + Ytemod v4.52 (Offline Runtime)"
    $sc.Save()
    Say "桌面捷徑建立完成。" "Green"
} catch {
    Say "桌面捷徑建立失敗，但不影響安裝。" "Yellow"
}

# ---- Summary ----
Write-Host ""
Say "===== 安裝完成 =====" "Green"
Say "Ytemod：$destYte" "Green"
Say "D2RLoader：$loaderExe" "Green"
Say "Item Roll Ranges：已安裝，預設常駐顯示 Range" "Green"
Say "Pyre Loot Filter：已安裝" "Green"
Write-Host ""
Say "重要：" "Yellow"
Say "Runtime 插件會 hook 遊戲執行檔，建議只在單機 / 離線角色使用。" "Yellow"
Say "Battle.net 線上角色請仍用一般 Battle.net 啟動方式，不要透過此 Runtime Companion。" "Yellow"
Write-Host ""

# Open loader
Start-Process $loaderExe
