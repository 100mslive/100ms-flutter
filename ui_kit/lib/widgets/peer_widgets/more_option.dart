import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/enums/session_store_keys.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/change_role_option_dialog.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/change_simulcast_layer_option_dialog.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/local_peer_tile_dialog.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/remote_peer_tile_dialog.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
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
      right: 1,
      child: GestureDetector(
        onTap: () {
          var peerTrackNode = context.read<PeerTrackNode>();
          if (peerTrackNode.peer.peerId != _meetingStore.localPeer!.peerId) {
            showDialog(
                context: context,
                builder: (_) => RemotePeerTileDialog(
                      isAudioMuted: peerTrackNode.audioTrack?.isMute ?? true,
                      isVideoMuted: peerTrackNode.track == null
                          ? true
                          : peerTrackNode.track!.isMute,
                      peerName: peerTrackNode.peer.name,
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
                      isSpotlightedPeer:
                          context.read<MeetingStore>().spotLightPeer?.uid ==
                              peerTrackNode.uid,
                      setOnSpotlight: () {
                        if (context.read<MeetingStore>().spotLightPeer?.uid ==
                            peerTrackNode.uid) {
                          _meetingStore.setSessionMetadata(
                              key: SessionStoreKeyValues.getNameFromMethod(
                                  SessionStoreKey.SPOTLIGHT),
                              metadata: null);
                          return;
                        }

                        ///Setting the metadata as audio trackId if it's not present
                        ///then setting it as video trackId
                        String? metadata = (peerTrackNode.audioTrack == null)
                            ? peerTrackNode.track?.trackId
                            : peerTrackNode.audioTrack?.trackId;
                        _meetingStore.setSessionMetadata(
                            key: SessionStoreKeyValues.getNameFromMethod(
                                SessionStoreKey.SPOTLIGHT),
                            metadata: metadata);
                      },
                      removePeer: () async {
                        Navigator.pop(context);
                        var peer = await _meetingStore.getPeer(
                            peerId: peerTrackNode.peer.peerId);
                        _meetingStore.removePeerFromRoom(peer!);
                      },
                      changeRole: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (_) => ChangeRoleOptionDialog(
                                  peerName: peerTrackNode.peer.name,
                                  roles: _meetingStore.roles,
                                  peer: peerTrackNode.peer,
                                  changeRole: (role, forceChange) {
                                    _meetingStore.changeRoleOfPeer(
                                        peer: peerTrackNode.peer,
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
          } else {
            showDialog(
                context: context,
                builder: (_) => LocalPeerTileDialog(
                    isVideoOn:
                        !(context.read<PeerTrackNode>().track?.isMute ?? true),
                    isAudioMode: false,
                    toggleCamera: () {
                      if (_meetingStore.isVideoOn) {
                        _meetingStore.switchCamera();
                      }
                    },
                    peerName: peerTrackNode.peer.name,
                    toggleFlash: () {
                      context.read<MeetingStore>().toggleFlash();
                    },
                    isSpotlightedPeer:
                        context.read<MeetingStore>().spotLightPeer?.uid ==
                            peerTrackNode.uid,
                    setOnSpotlight: () {
                      if (context.read<MeetingStore>().spotLightPeer?.uid ==
                          peerTrackNode.uid) {
                        _meetingStore.setSessionMetadata(
                            key: SessionStoreKeyValues.getNameFromMethod(
                                SessionStoreKey.SPOTLIGHT),
                            metadata: null);
                        return;
                      }

                      ///Setting the metadata as audio trackId if it's not present
                      ///then setting it as video trackId
                      String? metadata = (peerTrackNode.audioTrack == null)
                          ? peerTrackNode.track?.trackId
                          : peerTrackNode.audioTrack?.trackId;
                      _meetingStore.setSessionMetadata(
                          key: SessionStoreKeyValues.getNameFromMethod(
                              SessionStoreKey.SPOTLIGHT),
                          metadata: metadata);
                    },
                    changeRole: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (_) => ChangeRoleOptionDialog(
                                peerName: peerTrackNode.peer.name,
                                roles: _meetingStore.roles,
                                peer: peerTrackNode.peer,
                                changeRole: (role, forceChange) {
                                  _meetingStore.changeRoleOfPeer(
                                      peer: peerTrackNode.peer,
                                      roleName: role,
                                      forceChange: forceChange);
                                },
                              ));
                    },
                    roles: changeRolePermission,
                    changeName: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      String name =
                          await UtilityComponents.showNameChangeDialog(
                              context: context,
                              placeholder: "Enter Name",
                              prefilledValue: context
                                      .read<MeetingStore>()
                                      .localPeer
                                      ?.name ??
                                  "");
                      if (name.isNotEmpty) {
                        _meetingStore.changeName(name: name);
                      }
                    }));
          }
        },
        child: Semantics(
          label: "fl_${context.read<PeerTrackNode>().peer.name}more_option",
          child: const Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Icon(Icons.more_horiz),
          ),
        ),
      ),
    );
  }
}
