// Package imports
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node_store.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  // final List<PeerTracKNode> filteredList;
  final double itemHeight;
  final double itemWidth;
  final PeerTrackNodeStore peerTrackNodeStore;
  final bool audioView;

  VideoTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.peerTrackNodeStore,
    required this.audioView,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    bool mutePermission =
        widget.peerTrackNodeStore.peer.role.permissions.mute ?? false;
    bool unMutePermission =
        widget.peerTrackNodeStore.peer.role.permissions.unMute ?? false;
    bool removePeerPermission =
        widget.peerTrackNodeStore.peer.role.permissions.removeOthers ?? false;



    return InkWell(
      onLongPress: () {
        if (!mutePermission || !unMutePermission || !removePeerPermission)
          return;
        if (!widget.audioView && (!(widget.peerTrackNodeStore.peer.isLocal)))
          showDialog(
              context: context,
              builder: (_) => Column(
                children: [
                  // ChangeTrackOptionDialog(
                  //     isAudioMuted:
                  //     filteredList[index].audioTrack?.isMute,
                  //     isVideoMuted: filteredList[index].track == null
                  //         ? true
                  //         : filteredList[index].track?.isMute,
                  //     peerName: filteredList[index].name,
                  //     changeVideoTrack: (mute, isVideoTrack) {
                  //       Navigator.pop(context);
                  //       _meetingStore.changeTrackState(
                  //           filteredList[index].track!, mute);
                  //     },
                  //     changeAudioTrack: (mute, isAudioTrack) {
                  //       Navigator.pop(context);
                  //       _meetingStore.changeTrackState(
                  //           filteredList[index].audioTrack!, mute);
                  //     },
                  //     removePeer: () async {
                  //       Navigator.pop(context);
                  //       var peer = await _meetingStore.getPeer(
                  //           peerId: filteredList[index].peerId);
                  //       _meetingStore.removePeerFromRoom(peer!);
                  //     },
                  //     mute: mutePermission,
                  //     unMute: unMutePermission,
                  //     removeOthers: removePeerPermission),
                ],
              ));
      },
      child: PeerItemOrganism(
        key: Key(widget.peerTrackNodeStore.uid.toString()),
        height: widget.itemHeight,
        width: widget.itemWidth,
        peerTrackNodeStore: widget.peerTrackNodeStore,
      ),
    );
  }
}
