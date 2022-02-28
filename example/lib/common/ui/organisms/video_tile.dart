// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_name.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_view.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
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
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;
        if (visiblePercentage <= 40) {
          context.read<PeerTrackNode>().isVideoOn = false;
        } else {
          context.read<PeerTrackNode>().isVideoOn =
              !(context.read<PeerTrackNode>().track?.isMute??true);   
        }
      },
      key: Key(context.read<PeerTrackNode>().uid),
      child: InkWell(
        onLongPress: () {
          // if (!mutePermission || !unMutePermission || !removePeerPermission)
          //   return;
          // if (!widget.audioView &&
          //     filteredList[index].peerId != _meetingStore.localPeer!.peerId)
          //   showDialog(
          //       context: context,
          //       builder: (_) => Column(
          //             children: [
          //               ChangeTrackOptionDialog(
          //                   isAudioMuted:
          //                       filteredList[index].audioTrack?.isMute,
          //                   isVideoMuted: filteredList[index].track == null
          //                       ? true
          //                       : filteredList[index].track?.isMute,
          //                   peerName: filteredList[index].name,
          //                   changeVideoTrack: (mute, isVideoTrack) {
          //                     Navigator.pop(context);
          //                     _meetingStore.changeTrackState(
          //                         filteredList[index].track!, mute);
          //                   },
          //                   changeAudioTrack: (mute, isAudioTrack) {
          //                     Navigator.pop(context);
          //                     _meetingStore.changeTrackState(
          //                         filteredList[index].audioTrack!, mute);
          //                   },
          //                   removePeer: () async {
          //                     Navigator.pop(context);
          //                     var peer = await _meetingStore.getPeer(
          //                         peerId: filteredList[index].peerId);
          //                     _meetingStore.removePeerFromRoom(peer!);
          //                   },
          //                   mute: mutePermission,
          //                   unMute: unMutePermission,
          //                   removeOthers: removePeerPermission),
          //             ],
          //           ));
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


