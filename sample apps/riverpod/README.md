# demo_with_100ms_and_riverpod

A demo app using riverpod and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- New to riverpod [checkout](https://riverpod.dev/docs/getting_started/)

## How to run the application

- Clone the repo `git clone https://github.com/100mslive/100ms-flutter.git`
- Navigate to `sample apps/riverpod` folder
- Run `flutter pub get`
- Add the meeting link in `main.dart` which you created from dashboard. To know about how to create room from dashboard checkout the docs here: https://www.100ms.live/docs/flutter/v2/get-started/token
- Update the `tokenEndpoint` in `room_service.dart` file 

```
Uri endPoint = Uri.parse("Enter your endpoint here");`
```

Replace the given endpoint with your token endpoint from dashboard's developer section.

<img width="1512" alt="Screenshot 2023-03-15 at 3 50 13 PM" src="https://user-images.githubusercontent.com/93931528/225282064-42e26903-f81c-48db-ad13-359a47e95142.png">

- Run the application: `flutter run`


## How to use PeerTrackNode model class

This model class is used to listen for changes corresponding to a peer.So that riverpod can only rebuild that particular changes.

```dart
class PeerTrackNode extends ChangeNotifier {
  HMSPeer peer;
  String uid;
  HMSVideoTrack? track;
  HMSAudioTrack? audioTrack;
  bool isOffscreen;

  PeerTrackNode({
    required this.peer,
    this.track,
    this.audioTrack,
    required this.uid,
    this.isOffscreen = true,
  });
}
```

We use the notify method to notify the peer for changes 

```dart
void notify() {
    notifyListeners();
}
```

We set the on/off screen status to stop downloading the video of off screen peer to save bandwidth.

```dart
void setOffScreenStatus(bool currentState) {
    this.isOffscreen = currentState;
    notify();
}
```
This is how you can rebuild widgets on change.
