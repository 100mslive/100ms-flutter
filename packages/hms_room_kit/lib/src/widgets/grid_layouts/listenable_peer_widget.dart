///Package imports
library;

import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///This widget is used to render the peer tile
class ListenablePeerWidget extends StatelessWidget {
  final int index;
  final List<PeerTrackNode> peerTracks;
  final ScaleType scaleType;

  const ListenablePeerWidget(
      {super.key,
      required this.index,
      required this.peerTracks,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        key: ValueKey("${peerTracks[index].uid}video_view"),
        value: peerTracks[index],
        child: Selector<MeetingStore, HMSTextureViewController>(
            selector: (_, meetingStore) {
          ///Here we check if the track is of a screenshare
          ///we render it using screenshareViewController
          ///while for other tracks we render it using viewControllers list
          if (peerTracks[index].track?.source == "SCREEN") {
            meetingStore.screenshareViewController ??=
                HMSTextureViewController(addTrackByDefault: false);
            return meetingStore.screenshareViewController!;
          }
          return meetingStore.viewControllers[index % 6];
        }, builder: (_, viewController, __) {
          return PeerTile(
            videoViewController: viewController,
            key: ValueKey("${peerTracks[index].uid}audio_view"),
            scaleType: scaleType,
          );
        }));
  }
}
