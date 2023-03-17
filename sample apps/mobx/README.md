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

## How to run the application

- Clone the repo `git clone https://github.com/100mslive/100ms-flutter.git`
- Navigate to `sample apps/mobx` folder
- Run flutter pub get
- Run code gen command

```
flutter packages pub run build_runner build --delete-conflicting-outputs 
```

- Add the meeting link in `main.dart` which you created from dashboard. To know about how to create room from dashboard checkout the docs here: https://www.100ms.live/docs/flutter/v2/get-started/token
- Update the `tokenEndpoint` in `room_service.dart` file 

```
Uri endPoint = Uri.parse("Enter your endpoint here");`
```

- Run the application `flutter run`

## How to use PeerTrackNode model class

This model class is used for some changes in a Peer.So that getx can only rebuild that particular changes.

```dart

@observable
class PeerTrackNode {
  String uid;
  HMSPeer peer;
  @observable
  String name;
  bool isRaiseHand;
  @observable
  HMSVideoTrack? track;
  @observable
  bool isOffScreen;
  PeerTrackNode(
      { required this.uid,
        required this.peer,
      this.track,
      this.name = "",
      this.isRaiseHand = false,
      this.isOffScreen = false});
}
```

Marking the fields as observable makes them listenable, which is used to update the UI state.
