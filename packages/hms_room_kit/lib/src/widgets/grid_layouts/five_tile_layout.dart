import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

class FiveTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const FiveTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 1, peerTracks: peerTracks),
            ),
          ]),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 2, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 3, peerTracks: peerTracks),
            ),
          ]),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4),
            child: ListenablePeerWidget(
                index: startIndex + 4, peerTracks: peerTracks),
          ),
        ),
      ],
    );
  }
}
