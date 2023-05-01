import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/change_role_option_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/change_simulcast_layer_option_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/local_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/remote_peer_tile_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/session_store_key.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
          if (peerTrackNode.peer.peerId != _meetingStore.localPeer!.peerId)
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
                        String? metadata = (peerTrackNode.track == null)
                            ? peerTrackNode.audioTrack?.trackId
                            : peerTrackNode.track?.trackId;
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
                      captureSnapshot: () async {
                        Uint8List? bytes = await context
                            .read<PeerTrackNode>()
                            .track
                            ?.captureSnapshot();
                        if (bytes != null) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  actionsPadding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  backgroundColor: themeBottomSheetColor,
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 15, left: 24, right: 24),
                                  title: Text(
                                      context.read<PeerTrackNode>().peer.name +
                                          "'s Snapshot"),
                                  content: Image.memory(bytes),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        themeSurfaceColor),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        themeBottomSheetColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          107, 125, 153, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ))),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              child: Text('Cancel',
                                                  style: GoogleFonts.inter(
                                                      color: themeDefaultColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.50)),
                                            )),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      themeSurfaceColor),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      hmsdefaultColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: hmsdefaultColor),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ))),
                                          onPressed: () async {
                                            Map result = await ImageGallerySaver
                                                .saveImage(bytes,
                                                    quality: 100,
                                                    name: peerTrackNode
                                                            .peer.name +
                                                        DateTime.now()
                                                            .toIso8601String());
                                            if (result
                                                    .containsKey("isSuccess") &&
                                                result["isSuccess"]) {
                                              Utilities.showToast(
                                                  "Snapshot save to Gallery");
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            child: Text(
                                              'Save',
                                              style: GoogleFonts.inter(
                                                  color: themeDefaultColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      isCaptureSnapshot: !(peerTrackNode.track?.isMute ?? true),
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
                      isVideoOn:
                          !(context.read<PeerTrackNode>().track?.isMute ??
                              true),
                      isAudioMode: false,
                      toggleCamera: () {
                        if (_meetingStore.isVideoOn)
                          _meetingStore.switchCamera();
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
                        String? metadata = (peerTrackNode.track == null)
                            ? peerTrackNode.audioTrack?.trackId
                            : peerTrackNode.track?.trackId;
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
                      },
                      localImageCapture: () async {
                        Navigator.pop(context);
                        HMSLocalVideoTrack? track = (context
                            .read<PeerTrackNode>()
                            .track as HMSLocalVideoTrack?);
                        if (track != null) {
                          if (track.isMute) {
                            Utilities.showToast(
                                "Please unmute the video to capture the image");
                            return;
                          }
                          //Here we are sending [withFlash] as true
                          //So flash will turn ON while capturing
                          //image
                          dynamic res = await HMSCameraControls
                              .captureImageAtMaxSupportedResolution(
                                  withFlash: true);
                          if (res is HMSException) {
                            Utilities.showToast(
                                "Error Occured: code: ${res.code?.errorCode}, description: ${res.description}, message: ${res.message}",
                                time: 5);
                            return;
                          }
                          File imageFile = File(res);
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  actionsPadding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  backgroundColor: themeBottomSheetColor,
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 15, left: 24, right: 24),
                                  title: Text(
                                      context.read<PeerTrackNode>().peer.name +
                                          "'s  Snapshot"),
                                  content: Image.file(imageFile),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        themeSurfaceColor),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        themeBottomSheetColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          107, 125, 153, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ))),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              child: Text('Cancel',
                                                  style: GoogleFonts.inter(
                                                      color: themeDefaultColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.50)),
                                            )),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      themeSurfaceColor),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      hmsdefaultColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: hmsdefaultColor),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ))),
                                          onPressed: () async {
                                            Share.shareXFiles([XFile(res)],
                                                text: "HMS Image");
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            child: Text(
                                              'Share',
                                              style: GoogleFonts.inter(
                                                  color: themeDefaultColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      isCaptureSnapshot: !(peerTrackNode.track?.isMute ?? true),
                      captureSnapshot: () async {
                        Uint8List? bytes = await context
                            .read<PeerTrackNode>()
                            .track
                            ?.captureSnapshot();
                        if (bytes != null) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  actionsPadding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  backgroundColor: themeBottomSheetColor,
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 15, left: 24, right: 24),
                                  title: Text(
                                      context.read<PeerTrackNode>().peer.name +
                                          "'s  Snapshot"),
                                  content: Image.memory(bytes),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        themeSurfaceColor),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        themeBottomSheetColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Color.fromRGBO(
                                                          107, 125, 153, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ))),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              child: Text('Cancel',
                                                  style: GoogleFonts.inter(
                                                      color: themeDefaultColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.50)),
                                            )),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      themeSurfaceColor),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      hmsdefaultColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: hmsdefaultColor),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ))),
                                          onPressed: () async {
                                            Map result = await ImageGallerySaver
                                                .saveImage(bytes,
                                                    quality: 100,
                                                    name: peerTrackNode
                                                            .peer.name +
                                                        DateTime.now()
                                                            .toIso8601String());
                                            if (result
                                                    .containsKey("isSuccess") &&
                                                result["isSuccess"]) {
                                              Utilities.showToast(
                                                  "Snapshot save to Gallery");
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 10),
                                            child: Text(
                                              'Save',
                                              style: GoogleFonts.inter(
                                                  color: themeDefaultColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        }
                      },
                    ));
        },
        child: Semantics(
          label: "fl_${context.read<PeerTrackNode>().peer.name}more_option",
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Icon(Icons.more_horiz),
          ),
        ),
      ),
    );
  }
}
