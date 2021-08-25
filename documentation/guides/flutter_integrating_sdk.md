
# 100ms SDK Flutter SDK Integration Guide

## Installing our libraries

Add the `hmssdk_flutter` plugin in dependencies of pubspec.yaml

```dart: #pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  hmssdk_flutter:
```
## Setting up the library

Run following in terminal in terminal.

```
flutter pub get
flutter build ios
```
## Device Permission

### Android 

Camera, Recording Audio and Internet permissions are required. Add them to your manifest.


```xml:
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />
```

### iOS

Add the entitlements for video, audio and network access to your Info.plist

```plist
<key>NSCameraUsageDescription</key>
<string>Allow access to Camera to enable video calling.</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Allow access to Camera to network to enable video calling.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Allow access to Camera to mic to enable video calling.</string>

```

You will also need to request Camera and Record Audio permissions at runtime before you join a call or display a preview.

## Debugging Tools
 
 You can use <span style="color:blue">Android Studio</span> and  <span style="color:blue">VS Code</span> to develop application with 100ms.

