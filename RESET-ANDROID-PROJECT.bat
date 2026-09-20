@echo off
cd /d "%~dp0"
echo This deletes only the generated native android folder.
echo Your www files, icon and app.config.bat stay untouched.
pause
if exist android rmdir /s /q android
if exist .last-package.txt del /q .last-package.txt
echo Reset complete. BUILD-APK.bat will regenerate Android next time.
pause
