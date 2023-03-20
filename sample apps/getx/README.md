# demo_with_getx_and_100ms

A demo app using Getx and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms flutter documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- [getx](https://pub.dev/packages/get)

## How to run the application

- Clone the repo `git clone https://github.com/100mslive/100ms-flutter.git`
- Navigate to `sample apps/getx` folder
- Run flutter pub get
- Add the meeting link in `main.dart` which you created from dashboard. To know about how to create room from dashboard checkout the docs here: https://www.100ms.live/docs/flutter/v2/get-started/token
- Update the `tokenEndpoint` in `Constants.dart` file to your endpoint from dashboard's developer section.

<img width="1512" alt="Screenshot 2023-03-15 at 3 50 13 PM" src="https://user-images.githubusercontent.com/93931528/225282064-42e26903-f81c-48db-ad13-359a47e95142.png">

- Run the application: `flutter run`

## How to use PeerTrackNode model class

This model class is used for some changes in a Peer.So that getx can only rebuild that particular changes.

```dart

class PeerTrackNode{
  HMSVideoTrack? hmsVideoTrack;
  bool isMute = true;
  HMSPeer peer;
  bool isOffScreen = true;
  String uid;
  
  PeerTrackNode(this.uid, this.hmsVideoTrack, this.isMute, this.peer,
    {this.isOffScreen = false});
}
```

So now, for changing some properties in `PeerTrackNode` you need to do something like this.

```dart
  peerTrackList[index](PeerTrackNode(track as HMSVideoTrack, track.isMute, peer));
```
This is the way you need to do so that Obx can listen to changes and can rebuild the widget.
