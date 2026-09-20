import pypandoc, os

content = r"""# HTML to Android APK Builder

A reusable Windows project for turning an HTML/CSS/JavaScript web app into an installable Android APK using Capacitor.

The goal is simple: put your web app in the `www` folder, configure the app name/package/version/icon, run one BAT file, and let the builder handle the Android build process.

## What This Project Does

The builder is designed so you do **not** need to create a new Android project every time you make a web app.

You can use the same project for:

- MediaFlow
- dashboards
- trackers
- utilities
- offline web apps
- HTML/CSS/JavaScript projects
- other browser-based apps that can run inside a Capacitor WebView

The basic workflow is:

1. Put your web app inside `www`.
2. Replace the app icon.
3. Edit `app.config.bat`.
4. Double-click `BUILD-APK.bat`.
5. Get your APK.

## Project Structure

```text
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
