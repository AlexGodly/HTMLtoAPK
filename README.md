# HTML to Android APK Builder

A reusable Windows project for turning an HTML/CSS/JavaScript web app
into an installable Android APK using Capacitor.

The goal is simple: put your web app in the `www` folder, configure the
app name/package/version/icon, run one BAT file, and let the builder
handle the Android build process.

## What This Project Does

The builder is designed so you do **not** need to create a new Android
project every time you make a web app.

You can use the same project for:

-   MediaFlow
-   dashboards
-   trackers
-   utilities
-   offline web apps
-   HTML/CSS/JavaScript projects
-   other browser-based apps that can run inside a Capacitor WebView

The basic workflow is:

1.  Put your web app inside `www`.
2.  Replace the app icon.
3.  Edit `app.config.bat`.
4.  Double-click `BUILD-APK.bat`.
5.  Get your APK.

## How to Use

This is the quickest way to use the builder from start to finish.

### First-Time Setup

1.  Extract the entire **HTML-to-Android-APK-Builder** folder somewhere
    on your Windows PC.
2.  Make sure **Node.js** and a full **Java JDK** are installed.
3.  Open the `www` folder.
4.  Delete or replace the example files and put your own web app there.
    Your main page must be named:

``` text
www/index.html
```

5.  Put your app icon at:

``` text
assets/icon.png
```

A square PNG such as **1024 × 1024** is recommended.

6.  Open `app.config.bat` in Notepad and change the app settings:

``` bat
set "APP_NAME=My App"
set "PACKAGE_NAME=com.yourname.myapp"
set "VERSION_NAME=1.0.0"
set "VERSION_CODE=1"
set "APK_NAME=My-App.apk"
set "ICON_FILE=assets\icon.png"
```

7.  Save `app.config.bat`.
8.  Double-click:

``` text
BUILD-APK.bat
```

9.  Keep the command window open while the builder works. On the first
    run it may download Android SDK/Gradle components, so it can take
    longer.
10. When the build finishes successfully, find the generated `.apk` file
    in the project folder and copy it to your Android phone.
11. Open the APK on your phone and install it. Android may ask you to
    allow installation from your browser/file manager because the APK
    was installed outside Google Play.

### For Every New Update

You do **not** need to recreate the whole project.

1.  Replace or edit your files inside `www`.
2.  Keep the same `PACKAGE_NAME` if this is an update to the same
    Android app.
3.  Change `VERSION_NAME` to the new visible version.
4.  Increase `VERSION_CODE` by at least 1.
5.  Change `APK_NAME` if you want the output filename to show the new
    version.
6.  Replace `assets/icon.png` only if you want a new icon.
7.  Double-click `BUILD-APK.bat` again.
8.  Install the new APK over the previous version.

Example:

``` bat
REM Old release
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.0.0"
set "VERSION_CODE=1"

REM New release
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.1.0"
set "VERSION_CODE=2"
```

The package name stays the same, while the version changes.

### For a Completely Different App

If you want to reuse the builder for another project:

1.  Replace everything in `www` with the other web app.
2.  Change `APP_NAME`.
3.  Choose a new unique `PACKAGE_NAME`.
4.  Reset `VERSION_NAME` and `VERSION_CODE` for the new app.
5.  Replace the icon.
6.  If the existing generated Android project belongs to the previous
    package/app identity, run `RESET-ANDROID-PROJECT.bat`.
7.  Run `BUILD-APK.bat`.

### Example: MediaFlow

For MediaFlow, your folder can look like:

``` text
HTML-to-Android-APK-Builder/
├── www/
│   └── index.html          ← your latest MediaFlow HTML
├── assets/
│   └── icon.png            ← MediaFlow icon
├── app.config.bat
└── BUILD-APK.bat
```

And `app.config.bat` could contain:

``` bat
set "APP_NAME=MediaFlow"
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.1.0"
set "VERSION_CODE=2"
set "APK_NAME=MediaFlow-v38.apk"
set "ICON_FILE=assets\icon.png"
```

Then simply double-click `BUILD-APK.bat`.

### Quick Version

``` text
Put app in www/
        ↓
Make sure www/index.html exists
        ↓
Put icon in assets/icon.png
        ↓
Edit app.config.bat
        ↓
Double-click BUILD-APK.bat
        ↓
Wait for BUILD SUCCESSFUL
        ↓
Install the generated APK
```

## Project Structure

``` text
HTML-to-Android-APK-Builder/
│
├── www/
│   └── index.html
│
├── assets/
│   └── icon.png
│
├── app.config.bat
├── BUILD-APK.bat
├── RESET-ANDROID-PROJECT.bat
└── README.md
```

The builder may also create folders such as `android/` and
`node_modules/` during setup/building.

## Requirements

The builder is intended for Windows.

You need:

-   Node.js and npm
-   A Java JDK
-   Internet access for the initial Android/Gradle dependency downloads

Android Studio is **not required** for the command-line build workflow.

The Android SDK command-line tools and build dependencies may need to be
downloaded during initial setup. The first build can therefore take
significantly longer than later builds.

## 1. Add Your Web App

Place your web application inside:

``` text
www/
```

The entry point must be:

``` text
www/index.html
```

For a single-file app, simply replace `www/index.html`.

For a multi-file web app, copy the whole project into `www`, for
example:

``` text
www/
├── index.html
├── style.css
├── app.js
├── images/
└── data/
```

Use relative paths in your HTML whenever possible.

## 2. Configure the Android App

Open:

``` text
app.config.bat
```

Configure values such as:

``` bat
set "APP_NAME=MediaFlow"
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.0.0"
set "VERSION_CODE=1"
set "APK_NAME=MediaFlow-1.0.0.apk"
set "ICON_FILE=assets\icon.png"
```

### APP_NAME

The name displayed for the application.

Example:

``` bat
set "APP_NAME=MediaFlow"
```

### PACKAGE_NAME

The unique Android application ID.

Example:

``` bat
set "PACKAGE_NAME=com.alexgodly.mediaflow"
```

Use a reverse-domain-style identifier containing lowercase
letters/names.

For example:

``` text
com.alexgodly.mediaflow
com.alexgodly.animetracker
com.alexgodly.myapp
```

**Important:** keep the same package name when publishing an update to
an existing app. Changing the package name makes Android treat it as a
different application.

### VERSION_NAME

The human-readable version.

Example:

``` bat
set "VERSION_NAME=1.2.0"
```

Examples:

``` text
1.0.0
1.1.0
2.0.0
```

### VERSION_CODE

Android's internal version number.

Example:

``` bat
set "VERSION_CODE=4"
```

Increase this integer for every new release that should update an older
installation.

Example:

``` text
Release 1 → VERSION_CODE=1
Release 2 → VERSION_CODE=2
Release 3 → VERSION_CODE=3
```

Do not reuse a lower version code for a newer published update.

### APK_NAME

The desired output filename.

Example:

``` bat
set "APK_NAME=MediaFlow-v38.apk"
```

### ICON_FILE

The source image used for the Android launcher icon.

Example:

``` bat
set "ICON_FILE=assets\icon.png"
```

A high-resolution square PNG, such as **1024 × 1024**, is recommended.

## 3. Build the APK

Double-click:

``` text
BUILD-APK.bat
```

The builder handles the required project setup and build steps,
including tasks such as:

-   validating Java
-   checking Node.js/npm
-   installing project dependencies
-   creating/checking the Capacitor Android project
-   configuring the Android SDK
-   synchronizing `www` with Android
-   applying configured app information
-   preparing launcher icon resources
-   running the Gradle APK build
-   copying the finished APK to an easy-to-find location

The first build can take several minutes because Gradle and Android
dependencies may need to be downloaded.

Do not close the terminal while the initial downloads/build are running.

## Updating an Existing App

For a normal update, you generally only need to:

1.  Replace/update the files in `www`.
2.  Change `VERSION_NAME`.
3.  Increase `VERSION_CODE`.
4.  Optionally change the icon or visible app name.
5.  Run `BUILD-APK.bat` again.

Example:

### Version 1

``` bat
set "APP_NAME=MediaFlow"
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.0.0"
set "VERSION_CODE=1"
set "APK_NAME=MediaFlow-v1.apk"
```

### Version 2

``` bat
set "APP_NAME=MediaFlow"
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.1.0"
set "VERSION_CODE=2"
set "APK_NAME=MediaFlow-v2.apk"
```

Notice that the package name stays the same.

## Using the Builder for a Different App

You can reuse the project for a completely different web app.

For example:

``` bat
set "APP_NAME=Anime Tracker"
set "PACKAGE_NAME=com.alexgodly.animetracker"
set "VERSION_NAME=1.0.0"
set "VERSION_CODE=1"
set "APK_NAME=AnimeTracker.apk"
set "ICON_FILE=assets\icon.png"
```

Then replace the contents of `www` with the Anime Tracker web app and
build again.

If you change the package identity and need a fresh native project, use
the included reset workflow as appropriate.

## RESET-ANDROID-PROJECT.bat

This utility is intended for cases where the generated native Android
project needs to be recreated, especially after changing fundamental
application identity/configuration.

Do **not** reset the Android project for every HTML update.

For normal releases, keep the existing Android project and simply update
`www`, increment the version, and rebuild.

## Where Is the APK?

After a successful Gradle debug build, the underlying APK is normally
produced under:

``` text
android/app/build/outputs/apk/debug/app-debug.apk
```

The builder can copy/rename this according to the configured APK
filename.

For example:

``` text
MediaFlow-v38.apk
```

## Installing on Android

Copy the generated APK to your Android device and open it.

Android may ask you to allow installation from the app you used to open
the APK (for example, your browser or file manager). This is expected
when manually installing an APK outside an app store.

## Web App Updates vs Android Updates

The Android app contains a packaged copy of the files from `www`.

Changing the original HTML file on your computer does **not**
automatically update an APK that is already installed on a phone.

After changing your web app:

``` text
Update www/
      ↓
Increase version
      ↓
Run BUILD-APK.bat
      ↓
Generate new APK
      ↓
Install/update it on Android
```

## Local Storage and App Data

Web apps running through Capacitor can use browser-style storage APIs,
but you should test important persistence behavior on Android rather
than assuming desktop-browser behavior will be identical.

When updating an existing app, keeping the same package name is
especially important for maintaining the same Android application
identity.

## Internet-Based Web Apps

Your HTML app can still communicate with online APIs/services if it is
designed to do so and the Android app has the required network access.

For example, a web app may use a cloud backend or authentication service
while its interface is packaged locally inside the APK.

Make sure any external service you use supports the
origins/authentication flow required by your packaged application.

## Debug APK vs Release APK

The basic builder workflow creates a **debug APK**, which is useful for:

-   personal installation
-   development
-   testing
-   sharing test builds

Publishing through Google Play normally requires a properly signed
release build, typically distributed as an Android App Bundle (`.aab`).

Release signing should be treated separately because the signing key
must be stored safely. Losing the signing key can prevent normal updates
to an application distributed with that key.

## Troubleshooting

### `JAVA_HOME is set to an invalid directory`

The selected Java directory is invalid or points to a Java
redirect/runtime instead of a full JDK.

A usable JDK contains both:

``` text
bin/java.exe
bin/javac.exe
```

### `android platform has not been added yet`

The Capacitor Android project has not been generated.

The relevant Capacitor command is:

``` text
npx cap add android
```

The generic builder is designed to handle/check this for you.

### `SDK location not found`

Gradle cannot find the Android SDK.

The builder should configure the SDK location and generate:

``` text
android/local.properties
```

with an appropriate `sdk.dir`.

### Gradle downloads take a long time

This is normal on the first build. Gradle and Android components are
cached, so later builds are usually faster.

### npm reports vulnerabilities

An npm audit warning does not necessarily mean the APK build failed.
Read the actual final build error before changing dependencies.

Avoid blindly running dependency upgrade commands on a working project
because major dependency updates can introduce incompatibilities.

## Recommended Release Workflow

For each new release:

``` text
1. Back up the project.
2. Replace/update www/.
3. Test index.html in a browser when applicable.
4. Update VERSION_NAME.
5. Increase VERSION_CODE.
6. Keep PACKAGE_NAME unchanged for an existing app.
7. Replace icon.png only when desired.
8. Run BUILD-APK.bat.
9. Install and test the APK on Android.
10. Archive the APK/source for that release.
```

## Example: MediaFlow

A MediaFlow update might look like:

``` bat
set "APP_NAME=MediaFlow"
set "PACKAGE_NAME=com.alexgodly.mediaflow"
set "VERSION_NAME=1.1.0"
set "VERSION_CODE=2"
set "APK_NAME=MediaFlow-v38.apk"
set "ICON_FILE=assets\icon.png"
```

Then:

``` text
www/index.html
```

is replaced with the updated MediaFlow HTML and `BUILD-APK.bat` is run
again.

## Summary

The intended workflow is:

``` text
                 YOUR WEB APP
                      │
                      ▼
                 www/index.html
                      │
                      ▼
                 app.config.bat
             name / package / version
                    / icon
                      │
                      ▼
                 BUILD-APK.bat
                      │
                      ▼
                Capacitor Android
                      │
                      ▼
                    Gradle
                      │
                      ▼
                 YOUR APP.apk
```

You maintain the web application.

The builder handles the repetitive Android packaging process.
