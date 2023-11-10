///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_page.dart';
import 'package:hms_room_kit/src/meeting/meeting_page.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[MeetingScreenController] is the controller for the meeting screen
///It is used to join the room
class MeetingScreenController extends StatefulWidget {
  ///[roomCode] is the room code of the room to join
  final String roomCode;

  ///[user] is the name of the user joining the room
  final String user;

  ///[localPeerNetworkQuality] is the network quality of the local peer
  final int? localPeerNetworkQuality;

  ///[isRoomMute] is the mute status of the room when the user joins
  ///If it's false then user can listen to the audio of the room
  ///If it's true then user can't listen to the audio of the room
  final bool isRoomMute;

  ///[showStats] is the flag to show the stats of the room
  final bool showStats;

  ///[mirrorCamera] is the flag to mirror the camera
  ///Generally set to true for local peer
  ///and false to other peers
  final bool mirrorCamera;

  ///[role] is the role of the user joining the room
  final HMSRole? role;

  ///[config] is the config of the room
  ///For more details checkout the [HMSConfig] class
  final HMSConfig? config;

  const MeetingScreenController(
      {Key? key,
      required this.roomCode,
      required this.user,
      required this.localPeerNetworkQuality,
      this.isRoomMute = false,
      this.showStats = false,
      this.mirrorCamera = true,
      this.role,
      this.config})
      : super(key: key);

  @override
  State<MeetingScreenController> createState() =>
      _MeetingScreenControllerState();
}

class _MeetingScreenControllerState extends State<MeetingScreenController> {
  HLSPlayerStore? _hlsPlayerStore;
  @override
  void initState() {
    super.initState();
    _setInitValues();
    Utilities.initForegroundTask();
  }

  ///This function sets the HLSPlayerStore if the role is hls-viewer
  void _setHLSPlayerStore() {
    _hlsPlayerStore ??= HLSPlayerStore();
  }

  ///This function sets the initial values of the meeting
  void _setInitValues() async {
    context.read<MeetingStore>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
        builder: (_, data, __) {
          ///If the role is hls-viewer then we show the HLSViewerPage
          ///else we show the MeetingPage
          if (HMSRoomLayout
                  .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
              null) {
            _setHLSPlayerStore();
            return ListenableProvider.value(
                value: _hlsPlayerStore, child: const HLSViewerPage());
          }
          return MeetingPage(
            meetingLink: widget.roomCode,
            isRoomMute: widget.isRoomMute,
          );
        },
        selector: (_, meetingStore) => meetingStore.localPeer?.role.name);
  }
}
