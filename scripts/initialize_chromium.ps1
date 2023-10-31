mkdir c:\src\
mkdir c:\src\chromium
Invoke-WebRequest “https://storage.googleapis.com/chrome-infra/depot_tools.zip” -OutFile “C:\src\depot_tools.zip”
Expand-Archive -Path “C:\src\depot_tools.zip” -DestinationPath “C:\src\depot_tools” -Force
[Environment]::SetEnvironmentVariable(“PATH”, $env:Path + “;C:\src\depot_tools”, “Machine”)
$env:Path = $env:Path + “;C:\src\depot_tools”
[Environment]::SetEnvironmentVariable("DEPOT_TOOLS_WIN_TOOLCHAIN", 0, "Machine")
$env:DEPOT_TOOLS_WIN_TOOLCHAIN=0
git config –global user.name “GigaOm”
git config –global user.email “benchmarks@GigaOm.com”
git config –global core.autocrlf false
git config –global core.filemode false
git config –global branch.autosetuprebase always
git config –global –add safe.directory “*”
$installer = “C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe”
& $installer modify --installPath "C:\Program Files\Microsoft Visual Studio\2022\Enterprise" --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.ATLMFC --includeRecommended --quiet
Invoke-WebRequest “https://download.microsoft.com/download/b/8/5/b85bd06f-491c-4c1c-923e-75ce2fe2378e/windowssdk/winsdksetup.exe” -OutFile “C:\src\winsdksetup.exe”
& “C:\src\winsdksetup.exe” /features + /q /norestart
Set-Location “C:\src\chromium”
gclient sync
fetch chromium
gn gen out\Default
autoninja -C “out\Default” chrome
