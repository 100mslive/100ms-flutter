import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/change_role_option_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/change_simulcast_layer_option_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/local_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/remote_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:provider/provider.dart';

class MoreOption extends StatelessWidget {
  const MoreOption({Key? key}) : super(key: key);

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

    return Positioned(
      bottom: 5,
      right: 5,
      child: GestureDetector(
        onTap: () {
          var peerTrackNode = context.read<PeerTrackNode>();
          HMSPeer peerNode = peerTrackNode.peer;
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
                                  roles: _meetingStore.roles,
                                  peer: peerNode,
                                  changeRole: (role, forceChange) {
                                    _meetingStore.changeRoleOfPeer(
                                        peer: peerNode,
                                        roleName: role,
                                        forceChange: forceChange);
                                  },
                                ));
                      },
                      changeLayer: () async {
                        Navigator.pop(context);
                        HMSRemoteVideoTrack track =
                            peerTrackNode.track as HMSRemoteVideoTrack;
                        List<HMSSimulcastLayerDefinition> layerDefinitions =
                            await track.getLayerDefinition();
                        HMSSimulcastLayer selectedLayer =
                            await track.getLayer();
                        if (layerDefinitions.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (_) => ChangeSimulcastLayerOptionDialog(
                                  layerDefinitions: layerDefinitions,
                                  selectedLayer: selectedLayer,
                                  track: track));
                        } else {
                          Utilities.showToast(
                              "Simulcast not enabled for the role");
                        }
                      },
                      mute: mutePermission,
                      unMute: unMutePermission,
                      removeOthers: removePeerPermission,
                      roles: changeRolePermission,
                      simulcast: (peerTrackNode.track != null &&
                          !(peerTrackNode.track as HMSRemoteVideoTrack).isMute),
                      pinTile: peerTrackNode.pinTile,
                      changePinTileStatus: () {
                        _meetingStore.changePinTileStatus(peerTrackNode);
                        Navigator.pop(context);
                      },
                    ));
          else
            showDialog(
                context: context,
                builder: (_) => LocalPeerTileDialog(
                    isAudioMode: false,
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
                                  _meetingStore.changeRoleOfPeer(
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
        child: Semantics(
          label: "fl_${context.read<PeerTrackNode>().peer.name}more_option",
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
