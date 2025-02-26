# Fisca - Financial Management App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Fisca is a sleek and user-friendly app designed to help you manage your finances effortlessly.

### Troubleshooting for early debug build

- Generate SHA1 for firebase console 
- keytool -storepass android -keypass android -keystore /c/Users/{user}/.android/debug.keystore -alias androiddebugkey -validity 99 -genkey -keyalg RSA -noprompt 


## Prerequisites
Ensure the following are installed and correctly configured:
- **Flutter 3.29**
- **Dart 3.7**
- **Java 17**
- **Android SDK 34**
- **Gradle 8.13**

---

## Common Issues and Solutions

### 1. `local.properties` Not Found
- **Issue**: The `local.properties` file is missing after cloning the repository.
- **Solution**:
  1. Complete the first project load in Android Studio or your IDE.
  2. Ensure the correct SDK paths are configured.
  3. Run the following commands in the terminal:
     ```bash
     flutter clean
     flutter pub get
     ```

---

### 2. `gradlew` Not Found in Android Folder
- **Issue**: The `gradlew` file is missing in the `android` folder.
- **Solution**:
  1. Install **Gradle 8.13** manually.
  2. Add the `bin` folder of the Gradle installation to your system's `PATH`.
  3. Navigate to the `android` folder inside your Flutter project and run:
     ```bash
     gradle wrapper
     ```

---

### 3. FlutterVision Namespace Error in `AndroidManifest.xml`
- **Issue**: The `namespace` is incorrectly defined in `AndroidManifest.xml` instead of `build.gradle`.
- **Solution**:
  1. Open `AndroidManifest.xml` and remove the `package=""` attribute from the file path shown in your error stacktrace.
  2. Open `build.gradle` (located in `Pub/Cache/flutter_vision` file path shown in your error stacktrace).
  3. Add the namespace inside the `android` section:
     ```build.gradle
     android {
         namespace "com.example.app"
     }
     ```

---

### 4. Missing `.tfile` Model for FlutterVision
- **Issue**: The `.tfile` model is not found or incorrectly configured.
- **Solution**:
  1. Download your `.tfile` model.
  2. Place it in the `assets` folder of your Flutter project.
  3. Ensure the file is correctly referenced in `pubspec.yaml`:
     ```yaml
     flutter:
       assets:
         - assets/your_model.tfile
     ```

---

### 5. Missing `google-services.json`
- **Issue**: The `google-services.json` file is missing.
- **Solution**:
  1. Download the `google-services.json` file from your Firebase Console.
  2. Place it in the `android/app` folder of your Flutter project.

---

### 6. Debugging on an Android Phone
- **Issue**: Warnings appear during debug compilation.
- **Solution**:
  1. Connect your Android phone and enable USB debugging.
  2. Run the app in debug mode
  3. Ignore any warnings that do not break the debug compilation process.

---