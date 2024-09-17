# 100ms Room Kit 🎉

[![Pub Version](https://img.shields.io/pub/v/hms_room_kit)](https://pub.dev/packages/hms_room_kit)
[![Build](https://github.com/100mslive/100ms-flutter/actions/workflows/build.yml/badge.svg?branch=develop)](https://github.com/100mslive/100ms-flutter/actions/workflows/build.yml)
[![License](https://img.shields.io/github/license/100mslive/100ms-flutter)](https://www.100ms.live/)
[![Documentation](https://img.shields.io/badge/Read-Documentation-blue)](https://docs.100ms.live/flutter/v2/foundation/basics)
[![Discord](https://img.shields.io/discord/843749923060711464?label=Join%20on%20Discord)](https://100ms.live/discord)
[![Firebase](https://img.shields.io/badge/Download%20Android-Firebase-green)](https://appdistribution.firebase.dev/i/b623e5310929ab70)
[![TestFlight](https://img.shields.io/badge/Download%20iOS-TestFlight-blue)](https://testflight.apple.com/join/Uhzebmut)
[![Register](https://img.shields.io/badge/Contact-Know%20More-blue)](https://dashboard.100ms.live/register)

<p align="center" width="100%">
<img width="600" height="500" alt="Prebuilt - Edtech" src="https://github.com/100mslive/100ms-flutter/assets/93931528/de8008f7-1fa7-4329-84b4-ce6fedc0833f">
</p>

A powerful prebuilt UI library for audio/video conferencing, live streaming, and one-to-one calls.
This package provides developers with a comprehensive set of tools and components to quickly integrate high-quality audio and video communication features into their Flutter applications.

| Package        | Version                                                                                                |
| -------------- | ------------------------------------------------------------------------------------------------------ |
| hms_room_kit   | [![Pub Version](https://img.shields.io/pub/v/hms_room_kit)](https://pub.dev/packages/hms_room_kit)     |
| hmssdk_flutter | [![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter) |


🧱 The Prebuilt QuickStart Guide is [available here](https://www.100ms.live/docs/flutter/v2/quickstart/prebuilt).

📖 Read the Complete Documentation here: https://www.100ms.live/docs/flutter/v2/guides/quickstart

📲 Download the Sample iOS app here: <https://testflight.apple.com/join/Uhzebmut>

🤖 Download the Sample Android app here: <https://appdistribution.firebase.dev/i/b623e5310929ab70>

100ms Flutter apps are also available on the App Stores, do download them and try it out.

<div>
  <a href="https://apps.apple.com/app/100ms-live/id1576541989">
    <img height="40" src="https://raw.githubusercontent.com/100mslive/100ms-flutter/develop/docs/static/img/appstore.svg" />
  </a>
  <a href="https://play.google.com/store/apps/details?id=live.hms.flutter">
    <img height="40" src="https://raw.githubusercontent.com/100mslive/100ms-flutter/develop/docs/static/img/googleplay.svg" />
  </a>
</div>


## 🚂 Setup Guide

1. Sign up on <https://dashboard.100ms.live/register> & visit the Developer tab to access your credentials.

2. Get familiarized with [Tokens & Security here](https://www.100ms.live/docs/flutter/v2/foundation/security-and-tokens)

3. Complete the steps in [Auth Token Quick Start Guide](https://www.100ms.live/docs/flutter/v2/guides/token)

4. Get the HMSSDK via [pub.dev](https://pub.dev/packages/hms_room_kit). Add the `hms_room_kit` to your pubspec.yaml.

```
flutter pub add hms_room_kit
```

5. Import the `hms_room_kit` package wherever you wish to use it:

```dart
import 'package:hms_room_kit/hmssdk_uikit.dart';
```

6. Add the `HMSPrebuilt` widget in your widget tree to use the prebuilt ui with correct `roomCode` and desired prebuilt options.

```dart
HMSPrebuilt(
    roomCode: "xvm-wxwo-gbl",
    hmsConfig: HMSPrebuiltOptions(userName: "John Appleseed"),
);
```

## Overview

This guide will walk you through simple instructions to create a video conferencing app using 100ms Prebuilt and and test it using an emulator or your mobile phone. 100ms prebuilt is completely customizable from 100ms dashboard. Following images portray what you get with 100ms prebuilt

<table>
    <tr>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/02f7181e-ef73-48fc-b8cd-ed977b3bc28c"></td>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/7875bc6d-597c-4213-98f4-7333a660e689"></td>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/cf10216a-93cb-41c9-b0fd-15b2d05611a0"></td>
    </tr>
    <tr>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/e4ba9546-56b6-42ee-bea1-c7733053b2b6"></td>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/8a0a5a8c-024f-4128-b607-c3ee5957bb17"></td>
        <td><img src="https://github.com/100mslive/100ms-flutter/assets/93931528/f292bf26-3061-4c9c-925a-981e7dd6c86b"></td>
    </tr>
</table>

<!-- |  ![Prebuilt iOS - 3](https://github.com/100mslive/100ms-flutter/assets/93931528/f292bf26-3061-4c9c-925a-981e7dd6c86b) | ![3](https://github.com/100mslive/100ms-flutter/assets/93931528/7875bc6d-597c-4213-98f4-7333a660e689) | 
|![Prebuilt Flutter - 1](https://github.com/100mslive/100ms-flutter/assets/93931528/cf10216a-93cb-41c9-b0fd-15b2d05611a0) | ![4](https://github.com/100mslive/100ms-flutter/assets/93931528/43263ecf-57e8-4b8d-9bdc-68a72b4ce7fa) | -->

## Create a sample app

This section contains instructions to create a simple Flutter video conferencing app. We will help you with instructions to understand the project setup and complete code sample to implement this quickly.

### Prerequisites

To complete this implementation for the Android platform, you must have the following:

- A [100ms account](https://dashboard.100ms.live/register) if you don't have one already.
- [Flutter](https://docs.flutter.dev/get-started/install) `3.3.0` or higher
- Dart `2.12.0` or above
- Use [VS code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio), or any other IDE that supports Flutter. For more information on setting up an IDE, check [Flutter's official guide](https://docs.flutter.dev/get-started/editor).

### Create a Flutter app

Once you have the prerequisites, follow the steps below to create a Flutter app. This guide will use VS code, but you can use any IDE that supports Flutter.

- Create a Flutter app using the terminal; you can get the [Flutter SDK](https://docs.flutter.dev/get-started/install/macos#get-sdk) and use the below command:

    ```bash section=createFlutterApp
    flutter create my_app
    ```

- Once the app is created, open it in VS code.

### Add 100ms room kit to your project

Once you have created a Flutter app, you must add the `hms_room_kit` package to your project.

In project's `pubspec.yaml` file, under dependencies section add the following:

```yaml section=InstallingTheDependencies
hms_room_kit:
```

- Run `flutter pub get` to download these dependencies to your app.

### Application Setup

#### For Android

Please follow the below instructions to test the app for the Android Platform:

1. Add minimum SDK version (`minSdkVersion 21`) in `android/app/build.gradle` file (inside `defaultConfig`).

```
...
defaultConfig {
    ...
    minSdkVersion 21
    ...
}
...
```

2. To add PIP support in your app manifest files, add:

```
<activity
    ....
    android:supportsPictureInPicture="true"
    android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"
    ... />
```

3. For Auto Enter PIP support(below android 12) in your `MainActivity.kt` file add:

```kotlin
override fun onUserLeaveHint() {
    super.onUserLeaveHint()
    // This should only work for android version above 8 since PIP is only supported after
    // android 8 and will not be called after android 12 since it automatically gets handled by android.
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
        HMSPipAction.autoEnterPipMode(this)
    }
}
```

4. For screenshare in your `MainActivity.kt` add:

```kotlin
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
super.onActivityResult(requestCode, resultCode, data)

    if (requestCode == Constants.SCREEN_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
        data?.action = Constants.HMSSDK_RECEIVER
        activity.sendBroadcast(data?.putExtra(Constants.METHOD_CALL, Constants.SCREEN_SHARE_REQUEST))
    }
}
```

5. Add the `FOREGROUND_SERVICE` permission in `AndroidManifest.xml`:

```
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```

#### For iOS

Please follow the below instructions to test the app for iOS Platform

1. Add the target platform version as (`platform :ios, '12.0'`) in `ios/Podfile`

```
platform :ios, '12.0'
```
2. Allow camera, recording audio and internet permissions by adding the below snippet to the `ios/Runner/info.plist` file.

    ```
    <key>NSMicrophoneUsageDescription</key>
    <string>{YourAppName} wants to use your microphone</string>

    <key>NSCameraUsageDescription</key>
    <string>{YourAppName} wants to use your camera</string>

    <key>NSLocalNetworkUsageDescription</key>
    <string>{YourAppName} App wants to use your local network</string>

    <key>NSBluetoothAlwaysUsageDescription</key>
	<string>{YourAppName} needs access to bluetooth to connect to nearby devices.</string>
    ```

3. Add the below snippet to the `ios/Podfile` in post_install section:

    ```
    target.build_configurations.each do |config|
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        ## dart: PermissionGroup.camera
        'PERMISSION_CAMERA=1',

        ## dart: PermissionGroup.microphone
        'PERMISSION_MICROPHONE=1',

        ## dart: PermissionGroup.bluetooth
        'PERMISSION_BLUETOOTH=1',
    ]
    end
    ```

4. To add PIP support in your iOS app:

- Minimum Requirements:
    - Minimum iOS version required to support PiP is iOS 15
    - Minimum `hmssdk_flutter` SDK version required is 1.3.0
    - Your app should have [com.apple.developer.avfoundation.multitasking-camera-access)(https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_avfoundation_multitasking-camera-access) Entitlement to use PiP Mode.

Your app needs to run on iOS 13.5 or later to use the entitlement. Without the entitlement, the system disables the camera access for your app. When your app enters PIP mode, it needs this entitlement to continue using the camera.

After you receive permission from Apple, add the Entitlement to your app by opening the Entitlements file in Xcode. Add the key and set the corresponding value to `YES`.

![Entitlements](https://www.100ms.live/docs/docs/v2/flutter-multitasking-camera-entitlement.png)

5. To add screen share support in iOS app, checkout the docs [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/screen-share#ios-setup)

6. Pass the `iOSScreenshareConfig` in `HMSPrebuiltOptions` parameter of `HMSPrebuilt` widget to enable screen share in your app.

```dart
// Pass the correct App Group & Preferred Extension parameters in HMSIOSScreenshareConfig class.
HMSPrebuilt(
    roomCode: meetingLinkController.text.trim(),
    options: HMSPrebuiltOptions(
        iOSScreenshareConfig:  HMSIOSScreenshareConfig(
    appGroup: "appGroup", // App Group value linked to your Apple Developer Account
    preferredExtension: "preferredExtension" // Name of the Broadcast Upload Extension Target created in Xcode
)));
```

### Add the 100ms Room Kit to your App

We will be adding a join button to the app, on the button click we will route the user to the 100ms room kit. To do this, follow the steps below:

1. Add the below code for `Join` button in `lib/main.dart` file:

```dart
Scaffold(
    body: Center(
        child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            ))),
            onPressed: () async => {
            ///Here will route the user to the 100ms room kit
            },
            child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                    'Join',
                    style: TextStyle(fontSize: 20),
                ),
            ),
        ),
    ),
);
```

2. Update the code in the `onPressed` method of the `Join` button by following code:

```dart
onPressed: () async => {
        await Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => const HMSPrebuilt(roomCode: "xvm-wxwo-gbl")
        ),
    ),
}
```

That's it. You can now use the amazing Prebuilt UI in your application.

🧱 The Prebuilt QuickStart Guide is [available here](https://www.100ms.live/docs/flutter/v2/quickstart/prebuilt).

📖 Do refer the Complete Documentation Guide [available here](https://www.100ms.live/docs/flutter/v2/guides/quickstart).

🏃‍♀️ Checkout the Example app implementation [available here](https://github.com/100mslive/100ms-flutter/tree/main/packages/hmssdk_flutter/example).

🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/packages/hmssdk_flutter/example/README.md).

100ms Flutter apps are released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>
