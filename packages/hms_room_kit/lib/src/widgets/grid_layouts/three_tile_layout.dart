import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

class ThreeTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const ThreeTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              ListenablePeerWidget(index: startIndex, peerTracks: peerTracks),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
            child: ListenablePeerWidget(
                index: startIndex + 1, peerTracks: peerTracks)),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          child: ListenablePeerWidget(
              index: startIndex + 2, peerTracks: peerTracks),
        ),
      ],
    );
  }
}
