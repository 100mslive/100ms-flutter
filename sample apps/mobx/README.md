# demo_with_mobx_and_100ms

A demo app using Mobx and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms flutter documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- [mobx](https://pub.dev/packages/mobx)

> 🔑 Note: After cloning the repo make sure to generate the class using build_runner and mobx_codegen:

```
flutter packages pub run build_runner build --delete-conflicting-outputs 
```

We have `MeetingStore` class to listen to all the callbacks and update the UI accordingly.

To know more about 100ms usage with mobx checkout:[Build zoom clone in Flutter and mobx with 100ms SDK](https://www.100ms.live/blog/zoom-clone-in-flutter)

Zoom is the most popular video and audio conferencing app. From interacting with co-workers to organizing events like workshops and webinars.

This post will take you through a step by step guide on how to build a basic zoom like app using Flutter and 100ms' live audio-video SDK with steps to -

* Add 100ms to a Flutter app
* Join a room
* Leave a room
* Show video tiles with the user’s name
* Show Screenshare tile
* hand Raised
* Mute/Unmute
* Camera off/on
* Toggle Front/Back camera
* Chatting with everyone in the room

![alt-text](https://github.com/govindmaheshwari2/mobx-example-app/blob/master/final.gif)
