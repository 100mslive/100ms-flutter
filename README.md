<p align="center" >
  <a href="https://100ms.live/">
  <img src="https://github.com/100mslive/100ms-flutter/blob/main/100ms-logo.png" title="100ms logo" float=left>
</p>

# 100 ms Flutter sdk

1. [x] Join Meeting
2. [x] Leave Meeting
3. [ ] Show peers with Audio/Video [Ongoing]
4. [ ] More features to be added

 ## How to run project

 1. In project root, run `flutter pub get`
 2. Change directory to `example` folder, run `flutter packages pub run build_runner build --delete-conflicting-outputs`
 3. Run either `flutter build ios` OR `flutter build android`
 4. Finally, `flutter run`



## Permissions
Add following permissions in iOS Info.plist file
```
<key>NSMicrophoneUsageDescription</key>
<string>{YourAppName} wants to use your microphone</string>

<key>NSCameraUsageDescription</key>
<string>{YourAppName} wants to use your camera</string>

<key>NSLocalNetworkUsageDescription</key>
<string>{YourAppName} App wants to use your local network</string>
```

