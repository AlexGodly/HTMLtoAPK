HTML -> ANDROID APK BUILDER
===========================

QUICK USE
1. Put your web app in the www folder. The entry file MUST be www\index.html.
   You may also put CSS, JS, images, fonts, subfolders, etc. inside www.
2. Replace assets\icon.png with your square PNG icon (1024x1024 recommended).
3. Open app.config.bat and change:
      APP_NAME
      PACKAGE_NAME
      VERSION_NAME
      VERSION_CODE
      APK_NAME
      ICON_FILE
4. Double-click BUILD-APK.bat.
5. Your APK appears in this main folder.

UPDATING AN EXISTING APP
- Replace/edit www\index.html and any other files in www.
- Increase VERSION_CODE every release.
- Change VERSION_NAME to the user-facing version you want.
- KEEP PACKAGE_NAME THE SAME if the APK should update the already-installed app.
- Run BUILD-APK.bat again.

MAKING A COMPLETELY DIFFERENT APP
- Replace everything in www with the other web app.
- Change APP_NAME and PACKAGE_NAME in app.config.bat.
- Replace assets\icon.png.
- Run BUILD-APK.bat.
- The builder detects the package change and regenerates the native Android project.

PACKAGE NAME RULES
Use a reverse-domain style ID, lowercase, no spaces. Example:
  com.alexgodly.mediaflow
  com.alexgodly.myapp

ICON
Use a square PNG. 1024x1024 is recommended. The builder creates Android density icons automatically.

VERSIONING
VERSION_CODE must be a whole number and must increase for updates:
  1, 2, 3, 4...
VERSION_NAME can be whatever release label you want:
  1.0.0
  1.1
  2.0-beta

REQUIREMENTS
- Windows
- Node.js/npm
- Java JDK (JDK 21 recommended)
- Internet on first build
The script installs/configures Android command-line SDK tools when needed. Android Studio is not required.

IMPORTANT LIMITATIONS
This is a WebView/Capacitor wrapper. Normal HTML/CSS/JS works well, but browser features that depend on a normal http/https origin, browser extensions, popups, unsupported native APIs, or special file permissions may need app-specific Capacitor/native changes.

SIGNING
BUILD-APK.bat creates a debug APK for direct testing/installing. A production/Play Store release needs a release keystore and signed release APK/AAB.
