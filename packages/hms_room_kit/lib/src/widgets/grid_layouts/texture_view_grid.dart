import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

class TextureViewGrid extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  const TextureViewGrid({super.key, required this.peerTracks});

  @override
  State<TextureViewGrid> createState() => _TextureViewGridState();
}

class _TextureViewGridState extends State<TextureViewGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: MediaQuery.of(context).size.width / 2),
        itemCount: widget.peerTracks.length,
        itemBuilder: (context, index) {
          return ListenablePeerWidget(
            peerTracks: widget.peerTracks,
            index: index,
          );
        });
  }
}
