import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

class TwoTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;

  const TwoTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child:
                ListenablePeerWidget(index: startIndex, peerTracks: peerTracks),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListenablePeerWidget(
                index: startIndex + 1, peerTracks: peerTracks),
          ),
        ],
      ),
    );
  }
}
