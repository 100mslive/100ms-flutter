//package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Package imports
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class DegradeTile extends StatefulWidget {
  final double itemHeight;

  final double itemWidth;
  DegradeTile({
    Key? key,
    this.itemHeight = 200,
    this.itemWidth = 200,
  }) : super(key: key);

  @override
  State<DegradeTile> createState() => _DegradeTileState();
}

class _DegradeTileState extends State<DegradeTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: data,
              child: Container(
                height: widget.itemHeight + 110,
                width: widget.itemWidth - 4,
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                    child: CircleAvatar(
                        backgroundColor: Utilities.getBackgroundColour(
                            context.read<PeerTrackNode>().peer.name),
                        radius: 36,
                        child: Text(
                          Utilities.getAvatarTitle(
                              context.read<PeerTrackNode>().peer.name),
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ))),
              ));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
