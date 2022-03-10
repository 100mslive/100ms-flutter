// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/brb_tag.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_name.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_view.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final bool audioView;
  final int index;

  VideoTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.audioView,
    required this.index,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String name = "";
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();

    bool mutePermission =
        _meetingStore.localPeer?.role.permissions.mute ?? false;
    bool unMutePermission =
        _meetingStore.localPeer?.role.permissions.unMute ?? false;
    bool removePeerPermission =
        _meetingStore.localPeer?.role.permissions.removeOthers ?? false;

    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        
        var visiblePercentage = info.visibleFraction * 100;
        var peerTrackNode = context.read<PeerTrackNode>();
        if (visiblePercentage <= 40) {
          peerTrackNode.setIsVideoOn(false);
        } else {
          peerTrackNode.setIsVideoOn(
              !(context.read<PeerTrackNode>().track?.isMute ?? true));
        }
      },
      key: Key(context.read<PeerTrackNode>().uid),
      child: InkWell(
        onLongPress: () {
          var peerTrackNode = context.read<PeerTrackNode>();
          HMSPeer peerNode = peerTrackNode.peer;
          if (!mutePermission || !unMutePermission || !removePeerPermission)
            return;
          if (!widget.audioView &&
              peerTrackNode.peer.peerId != _meetingStore.localPeer!.peerId)
            showDialog(
                context: context,
                builder: (_) => Column(
                      children: [
                        ChangeTrackOptionDialog(
                            isAudioMuted:
                                peerTrackNode.audioTrack?.isMute??true,
                            isVideoMuted: peerTrackNode.track == null
                                ? true
                                : peerTrackNode.track!.isMute,
                            peerName: peerNode.name,
                            changeVideoTrack: (mute, isVideoTrack) {
                              Navigator.pop(context);
                              _meetingStore.changeTrackState(
                                  peerTrackNode.track!, mute);
                            },
                            changeAudioTrack: (mute, isAudioTrack) {
                              Navigator.pop(context);
                              _meetingStore.changeTrackState(
                                  peerTrackNode.audioTrack!, mute);
                            },
                            removePeer: () async {
                              Navigator.pop(context);
                              var peer = await _meetingStore.getPeer(
                                  peerId: peerNode.peerId);
                              _meetingStore.removePeerFromRoom(peer!);
                            },
                            mute: mutePermission,
                            unMute: unMutePermission,
                            removeOthers: removePeerPermission),
                      ],
                    ));
        },
        child: Container(
          color: Colors.transparent,
          key: key,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.all(2),
          height: widget.itemHeight + 110,
          width: widget.itemWidth - 5.0,
          child: Stack(
            children: [
              VideoView(),
              PeerName(),
              HandRaise(),
              BRBTag(),
              Container(
                height: widget.itemHeight + 110,
                width: widget.itemWidth - 4,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              )
              // Consumer<MeetingStore>(builder: (context, _meetingStore, _) {
              //   print("${_meetingStore.activeSpeakerIds}");
              //   bool isHighestSpeaker =
              //       _meetingStore.isActiveSpeaker(data.uid);
              //   return Container(
              //     height: widget.itemHeight + 110,
              //     width: widget.itemWidth - 4,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             color: isHighestSpeaker ? Colors.blue : Colors.grey,
              //             width: isHighestSpeaker ? 3.0 : 1.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //   );
              // })
            ],
          ),
        ),
      ),
    );
  }
}
