// Package imports
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_role_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/local_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:hmssdk_flutter_example/common/ui/organisms/brb_tag.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/degrade_tile.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_mute_status.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/network_icon_widget.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_name.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/tile_border.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/rtc_stats_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_view.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/remote_peer_tile_dialog.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final ScaleType scaleType;

  VideoTile(
      {Key? key,
      this.itemHeight = 200.0,
      this.itemWidth = 200.0,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL})
      : super(key: key);

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
    bool changeRolePermission =
        _meetingStore.localPeer!.role.permissions.changeRole ?? false;

    return FocusDetector(
      onFocusLost: () {
        if (mounted) {
          Provider.of<PeerTrackNode>(context, listen: false)
              .setOffScreenStatus(true);
        }
      },
      onFocusGained: () {
        Provider.of<PeerTrackNode>(context, listen: false)
            .setOffScreenStatus(false);
      },
      key: Key(context.read<PeerTrackNode>().uid),
      child: context.read<PeerTrackNode>().uid.contains("mainVideo")
          ? InkWell(
              onLongPress: () {
                var peerTrackNode = context.read<PeerTrackNode>();
                HMSPeer peerNode = peerTrackNode.peer;
                if (!mutePermission ||
                    !unMutePermission ||
                    !removePeerPermission ||
                    !changeRolePermission) return;
                if (peerTrackNode.peer.peerId !=
                    _meetingStore.localPeer!.peerId)
                  showDialog(
                      context: context,
                      builder: (_) => RemotePeerTileDialog(
                            isAudioMuted:
                                peerTrackNode.audioTrack?.isMute ?? true,
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
                            changeRole: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (_) => ChangeRoleOptionDialog(
                                        peerName: peerNode.name,
                                        getRoleFunction:
                                            _meetingStore.getRoles(),
                                        changeRole: (role, forceChange) {
                                          Navigator.pop(context);
                                          _meetingStore.changeRole(
                                              peer: peerNode,
                                              roleName: role,
                                              forceChange: forceChange);
                                        },
                                      ));
                            },
                            mute: mutePermission,
                            unMute: unMutePermission,
                            removeOthers: removePeerPermission,
                            roles: changeRolePermission,
                          ));
                else
                  showDialog(
                      context: context,
                      builder: (_) => LocalPeerTileDialog(
                          isAudioMode: false,
                          toggleCamera: () {
                            if (_meetingStore.isVideoOn)
                              _meetingStore.switchCamera();
                          },
                          peerName: peerNode.name,
                          changeRole: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) => ChangeRoleOptionDialog(
                                      peerName: peerNode.name,
                                      getRoleFunction: _meetingStore.getRoles(),
                                      changeRole: (role, forceChange) {
                                        Navigator.pop(context);
                                        _meetingStore.changeRole(
                                            peer: peerNode,
                                            roleName: role,
                                            forceChange: forceChange);
                                      },
                                    ));
                          },
                          roles: changeRolePermission,
                          changeName: () async {
                            String name =
                                await UtilityComponents.showInputDialog(
                                    context: context,
                                    placeholder: "Enter Name");
                            if (name.isNotEmpty) {
                              _meetingStore.changeName(name: name);
                            }
                          }));
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
                    VideoView(
                      uid: context.read<PeerTrackNode>().uid,
                      scaleType: widget.scaleType,
                      itemHeight: widget.itemHeight,
                      itemWidth: widget.itemWidth,
                    ),

                    DegradeTile(
                      itemHeight: widget.itemHeight,
                      itemWidth: widget.itemWidth,
                    ),
                    PeerName(),
                    HandRaise(), //bottom left
                    BRBTag(), //top right
                    NetworkIconWidget(), //top left
                    AudioMuteStatus(), //bottom center
                    RTCStatsView(
                        isLocal: context.read<PeerTrackNode>().peer.isLocal),
                    TileBorder(
                        itemHeight: widget.itemHeight,
                        itemWidth: widget.itemWidth,
                        name: context.read<PeerTrackNode>().peer.name,
                        uid: context.read<PeerTrackNode>().uid)
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              key: key,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(2),
              height: widget.itemHeight + 110,
              width: widget.itemWidth - 5.0,
              child: Stack(
                children: [
                  VideoView(
                    uid: context.read<PeerTrackNode>().uid,
                    scaleType: widget.scaleType,
                  ),
                  PeerName(),
                ],
              ),
            ),
    );
  }
}
