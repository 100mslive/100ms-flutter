# demo_with_100ms_and_bloc

A demo app using Bloc and 100ms.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [100ms flutter documentation](https://www.100ms.live/docs/flutter/v2/foundation/basics)
- [bloc](https://bloclibrary.dev/#/)

## Now we will see steps to use bloc and 100ms
  In this example we used both Cubit and Bloc for better understanding on using bloc package

  ### Preview
  
1. for preview create Cubit and initialzing HMSSDK object.

   ```dart
    class PreviewCubit extends Cubit<PreviewState>{}
    ```
  
  
2. create PreviewState.that has properties like micOn,cameraOn and localVideoTracks


  ```dart
    class PreviewState extends Equatable {
  const PreviewState({
    this.isMicOff = true,
    this.isVideoOff = true,
    this.tracks = const <HMSVideoTrack>[],
  });

  final bool isMicOff;
  final bool isVideoOff;
  final List<HMSVideoTrack> tracks;

  PreviewState copyWith(
      {bool? isMicOff, bool? isVideoOff, List<HMSVideoTrack>? tracks}) {
    return PreviewState(
        isMicOff: isMicOff ?? this.isMicOff,
        isVideoOff: isVideoOff ?? this.isVideoOff,
        tracks: tracks ?? this.tracks);
  }

  @override
  List<Object> get props => [isMicOff, isVideoOff, tracks];
}
  ```
  
3. props are used for state changes.

4. After this create PreviewObserver that will act as PreviewEvent class
    ```dart
      class PreviewObserver implements HMSPreviewListener{}
    ```

5. as you can see we have to refernce of PreviewCubit we can give it the localTracks on onPreview() callback
  ```dart
  PreviewCubit previewCubit;
    @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
      }
    }
    this.localTracks.clear();
    this.localTracks.addAll(videoTracks);
    previewCubit.updateTracks(this.localTracks);
  }
  ```
  
  ### Room
  For room we will be using Bloc for better understanding and as room interactions are litte complex than preview.
  
  1. Create RoomOverviewEvent which has all different events associated with room.
  
      ```dart
          abstract class RoomOverviewEvent extends Equatable {
            const RoomOverviewEvent();
            @override
            List<Object> get props => [];
        }
      ```
  2. Create RoomOverviewState which consist of all state variables on which our Ui sis dependent.


      ```dart
          class RoomOverviewState extends Equatable {
            final RoomOverviewStatus status;
            final List<PeerTrackNode> peerTrackNodes;
            final bool isVideoMute;
            final bool isAudioMute;
            final bool leaveMeeting;


            @override
            List<Object?> get props => [status,peerTrackNodes,isAudioMute,isVideoMute,leaveMeeting];
         }
      ```
      
  3. In RoomOverviewState you can see List of PeerTrackNode which take cares of video tracks in room.


  4. On Different events we will have different states for listening to states we have BlocBuilder or BlocConsumer.


      ```dart
            
            BlocConsumer<RoomOverviewBloc, RoomOverviewState>(
          listener: (ctx, state) {
            if (state.leaveMeeting) {
              Navigator.of(context).pushReplacement(HomePage.route());
            }
          },
          builder: (ctx, state) {
            return ListView.builder(
              itemCount: state.peerTrackNodes.length,
              itemBuilder: (ctx, index) {
                return Card(
                    key: Key(
                        state.peerTrackNodes[index].peer!.peerId.toString()),
                    child: SizedBox(height: 250.0, child: VideoWidget(index)));
              },
            );
          },
        )
      ```
 
  
## How to use PeerTrackNode model class

This model class is used to listen for changes corresponding to a peer.So that getx can only rebuild that particular changes.

```dart

class PeerTrackNode extends Equatable {


  final HMSVideoTrack? hmsVideoTrack;
  final bool? isMute;
  final HMSPeer? peer;
  final bool isOffScreen;

  const PeerTrackNode(
      this.hmsVideoTrack, this.isMute, this.peer, this.isOffScreen);


  @override
  List<Object?> get props => [hmsVideoTrack, isMute, peer, isOffScreen];
}
```

We need to first listen to changes in List of PeerTrackNode.
For that we need to do this.
```dart
     final _peerNodeStreamController =
      BehaviorSubject<List<PeerTrackNode>>.seeded(const []);

       Stream<List<PeerTrackNode>> getTracks() =>
      _peerNodeStreamController.asBroadcastStream();
```

Now in On Subscription Event you listen to tracks change.
  ```dart
      Future<void> _onSubscription(RoomOverviewSubscriptionRequested event,
      Emitter<RoomOverviewState> emit) async {
    await emit.forEach<List<PeerTrackNode>>(
      roomObserver.getTracks(),
      onData: (tracks) {
        return state.copyWith(
            status: RoomOverviewStatus.success, peerTrackNodes: tracks);
      },
      onError: (_, __) => state.copyWith(
        status: RoomOverviewStatus.failure,
      ),
    );
  }
  ```

So now, for changing some properties in PeerTrackNode you need to do something like this.

```dart
  Future<void> addPeer(HMSVideoTrack hmsVideoTrack, HMSPeer peer) async{
    final tracks = [..._peerNodeStreamController.value];
    final trackIndex = tracks.indexWhere((t) => t.peer?.peerId == peer.peerId);
    if (trackIndex >= 0) {
      tracks[trackIndex] =
          PeerTrackNode(hmsVideoTrack, hmsVideoTrack.isMute, peer, false);
    } else {
      tracks
          .add(PeerTrackNode(hmsVideoTrack, hmsVideoTrack.isMute, peer, false));
    }

    _peerNodeStreamController.add(tracks);
  }
```
This is how you can rebuild widgets on change.
