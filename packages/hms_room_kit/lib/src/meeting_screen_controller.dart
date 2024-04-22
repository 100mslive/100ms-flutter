///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_loader.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_page.dart';
import 'package:hms_room_kit/src/meeting/meeting_page.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[MeetingScreenController] is the controller for the meeting screen
///It is used to join the room
class MeetingScreenController extends StatefulWidget {
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

  ///[options] are the prebuilt options
  final HMSPrebuiltOptions? options;

  ///[tokenData] is the auth token for the room
  final String? tokenData;

  ///[currentAudioDeviceMode] is the current audio device mode
  final HMSAudioDevice currentAudioDeviceMode;

  ///[hmsSDKInteractor] is used to interact with the SDK
  final HMSSDKInteractor hmsSDKInteractor;

  final bool isNoiseCancellationEnabled;

  const MeetingScreenController(
      {Key? key,
      required this.user,
      required this.localPeerNetworkQuality,
      this.isRoomMute = false,
      this.showStats = false,
      this.mirrorCamera = true,
      this.role,
      this.config,
      this.currentAudioDeviceMode = HMSAudioDevice.AUTOMATIC,
      this.options,
      this.tokenData,
      required this.hmsSDKInteractor,
      this.isNoiseCancellationEnabled = false})
      : super(key: key);

  @override
  State<MeetingScreenController> createState() =>
      _MeetingScreenControllerState();
}

class _MeetingScreenControllerState extends State<MeetingScreenController> {
  HLSPlayerStore? _hlsPlayerStore;
  bool showLoader = false;
  late MeetingStore _meetingStore;

  @override
  void initState() {
    super.initState();

    ///Here we create an instance of meeting store, set initial settings and join meeting.
    _meetingStore = MeetingStore(hmsSDKInteractor: widget.hmsSDKInteractor);
    _setInitValues();
    _joinMeeting();

    ///If the role is hlsStreaming we set the HLS Player store
    if (HMSRoomLayout.roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
        null) {
      _setHLSPlayerStore();
    }
  }

  ///This function joins the room only if the name is not empty
  void _joinMeeting() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (mounted) {
      setState(() {
        showLoader = true;
      });
    }

    ///We join the room here
    await _meetingStore.join(widget.user, widget.tokenData);
    setState(() {
      showLoader = false;
    });
  }

  ///This function sets the HLSPlayerStore if the role is hls-viewer
  void _setHLSPlayerStore() {
    _hlsPlayerStore ??= HLSPlayerStore();
  }

  ///This function sets the initial values of the meeting
  void _setInitValues() async {
    _meetingStore.setSettings();
  }

  void setScreenRotation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (HMSRoomLayout
              .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
          null) {
        _meetingStore.allowScreenRotation(true);
      } else {
        _meetingStore.allowScreenRotation(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoader
        ? const HMSLoader()
        : ListenableProvider.value(
            value: _meetingStore,
            child: Selector<MeetingStore, String?>(
                selector: (_, meetingStore) =>
                    meetingStore.localPeer?.role.name,
                builder: (_, data, __) {
                  setScreenRotation();
                  return (HMSRoomLayout.roleLayoutData?.screens?.conferencing
                              ?.hlsLiveStreaming !=
                          null)
                      ? ListenableProvider.value(
                          value: _hlsPlayerStore, child: const HLSViewerPage())
                      : MeetingPage(
                          isRoomMute: widget.isRoomMute,
                          currentAudioDeviceMode: widget.currentAudioDeviceMode,
                          isNoiseCancellationEnabled:
                              widget.isNoiseCancellationEnabled,
                        );
                }),
          );
  }
}
