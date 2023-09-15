///Package imports
import 'package:flutter/cupertino.dart';
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
        child: PeerTile(
          key: ValueKey("${peerTracks[index].uid}audio_view"),
          scaleType: scaleType,
        ));
  }
}
