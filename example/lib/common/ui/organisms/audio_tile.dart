// Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_role_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/local_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:provider/provider.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/brb_tag.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_mute_status.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/network_icon_widget.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_name.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/tile_border.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/rtc_stats_view.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/remote_peer_tile_dialog.dart';

class AudioTile extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  AudioTile({this.itemHeight = 200.0, this.itemWidth = 200.0, Key? key})
      : super(key: key);

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
        _meetingStore.localPeer?.role.permissions.changeRole ?? false;

    return InkWell(
      onLongPress: () {
        var peerTrackNode = context.read<PeerTrackNode>();
        HMSPeer peerNode = peerTrackNode.peer;
        if (!mutePermission ||
            !unMutePermission ||
            !removePeerPermission ||
            !changeRolePermission) return;
        if (peerTrackNode.peer.peerId != _meetingStore.localPeer!.peerId)
          showDialog(
              context: context,
              builder: (_) => RemotePeerTileDialog(
                    isAudioMuted: peerTrackNode.audioTrack?.isMute ?? true,
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
                      var peer =
                          await _meetingStore.getPeer(peerId: peerNode.peerId);
                      _meetingStore.removePeerFromRoom(peer!);
                    },
                    changeRole: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (_) => ChangeRoleOptionDialog(
                                peerName: peerNode.name,
                                roles: _meetingStore.roles,
                                peer: peerNode,
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
                  isAudioMode: true,
                  toggleCamera: () {
                    if (_meetingStore.isVideoOn) _meetingStore.switchCamera();
                  },
                  peerName: peerNode.name,
                  changeRole: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_) => ChangeRoleOptionDialog(
                              peerName: peerNode.name,
                              roles: _meetingStore.roles,
                              peer: peerNode,
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
                    String name = await UtilityComponents.showInputDialog(
                        context: context, placeholder: "Enter Name");
                    if (name.isNotEmpty) {
                      _meetingStore.changeName(name: name);
                    }
                  }));
      },
      child: Container(
        key: key,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(2),
        height: itemHeight + 110,
        width: itemWidth - 5.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bottomSheetColor,
        ),
        child: Semantics(
          label: "${context.read<PeerTrackNode>().peer.name}_audio",
          child: Stack(
            children: [
              Center(child: AudioLevelAvatar()),
              Positioned(
                //Bottom left
                bottom: 5,
                left: 5,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.9),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NetworkIconWidget(),
                          PeerName(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              HandRaise(), //bottom left
              BRBTag(), //top right
              AudioMuteStatus(), //bottom center
              RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
              TileBorder(
                  name: context.read<PeerTrackNode>().peer.name,
                  itemHeight: itemHeight,
                  itemWidth: itemWidth,
                  uid: context.read<PeerTrackNode>().uid)
            ],
          ),
        ),
      ),
    );
  }
}
