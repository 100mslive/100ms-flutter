// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final PeerTrackNode peerTrackNode;
  final bool audioView;
  final int index;

  VideoTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.peerTrackNode,
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
    // final data = context.watch<MeetingStore>().peerTracks[widget.index];
    final data = context.select<MeetingStore, PeerTrackNode>(
        (meetingStore) => meetingStore.peerTracks[widget.index]);
    print("Rebuilding.... ${data.peer.name}");

    bool mutePermission = data.peer.role.permissions.mute ?? false;
    bool unMutePermission = data.peer.role.permissions.unMute ?? false;
    bool removePeerPermission =
        data.peer.role.permissions.removeOthers ?? false;

    return VisibilityDetector(
      key: Key(data.uid),
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage <= 40) {
          data.isVideoOn = false;
        } else {
          data.isVideoOn = !(data.track?.isMute ?? true);
        }
      },
      child: InkWell(
        onLongPress: () {
          if (!mutePermission || !unMutePermission || !removePeerPermission)
            return;
          if (!widget.audioView && (!(data.peer.isLocal)))
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
        child: Container(
          color: Colors.transparent,
          key: key,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.all(2),
          height: widget.itemHeight + 110,
          width: widget.itemWidth - 5.0,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if ((data.track == null) || !(data.isVideoOn ?? true)) {
                    return Container(
                      height: widget.itemHeight + 100,
                      width: widget.itemWidth - 5,
                      child: Center(
                          child: CircleAvatar(
                              child: Text(
                                  Utilities.getAvatarTitle(data.peer.name)))),
                    );
                  }

                  return Container(
                    height: widget.itemHeight + 100,
                    width: widget.itemWidth - 5,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                    child: HMSVideoView(
                      track: data.track!,
                      setMirror: false,
                      matchParent: false,
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                    "${data.peer.name} ${data.peer.isLocal ? "(You)" : ""}"),
              ),
              (data.peer.metadata == "{\"isHandRaised\":true}")
                  ? Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Image.asset(
                          'assets/icons/raise_hand.png',
                          color: Colors.amber.shade300,
                        ),
                      ),
                      top: 5.0,
                      left: 5.0,
                    )
                  : Container(),
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
