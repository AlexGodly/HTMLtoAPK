@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title HTML to Android APK Builder

if not exist "app.config.bat" (
  echo ERROR: app.config.bat is missing.
  pause
  exit /b 1
)
call "app.config.bat"

echo.
echo ============================================================
echo             HTML to Android APK Builder
echo ============================================================
echo App:      %APP_NAME%
echo Package:  %PACKAGE_NAME%
echo Version:  %VERSION_NAME% ^(%VERSION_CODE%^)
echo Output:   %APK_NAME%
echo ============================================================
echo.

if not exist "www\index.html" (
  echo ERROR: Put your app at www\index.html first.
  pause
  exit /b 1
)

REM ---- Find a real JDK ----
set "JDK="
if defined JAVA_HOME if exist "%JAVA_HOME%\bin\java.exe" if exist "%JAVA_HOME%\bin\javac.exe" set "JDK=%JAVA_HOME%"
if not defined JDK for /d %%J in ("C:\Program Files\Eclipse Adoptium\jdk-*") do if exist "%%~fJ\bin\javac.exe" set "JDK=%%~fJ"
if not defined JDK for /d %%J in ("C:\Program Files\Java\jdk-*") do if exist "%%~fJ\bin\javac.exe" set "JDK=%%~fJ"
if not defined JDK for /d %%J in ("C:\Program Files\Microsoft\jdk-*") do if exist "%%~fJ\bin\javac.exe" set "JDK=%%~fJ"
if not defined JDK (
  echo ERROR: A Java JDK was not found. Install Temurin JDK 21, then rerun.
  pause
  exit /b 1
)
set "JAVA_HOME=%JDK%"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo [1/9] Java: %JAVA_HOME%

where node.exe >nul 2>&1 || (echo ERROR: Node.js is required.& pause & exit /b 1)
echo [2/9] Node found.

call npm install
if errorlevel 1 (echo ERROR: npm install failed.& pause & exit /b 1)

REM ---- Generate Capacitor config from editable settings ----
> capacitor.config.json echo {
>>capacitor.config.json echo   "appId": "%PACKAGE_NAME%",
>>capacitor.config.json echo   "appName": "%APP_NAME%",
>>capacitor.config.json echo   "webDir": "www"
>>capacitor.config.json echo }

REM ---- Recreate native project if package changed ----
set "OLD_PACKAGE="
if exist ".last-package.txt" set /p OLD_PACKAGE=<".last-package.txt"
if exist "android\gradlew.bat" if /I not "!OLD_PACKAGE!"=="%PACKAGE_NAME%" (
  echo [3/9] Package changed. Recreating native Android project...
  rmdir /s /q android
)
if not exist "android\gradlew.bat" (
  echo [3/9] Creating native Android project...
  call npx cap add android
  if errorlevel 1 (echo ERROR: Could not create Android project.& pause & exit /b 1)
) else echo [3/9] Native Android project ready.
> ".last-package.txt" echo %PACKAGE_NAME%

REM ---- Android SDK: install command line tools if missing ----
set "SDK=%LOCALAPPDATA%\Android\Sdk"
set "ANDROID_HOME=%SDK%"
set "ANDROID_SDK_ROOT=%SDK%"
set "SDKMANAGER=%SDK%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMANAGER%" (
  echo [4/9] Android SDK missing. Installing command-line tools...
  if not exist "%SDK%\cmdline-tools" mkdir "%SDK%\cmdline-tools"
  set "ZIP=%TEMP%\android-cmdline-tools.zip"
  set "TMP=%TEMP%\htmlapk-tools"
  if exist "!ZIP!" del /q "!ZIP!"
  if exist "!TMP!" rmdir /s /q "!TMP!"
  curl.exe -L --fail --retry 3 -o "!ZIP!" "https://dl.google.com/android/repository/commandlinetools-win-13114758_latest.zip"
  if errorlevel 1 (echo ERROR: Android tools download failed.& pause & exit /b 1)
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '!ZIP!' -DestinationPath '!TMP!' -Force"
  if exist "%SDK%\cmdline-tools\latest" rmdir /s /q "%SDK%\cmdline-tools\latest"
  mkdir "%SDK%\cmdline-tools\latest"
  xcopy "!TMP!\cmdline-tools\*" "%SDK%\cmdline-tools\latest\" /E /I /H /Y >nul
  del /q "!ZIP!" >nul 2>&1
  rmdir /s /q "!TMP!" >nul 2>&1
) else echo [4/9] Android SDK command-line tools ready.

set "PATH=%SDK%\platform-tools;%SDK%\cmdline-tools\latest\bin;%PATH%"
(
for /l %%A in (1,1,100) do @echo y
)>"%TEMP%\htmlapk-yes.txt"
call "%SDKMANAGER%" --sdk_root="%SDK%" --licenses < "%TEMP%\htmlapk-yes.txt" >nul
call "%SDKMANAGER%" --sdk_root="%SDK%" "platform-tools" "platforms;android-35" "build-tools;35.0.0"
if errorlevel 1 (echo ERROR: Android SDK package installation failed.& pause & exit /b 1)
del "%TEMP%\htmlapk-yes.txt" >nul 2>&1
set "SDK_ESC=%SDK:\=\\%"
>"android\local.properties" echo sdk.dir=%SDK_ESC%
echo [5/9] Android SDK configured.

REM ---- Sync web app ----
call npx cap sync android
if errorlevel 1 (echo ERROR: Capacitor sync failed.& pause & exit /b 1)
echo [6/9] HTML synced.

REM ---- Apply app name and versions ----
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$p='android\app\src\main\res\values\strings.xml'; [xml]$x=Get-Content $p; $n=$x.resources.string ^| ? {$_.name -eq 'app_name'}; if($n){$n.'#text'='%APP_NAME%'}; $x.Save((Resolve-Path $p))"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$p='android\app\build.gradle'; $s=Get-Content $p -Raw; $s=[regex]::Replace($s,'versionCode\s+\d+','versionCode %VERSION_CODE%'); $s=[regex]::Replace($s,'versionName\s+\"[^\"]*\"','versionName \"%VERSION_NAME%\"'); Set-Content $p $s -Encoding UTF8"
echo [7/9] Name/version applied.

REM ---- Apply icon if provided ----
if exist "%ICON_FILE%" (
  echo Applying icon: %ICON_FILE%
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
   "Add-Type -AssemblyName System.Drawing; $src=[System.Drawing.Image]::FromFile((Resolve-Path '%ICON_FILE%')); $sizes=@{'mipmap-mdpi'=48;'mipmap-hdpi'=72;'mipmap-xhdpi'=96;'mipmap-xxhdpi'=144;'mipmap-xxxhdpi'=192}; foreach($k in $sizes.Keys){$d='android\app\src\main\res\'+$k; New-Item -ItemType Directory -Force $d ^| Out-Null; $n=$sizes[$k]; $b=New-Object System.Drawing.Bitmap($n,$n); $g=[System.Drawing.Graphics]::FromImage($b); $g.InterpolationMode='HighQualityBicubic'; $g.DrawImage($src,0,0,$n,$n); $g.Dispose(); $b.Save((Join-Path $d 'ic_launcher.png'),[System.Drawing.Imaging.ImageFormat]::Png); $b.Save((Join-Path $d 'ic_launcher_round.png'),[System.Drawing.Imaging.ImageFormat]::Png); $b.Dispose()}; $src.Dispose(); Remove-Item 'android\app\src\main\res\mipmap-anydpi-v26\ic_launcher.xml' -Force -ErrorAction SilentlyContinue; Remove-Item 'android\app\src\main\res\mipmap-anydpi-v26\ic_launcher_round.xml' -Force -ErrorAction SilentlyContinue"
) else echo No icon found at %ICON_FILE% - keeping default icon.
echo [8/9] Icon step complete.

REM ---- Build ----
pushd android
call gradlew.bat assembleDebug
set "BUILD_RESULT=%ERRORLEVEL%"
popd
if not "%BUILD_RESULT%"=="0" (echo ERROR: Gradle build failed.& pause & exit /b 1)

set "BUILT=android\app\build\outputs\apk\debug\app-debug.apk"
if not exist "%BUILT%" (echo ERROR: Build completed but APK was not found.& pause & exit /b 1)
copy /Y "%BUILT%" "%APK_NAME%" >nul

echo.
echo ============================================================
echo                    BUILD SUCCESSFUL
echo ============================================================
echo App:     %APP_NAME%
echo Package: %PACKAGE_NAME%
echo Version: %VERSION_NAME% ^(%VERSION_CODE%^)
echo APK:     %CD%\%APK_NAME%
echo ============================================================
explorer.exe /select,"%CD%\%APK_NAME%"
pause
