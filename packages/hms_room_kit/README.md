[![100ms-svg](https://user-images.githubusercontent.com/93931528/205858417-8c0a0d1b-2d46-4710-9316-7418092fd3d6.svg)](https://100ms.live/)

[![Pub Version](https://img.shields.io/pub/v/hmssdk_flutter)](https://pub.dev/packages/hmssdk_flutter)
[![License](https://img.shields.io/github/license/100mslive/100ms-flutter)](https://www.100ms.live/)
[![Documentation](https://img.shields.io/badge/Read-Documentation-blue)](https://docs.100ms.live/flutter/v2/foundation/basics)
[![Discord](https://img.shields.io/discord/843749923060711464?label=Join%20on%20Discord)](https://100ms.live/discord)
[![Firebase](https://img.shields.io/badge/Download%20Android-Firebase-green)](https://appdistribution.firebase.dev/i/b623e5310929ab70)
[![TestFlight](https://img.shields.io/badge/Download%20iOS-TestFlight-blue)](https://testflight.apple.com/join/Uhzebmut)
[![Activity](https://img.shields.io/github/commit-activity/m/100mslive/100ms-flutter.svg)](https://github.com/100mslive/100ms-flutter/projects/1)
[![Register](https://img.shields.io/badge/Contact-Know%20More-blue)](https://dashboard.100ms.live/register)


# 100ms Room Kit🎉

A powerful prebuilt UI library for audio/video conferencing, live streaming, and one-to-one calls. 
This package provides developers with a comprehensive set of tools and components to quickly integrate high-quality audio and video communication features into their Flutter applications.

📖 Read the Complete Documentation here: https://www.100ms.live/docs/flutter/v2/guides/quickstart

📲 Download the Sample iOS app here: <https://testflight.apple.com/join/Uhzebmut>

🤖 Download the Sample Android app here: <https://appdistribution.firebase.dev/i/b623e5310929ab70>

100ms Flutter apps are also released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>

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
         roomCode: meetingLinkController.text.trim(),
         hmsConfig: HMSPrebuiltOptions(userName: ""),
      );
```

That's it. You can now use the amazing prebuilt ui in your application.

📖 Do refer the Complete Documentation Guide [available here](https://www.100ms.live/docs/flutter/v2/guides/quickstart).

🏃‍♀️ Checkout the Example app implementation [available here](https://github.com/100mslive/100ms-flutter/tree/main/example).

🚀 We have added explanations & recommended usage guide for different features, UI Layouts, Data Store, etc in [Example app ReadMe](https://github.com/100mslive/100ms-flutter/blob/main/example/README.md).

100ms Flutter apps are released on the App Stores, you can download them here:

📲 iOS app on Apple App Store: <https://apps.apple.com/app/100ms-live/id1576541989>

🤖 Android app on Google Play Store: <https://play.google.com/store/apps/details?id=live.hms.flutter>
