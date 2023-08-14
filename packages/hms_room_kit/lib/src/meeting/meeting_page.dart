import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/meeting/meeting_header.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/active_speaker_mode.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/audio_mode.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/basic_grid_view.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/full_screen_mode.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/hero_mode.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/one_to_one_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/meeting/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class MeetingPage extends StatefulWidget {
  final String meetingLink;
  final bool isRoomMute;
  const MeetingPage(
      {Key? key, required this.meetingLink, this.isRoomMute = true})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  void initState() {
    super.initState();
    checkAudioState();
    _enableForegroundService();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
  }

  void _enableForegroundService() {
    context.read<MeetingStore>().initForegroundTask();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
        onWillPop: () async {
          bool ans = await UtilityComponents.onBackPressed(context) ?? false;
          return ans;
        },
        child: WithForegroundTask(
          child: Selector<MeetingStore, Tuple2<bool, HMSException?>>(
              selector: (_, meetingStore) =>
                  Tuple2(meetingStore.isRoomEnded, meetingStore.hmsException),
              builder: (_, data, __) {
                if (data.item2 != null) {
                  if (data.item2?.code?.errorCode == 1003 ||
                      data.item2?.code?.errorCode == 2000 ||
                      data.item2?.code?.errorCode == 4005 ||
                      data.item2?.code?.errorCode == 424) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      UtilityComponents.showErrorDialog(
                          context: context,
                          errorMessage:
                              "Error Code: ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description}",
                          errorTitle: data.item2!.message ?? "",
                          actionMessage: "Leave Room",
                          action: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
                    });
                  } else {
                    Utilities.showToast(
                        "Error : ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description} ${data.item2!.message}",
                        time: 5);
                  }
                  context.read<MeetingStore>().hmsException = null;
                }
                if (data.item1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Utilities.showToast(
                        context.read<MeetingStore>().description);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                }
                return Selector<MeetingStore, bool>(
                    selector: (_, meetingStore) => meetingStore.isPipActive,
                    builder: (_, isPipActive, __) {
                      return isPipActive && Platform.isAndroid
                          ? const PipView()
                          : Scaffold(
                              backgroundColor: HMSThemeColors.backgroundDim,
                              resizeToAvoidBottomInset: false,
                              body: SafeArea(
                                child: Theme(
                                  data: ThemeData(
                                      brightness: Brightness.dark,
                                      primaryColor:
                                          HMSThemeColors.primaryDefault,
                                      scaffoldBackgroundColor: Colors.black),
                                  child: Stack(
                                    children: [
                                      Selector<
                                              MeetingStore,
                                              Tuple6<
                                                  List<PeerTrackNode>,
                                                  bool,
                                                  int,
                                                  int,
                                                  MeetingMode,
                                                  PeerTrackNode?>>(
                                          selector: (_, meetingStore) => Tuple6(
                                              meetingStore.peerTracks,
                                              meetingStore.isHLSLink,
                                              meetingStore.peerTracks.length,
                                              meetingStore.screenShareCount,
                                              meetingStore.meetingMode,
                                              meetingStore.peerTracks.isNotEmpty
                                                  ? meetingStore.peerTracks[
                                                      meetingStore
                                                          .screenShareCount]
                                                  : null),
                                          builder: (_, data, __) {
                                            if (data.item3 == 0) {
                                              return Center(
                                                  child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: HMSThemeColors
                                                        .primaryDefault,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  if (context
                                                      .read<MeetingStore>()
                                                      .peers
                                                      .isNotEmpty)
                                                    const Text(
                                                        "Please wait for broadcaster to join")
                                                ],
                                              ));
                                            }
                                            return Selector<
                                                    MeetingStore,
                                                    Tuple2<MeetingMode,
                                                        HMSPeer?>>(
                                                selector: (_, meetingStore) =>
                                                    Tuple2(
                                                        meetingStore
                                                            .meetingMode,
                                                        meetingStore.localPeer),
                                                builder: (_, modeData, __) {
                                                  Size size = Size(
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height -
                                                          122 -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .bottom -
                                                          MediaQuery.of(context)
                                                              .padding
                                                              .top);
                                                  return Positioned(
                                                      top: 55,
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 68,
                                                      /***
                                                       * The logic for gridview is as follows:
                                                       * - Default mode is Active Speaker mode which displays only 4 tiles on screen without scroll and updates the tile according to who is currently speaking
                                                       * - If there are only 2 peers in the room in which one is local peer then automatically the mode is switched to oneToOne mode
                                                       * - As the peer count increases the mode is switched back to active speaker view in case of default mode
                                                       * - Remaining as the mode from bottom sheet is selected corresponding grid layout is rendered
                                                      */
                                                      child: ((modeData.item1 ==
                                                                      MeetingMode
                                                                          .oneToOne) )
                                                          ? OneToOneMode(
                                                              bottomMargin: 225,
                                                              peerTracks:
                                                                  data.item1,
                                                              screenShareCount:
                                                                  data.item4,
                                                              context: context,
                                                              size: size)
                                                          : (modeData.item1 ==
                                                                  MeetingMode
                                                                      .activeSpeaker)
                                                              ? activeSpeakerView(
                                                                  peerTracks: data
                                                                      .item1
                                                                     ,
                                                                  itemCount:data.item3,
                                                                  screenShareCount: data.item4,
                                                                  context: context,
                                                                  isPortrait: true,
                                                                  size: size)
                                                              : (modeData.item1 == MeetingMode.hero)
                                                                  ? heroMode(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                                  : (modeData.item1 == MeetingMode.audio)
                                                                      ? audioMode(peerTracks: data.item1.sublist(data.item4), itemCount: data.item1.sublist(data.item4).length, context: context, isPortrait: isPortraitMode, size: size)
                                                                      : (data.item5 == MeetingMode.single)
                                                                          ? fullScreenMode(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                                          : basicGridView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: true, size: size));
                                                });
                                          }),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 2),
                                              child: MeetingHeader()),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Selector<MeetingStore,
                                                      String?>(
                                                  selector: (_, meetingStore) =>
                                                      meetingStore
                                                          .localPeer?.role.name,
                                                  builder: (_, roleName, __) {
                                                    return (!(roleName
                                                                ?.contains(
                                                                    "hls-") ??
                                                            true))
                                                        ? const MeetingBottomNavigationBar()
                                                        : Container();
                                                  }))
                                        ],
                                      ),
                                      Selector<MeetingStore,
                                              HMSRoleChangeRequest?>(
                                          selector: (_, meetingStore) =>
                                              meetingStore
                                                  .currentRoleChangeRequest,
                                          builder: (_, roleChangeRequest, __) {
                                            if (roleChangeRequest != null) {
                                              HMSRoleChangeRequest
                                                  currentRequest =
                                                  roleChangeRequest;
                                              context
                                                      .read<MeetingStore>()
                                                      .currentRoleChangeRequest =
                                                  null;
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                UtilityComponents
                                                    .showRoleChangeDialog(
                                                        currentRequest,
                                                        context);
                                              });
                                            }
                                            return const SizedBox();
                                          }),
                                      Selector<MeetingStore,
                                              HMSTrackChangeRequest?>(
                                          selector: (_, meetingStore) =>
                                              meetingStore
                                                  .hmsTrackChangeRequest,
                                          builder:
                                              (_, hmsTrackChangeRequest, __) {
                                            if (hmsTrackChangeRequest != null) {
                                              HMSTrackChangeRequest
                                                  currentRequest =
                                                  hmsTrackChangeRequest;
                                              context
                                                  .read<MeetingStore>()
                                                  .hmsTrackChangeRequest = null;
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                UtilityComponents
                                                    .showTrackChangeDialog(
                                                        context,
                                                        currentRequest);
                                              });
                                            }
                                            return const SizedBox();
                                          }),
                                      Selector<MeetingStore, bool>(
                                          selector: (_, meetingStore) =>
                                              meetingStore
                                                  .showAudioDeviceChangePopup,
                                          builder: (_,
                                              showAudioDeviceChangePopup, __) {
                                            if (showAudioDeviceChangePopup) {
                                              context
                                                      .read<MeetingStore>()
                                                      .showAudioDeviceChangePopup =
                                                  false;
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        AudioDeviceChangeDialog(
                                                          currentAudioDevice: context
                                                              .read<
                                                                  MeetingStore>()
                                                              .currentAudioOutputDevice!,
                                                          audioDevicesList: context
                                                              .read<
                                                                  MeetingStore>()
                                                              .availableAudioOutputDevices,
                                                          changeAudioDevice:
                                                              (audioDevice) {
                                                            context
                                                                .read<
                                                                    MeetingStore>()
                                                                .switchAudioOutput(
                                                                    audioDevice:
                                                                        audioDevice);
                                                          },
                                                        ));
                                              });
                                            }
                                            return const SizedBox();
                                          }),
                                      Selector<MeetingStore, bool>(
                                          selector: (_, meetingStore) =>
                                              meetingStore.reconnecting,
                                          builder: (_, reconnecting, __) {
                                            if (reconnecting) {
                                              return UtilityComponents
                                                  .showReconnectingDialog(
                                                      context);
                                            }
                                            return const SizedBox();
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    });
              }),
        ));
  }
}
