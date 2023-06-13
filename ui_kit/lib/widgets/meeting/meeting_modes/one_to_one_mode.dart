import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/peer_tile.dart';
import 'package:provider/provider.dart';

class OneToOneMode extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final BuildContext context;
  final Size size;
  final int screenShareCount;
  final double bottomMargin;
  const OneToOneMode(
      {Key? key,
      required this.peerTracks,
      required this.context,
      required this.size,
      required this.screenShareCount,
      this.bottomMargin = 272})
      : super(key: key);

  @override
  State<OneToOneMode> createState() => _OneToOneModeState();
}

class _OneToOneModeState extends State<OneToOneMode> {
  PeerTrackNode? oneToOnePeer;
  PeerTrackNode? screenPeer;
  @override
  void initState() {
    super.initState();
    if (widget.peerTracks.isNotEmpty) {
      oneToOnePeer =
          widget.peerTracks.firstWhere((element) => element.peer.isLocal);
      oneToOnePeer?.setOffScreenStatus(false);
      screenPeer =
          widget.peerTracks.firstWhere((element) => !element.peer.isLocal);
    }
  }

  void switchView() {
    PeerTrackNode? tempPeer = oneToOnePeer;
    oneToOnePeer = screenPeer;
    screenPeer = tempPeer;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ChangeNotifierProvider.value(
              key: ValueKey(screenPeer?.uid ?? "" + "video_view"),
              value: screenPeer,
              child: PeerTile(
                itemHeight: widget.size.height,
                itemWidth: widget.size.width,
              ),
            ),
            DraggableWidget(
              topMargin: 10,
              bottomMargin: widget.bottomMargin,
              horizontalSpace: 10,
              child: GestureDetector(
                onDoubleTap: (() => switchView()),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: ChangeNotifierProvider.value(
                      key: ValueKey(oneToOnePeer?.uid ?? "" + "video_view"),
                      value: oneToOnePeer,
                      child: PeerTile(
                        isOneToOne: true,
                        itemHeight: 150,
                        itemWidth: 100,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
