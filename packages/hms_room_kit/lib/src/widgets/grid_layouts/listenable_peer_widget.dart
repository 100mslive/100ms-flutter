import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';
import 'package:provider/provider.dart';

class ListenablePeerWidget extends StatelessWidget {
  final int index;
  final List<PeerTrackNode> peerTracks;

  const ListenablePeerWidget(
      {super.key, required this.index, required this.peerTracks});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        key: ValueKey("${peerTracks[index].uid}video_view"),
        value: peerTracks[index],
        child: PeerTile(
          key: ValueKey("${peerTracks[index].uid}audio_view"),
        ));
  }
}
