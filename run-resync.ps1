$ErrorActionPreference = 'Stop'

$javaHome = 'C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot'
$sdkRoot = Join-Path $env:LOCALAPPDATA 'Android\Sdk'
$avdName = 'ResyncPixel'
$deviceId = 'emulator-5554'

$env:JAVA_HOME = $javaHome
$env:ANDROID_SDK_ROOT = $sdkRoot
$env:ANDROID_HOME = $sdkRoot
$env:Path = "$javaHome\bin;$sdkRoot\platform-tools;$sdkRoot\emulator;$env:LOCALAPPDATA\flutter\bin;$env:Path"

$emulatorExe = Join-Path $sdkRoot 'emulator\emulator.exe'
$adbExe = Join-Path $sdkRoot 'platform-tools\adb.exe'

if (-not (Test-Path $emulatorExe)) {
    throw "Android emulator not found at $emulatorExe"
}

if (-not (Test-Path $adbExe)) {
    throw "adb not found at $adbExe"
}

$devices = & $adbExe devices
$deviceOnline = $devices -match "^$deviceId\s+device$"

if (-not $deviceOnline) {
    Start-Process -FilePath $emulatorExe -ArgumentList @('-avd', $avdName, '-no-snapshot', '-no-boot-anim')
}

& $adbExe -s $deviceId wait-for-device | Out-Null

do {
    $bootCompleted = (& $adbExe -s $deviceId shell getprop sys.boot_completed).Trim()
    if ($bootCompleted -ne '1') {
        Start-Sleep -Seconds 2
    }
} while ($bootCompleted -ne '1')

flutter run -d $deviceId