# demo_with_getx_and_100ms

A demo app using Getx and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms flutter documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- [getx](https://pub.dev/packages/get)

## Now we will see steps to use getx and 100ms

1. Create a controller class extending GetxController.

    ```dart
      class RoomController extends GetxController{}
    ```
    
3. In onInit() initialize all the necessary objects like hmssdk and creating tokens.

   ```dart
      void onInit() async {
    hmsSdk.addUpdateListener(listener: this);

    hmsSdk.build();
    List<String?>? token = await RoomService().getToken(user: name, room: url);

    if (token == null) return;
    if (token[0] == null) return;

    HMSConfig config = HMSConfig(
      authToken: token[0]!,
      userName: name,
    );

    hmsSdk.join(config: config);
    super.onInit();
    }
   
   ```
    
4. As you get onJoin() or onPreview() callback it means join success. create a list of PeerTrackNode on onTrackUpdate() callback.


    ```dart
      RxList<Rx<PeerTrackNode>> peerTrackList =
      <Rx<PeerTrackNode>>[].obs;
      
      @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {


    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {

      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        removeUserFromList(peer);
      } else if(trackUpdate == HMSTrackUpdate.trackAdded) {
        int index = peerTrackList.indexWhere((element) => element.value.peer.peerId == peer.peerId);
        if(index > -1){
          peerTrackList[index](PeerTrackNode(track as HMSVideoTrack, track.isMute, peer));
        }
        else{
          peerTrackList.add(PeerTrackNode(track as HMSVideoTrack, track.isMute, peer).obs);
        }
      }

    }
  }
    ```
    
5. you can add or delete peerTrackNode from list according to onPeerUpdate callback or onTrackUpdate as well.

7. on UI side use GetXBuilder for rebuilding on observable changes.


  ```dart
      GetX<RoomController>(builder: (controller) {
        return ListView.builder(
          itemCount: controller.peerTrackList.length,
          itemBuilder: (ctx, index) {
            return Card(
                key: Key(controller.peerTrackList[index].value.peer.peerId
                    .toString()),
                child: SizedBox(
                    height: 250.0, child: VideoWidget(index, roomController)));
          },
        );
      })
  ```
  
7. you can also use obx for listening to changes

## How to use PeerTrackNode model class

This model class is used for some changes in a Peer.So that getx can only rebuild that particular changes.

```dart

class PeerTrackNode{
  HMSVideoTrack hmsVideoTrack;
  bool isMute = true;
  HMSPeer peer;
  bool isOffScreen = true;

  PeerTrackNode(this.hmsVideoTrack, this.isMute, this.peer , {this.isOffScreen = false});

}
```

So now, for changing some properties in PeerTrackNode you need to do something like this.

```dart
  peerTrackList[index](PeerTrackNode(track as HMSVideoTrack, track.isMute, peer));
```
This is the way you need to do so that Obx can listen to changes and can rebuild the widget.
