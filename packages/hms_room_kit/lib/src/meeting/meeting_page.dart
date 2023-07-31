import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/service/app_debug_config.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/more_settings_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/stream_timer.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
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
  bool isAudioMixerDisabled = true;

  @override
  void initState() {
    super.initState();
    checkAudioState();
    _enableAlwaysScreenOn();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
  }

  void _enableAlwaysScreenOn() {
    context.read<MeetingStore>().toggleAlwaysScreenOn();
    context.read<MeetingStore>().initForegroundTask();
  }

  String recordingState() {
    String message = "";

    Map<String, bool> recordingType =
        context.read<MeetingStore>().recordingType;

    if (recordingType["hls"] ?? false) {
      message += "HLS ";
    }
    if (recordingType["server"] ?? false) {
      message += "Server ";
    }
    if (recordingType["browser"] ?? false) {
      message += "Beam ";
    }
    message += "Recording";
    return message;
  }

  String streamingState() {
    String message = "Live";
    Map<String, bool> streamingType =
        context.read<MeetingStore>().streamingType;
    if (streamingType["hls"] ?? false) {
      message += " with HLS";
    } else if (streamingType["rtmp"] ?? false) {
      message += " with RTMP";
    }
    return message;
  }

  Widget _showPopupMenuButton({required bool isHLSRunning}) {
    return PopupMenuButton(
        tooltip: "leave_end_stream",
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: SvgPicture.asset(
          "packages/hms_room_kit/lib/src/assets/icons/exit_room.svg",
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          fit: BoxFit.scaleDown,
        ),
        color: themeBottomSheetColor,
        onSelected: (int value) async {
          switch (value) {
            case 1:
              await UtilityComponents.onLeaveStudio(context);
              break;
            case 2:
              await UtilityComponents.onEndStream(
                  leaveRoom: true,
                  context: context,
                  title: 'End Session',
                  content:
                      "The session will end for everyone and all the activities will stop. You can’t undo this action.",
                  ignoreText: "Don't End ",
                  actionText: 'End Session');
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(children: [
                  SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/exit_room.svg",
                      width: 17,
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn)),
                  const SizedBox(
                    width: 12,
                  ),
                  HMSTitleText(
                    text: "Leave Studio",
                    textColor: themeDefaultColor,
                    fontSize: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                  ),
                  Divider(
                    height: 5,
                    color: dividerColor,
                  ),
                ]),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(children: [
                  SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                    width: 17,
                    colorFilter: ColorFilter.mode(errorColor, BlendMode.srcIn),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  HMSTitleText(
                    text: "End Session",
                    textColor: errorColor,
                    fontSize: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                  ),
                  Divider(
                    height: 1,
                    color: dividerColor,
                  ),
                ]),
              ),
            ]);
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
                              backgroundColor: backgroundDim,
                              resizeToAvoidBottomInset: false,
                              body: SafeArea(
                                child: Theme(
                                  data: ThemeData(
                                      brightness: Brightness.dark,
                                      primaryColor: primaryDefault,
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
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
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
                                                      child: (((modeData.item1 ==
                                                                      MeetingMode
                                                                          .oneToOne) ||
                                                                  ((data.item3 ==
                                                                          2) &&
                                                                      context.read<MeetingStore>().peers.length ==
                                                                          2)) &&
                                                              (modeData.item2 !=
                                                                  null))
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
                                                              ? basicGridView(
                                                                  peerTracks: data
                                                                      .item1
                                                                      .sublist(
                                                                          0,
                                                                          min(data.item1.length,
                                                                              data.item4 + 4)),
                                                                  itemCount: min(data.item3, data.item4 + 4),
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Selector<MeetingStore,
                                                            bool>(
                                                        selector: (_,
                                                                meetingStore) =>
                                                            meetingStore
                                                                .hasHlsStarted,
                                                        builder: (_,
                                                            hasHlsStarted, __) {
                                                          return hasHlsStarted
                                                              ? HMSEmbeddedButton(
                                                                  onTap:
                                                                      () async =>
                                                                          {},
                                                                  width: 40,
                                                                  height: 40,
                                                                  offColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  onColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  disabledBorderColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  isActive:
                                                                      false,
                                                                  child: _showPopupMenuButton(
                                                                      isHLSRunning:
                                                                          hasHlsStarted))
                                                              : HMSEmbeddedButton(
                                                                  onTap:
                                                                      () async =>
                                                                          {
                                                                    await UtilityComponents
                                                                        .onBackPressed(
                                                                            context)
                                                                  },
                                                                  width: 40,
                                                                  height: 40,
                                                                  offColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  onColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  disabledBorderColor:
                                                                      const Color(
                                                                          0xffCC525F),
                                                                  isActive:
                                                                      false,
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "packages/hms_room_kit/lib/src/assets/icons/exit_room.svg",
                                                                    colorFilter: const ColorFilter
                                                                        .mode(
                                                                        Colors
                                                                            .white,
                                                                        BlendMode
                                                                            .srcIn),
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    semanticsLabel:
                                                                        "leave_button",
                                                                  ),
                                                                );
                                                        }),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Selector<
                                                            MeetingStore,
                                                            Tuple4<
                                                                bool,
                                                                bool,
                                                                Map<String,
                                                                    bool>,
                                                                Map<String,
                                                                    bool>>>(
                                                        selector: (_, meetingStore) => Tuple4(
                                                            ((meetingStore.streamingType["rtmp"] ??
                                                                    false) ||
                                                                (meetingStore.streamingType[
                                                                        "hls"] ??
                                                                    false)),
                                                            ((meetingStore.recordingType[
                                                                        "browser"] ??
                                                                    false) ||
                                                                (meetingStore.recordingType[
                                                                        "server"] ??
                                                                    false) ||
                                                                ((meetingStore
                                                                            .recordingType[
                                                                        "hls"] ??
                                                                    false))),
                                                            meetingStore
                                                                .streamingType,
                                                            meetingStore
                                                                .recordingType),
                                                        builder:
                                                            (_, roomState, __) {
                                                          if (roomState.item1 ||
                                                              roomState.item2) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              5.0),
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "packages/hms_room_kit/lib/src/assets/icons/live_stream.svg",
                                                                        colorFilter: ColorFilter.mode(
                                                                            errorColor,
                                                                            BlendMode.srcIn),
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (!roomState.item1 &&
                                                                            roomState.item2) {
                                                                          Utilities.showToast(
                                                                              recordingState());
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        (roomState.item1 &&
                                                                                roomState.item2)
                                                                            ? "Live & Recording"
                                                                            : (roomState.item1)
                                                                                ? streamingState()
                                                                                : (roomState.item2)
                                                                                    ? "Recording"
                                                                                    : "",
                                                                        semanticsLabel:
                                                                            "fl_live_stream_running",
                                                                        style: GoogleFonts.inter(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                themeDefaultColor,
                                                                            letterSpacing:
                                                                                0.5,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                roomState.item1
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          (roomState.item3["hls"] ?? false)
                                                                              ? Row(
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                      "packages/hms_room_kit/lib/src/assets/icons/clock.svg",
                                                                                      colorFilter: ColorFilter.mode(themeSubHeadingColor, BlendMode.srcIn),
                                                                                      fit: BoxFit.scaleDown,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Selector<MeetingStore, HMSRoom?>(
                                                                                        selector: (_, meetingStore) => meetingStore.hmsRoom,
                                                                                        builder: (_, hmsRoom, __) {
                                                                                          if (hmsRoom != null && hmsRoom.hmshlsStreamingState != null && hmsRoom.hmshlsStreamingState!.variants.isNotEmpty && hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt != null) {
                                                                                            return HMSStreamTimer(startedAt: hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt!);
                                                                                          }
                                                                                          return HMSSubtitleText(
                                                                                            text: "00:00",
                                                                                            textColor: themeSubHeadingColor,
                                                                                          );
                                                                                        }),
                                                                                  ],
                                                                                )
                                                                              : Container(),
                                                                          HMSSubtitleText(
                                                                            text:
                                                                                " | ",
                                                                            textColor:
                                                                                dividerColor,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                "packages/hms_room_kit/lib/src/assets/icons/watching.svg",
                                                                                colorFilter: ColorFilter.mode(themeSubHeadingColor, BlendMode.srcIn),
                                                                                fit: BoxFit.scaleDown,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 6,
                                                                              ),
                                                                              Selector<MeetingStore, int>(
                                                                                  selector: (_, meetingStore) => meetingStore.peers.length,
                                                                                  builder: (_, length, __) {
                                                                                    return HMSSubtitleText(text: length.toString(), textColor: themeSubHeadingColor);
                                                                                  })
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    : Container()
                                                              ],
                                                            );
                                                          }
                                                          return const SizedBox();
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    if (Provider.of<MeetingStore>(
                                                                context)
                                                            .localPeer
                                                            ?.role
                                                            .publishSettings
                                                            ?.allowed
                                                            .contains(
                                                                "video") ??
                                                        false)
                                                      Selector<MeetingStore,
                                                              bool>(
                                                          selector: (_,
                                                                  meetingStore) =>
                                                              meetingStore
                                                                  .isVideoOn,
                                                          builder: (_,
                                                              isVideoOn, __) {
                                                            return HMSEmbeddedButton(
                                                              onTap: () => {
                                                                if (isVideoOn)
                                                                  {
                                                                    context
                                                                        .read<
                                                                            MeetingStore>()
                                                                        .switchCamera()
                                                                  }
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              isActive: true,
                                                              child: SvgPicture
                                                                  .asset(
                                                                "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                                                                colorFilter: ColorFilter.mode(
                                                                    isVideoOn
                                                                        ? onSurfaceHighEmphasis
                                                                        : onSurfaceLowEmphasis,
                                                                    BlendMode
                                                                        .srcIn),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "fl_switch_camera",
                                                              ),
                                                            );
                                                          }),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Column(
                                              children: [
                                                if (Provider.of<MeetingStore>(
                                                                context)
                                                            .localPeer !=
                                                        null &&
                                                    !Provider.of<MeetingStore>(
                                                            context)
                                                        .localPeer!
                                                        .role
                                                        .name
                                                        .contains("hls-"))
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      if (Provider.of<MeetingStore>(context)
                                                              .localPeer !=
                                                          null)
                                                        (Provider.of<MeetingStore>(context)
                                                                    .localPeer
                                                                    ?.role
                                                                    .publishSettings
                                                                    ?.allowed
                                                                    .contains(
                                                                        "audio") ??
                                                                false)
                                                            ? Selector<
                                                                    MeetingStore,
                                                                    bool>(
                                                                selector: (_, meetingStore) =>
                                                                    meetingStore
                                                                        .isMicOn,
                                                                builder: (_, isMicOn, __) {
                                                                  return HMSEmbeddedButton(
                                                                    onTap: () =>
                                                                        {
                                                                      context
                                                                          .read<
                                                                              MeetingStore>()
                                                                          .toggleMicMuteState()
                                                                    },
                                                                    width: 40,
                                                                    height: 40,
                                                                    disabledBorderColor:
                                                                        borderColor,
                                                                    offColor:
                                                                        themeHMSBorderColor,
                                                                    onColor:
                                                                        themeScreenBackgroundColor,
                                                                    isActive:
                                                                        isMicOn,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      isMicOn
                                                                          ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                                                                          : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                                                                      colorFilter: ColorFilter.mode(
                                                                          themeDefaultColor,
                                                                          BlendMode
                                                                              .srcIn),
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      semanticsLabel:
                                                                          "audio_mute_button",
                                                                    ),
                                                                  );
                                                                })
                                                            : Selector<
                                                                    MeetingStore,
                                                                    bool>(
                                                                selector: (_, meetingStore) =>
                                                                    meetingStore
                                                                        .isSpeakerOn,
                                                                builder: (_,
                                                                    isSpeakerOn,
                                                                    __) {
                                                                  return HMSEmbeddedButton(
                                                                    onTap: () =>
                                                                        {
                                                                      context
                                                                          .read<
                                                                              MeetingStore>()
                                                                          .toggleSpeaker(),
                                                                    },
                                                                    width: 40,
                                                                    height: 40,
                                                                    disabledBorderColor:
                                                                        borderColor,
                                                                    offColor:
                                                                        themeHMSBorderColor,
                                                                    onColor:
                                                                        themeScreenBackgroundColor,
                                                                    isActive:
                                                                        isSpeakerOn,
                                                                    child: SvgPicture.asset(
                                                                        isSpeakerOn
                                                                            ? "packages/hms_room_kit/lib/src/assets/icons/speaker_state_on.svg"
                                                                            : "packages/hms_room_kit/lib/src/assets/icons/speaker_state_off.svg",
                                                                        colorFilter: ColorFilter.mode(
                                                                            themeDefaultColor,
                                                                            BlendMode
                                                                                .srcIn),
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "speaker_mute_button"),
                                                                  );
                                                                }),
                                                      if (Provider.of<MeetingStore>(context)
                                                              .localPeer !=
                                                          null)
                                                        (Provider.of<MeetingStore>(context)
                                                                    .localPeer
                                                                    ?.role
                                                                    .publishSettings
                                                                    ?.allowed
                                                                    .contains(
                                                                        "video") ??
                                                                false)
                                                            ? Selector<
                                                                    MeetingStore,
                                                                    Tuple2<bool,
                                                                        bool>>(
                                                                selector: (_, meetingStore) => Tuple2(
                                                                    meetingStore
                                                                        .isVideoOn,
                                                                    meetingStore.meetingMode ==
                                                                        MeetingMode
                                                                            .audio),
                                                                builder: (_, data, __) {
                                                                  return HMSEmbeddedButton(
                                                                    onTap: () =>
                                                                        {
                                                                      (data.item2)
                                                                          ? null
                                                                          : context
                                                                              .read<MeetingStore>()
                                                                              .toggleCameraMuteState(),
                                                                    },
                                                                    width: 40,
                                                                    height: 40,
                                                                    disabledBorderColor:
                                                                        borderColor,
                                                                    offColor:
                                                                        themeHMSBorderColor,
                                                                    onColor:
                                                                        themeScreenBackgroundColor,
                                                                    isActive: data
                                                                        .item1,
                                                                    child: SvgPicture.asset(
                                                                        data.item1
                                                                            ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                                                                            : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                                                                        colorFilter: ColorFilter.mode(
                                                                            themeDefaultColor,
                                                                            BlendMode
                                                                                .srcIn),
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "video_mute_button"),
                                                                  );
                                                                })
                                                            : Selector<
                                                                    MeetingStore,
                                                                    bool>(
                                                                selector: (_, meetingStore) =>
                                                                    meetingStore.isStatsVisible,
                                                                builder: (_, isStatsVisible, __) {
                                                                  return HMSEmbeddedButton(
                                                                    width: 40,
                                                                    height: 40,
                                                                    onTap: () => context
                                                                        .read<
                                                                            MeetingStore>()
                                                                        .changeStatsVisible(),
                                                                    disabledBorderColor:
                                                                        borderColor,
                                                                    offColor:
                                                                        themeScreenBackgroundColor,
                                                                    onColor:
                                                                        themeHMSBorderColor,
                                                                    isActive:
                                                                        isStatsVisible,
                                                                    child: SvgPicture.asset(
                                                                        "packages/hms_room_kit/lib/src/assets/icons/stats.svg",
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "stats_button"),
                                                                  );
                                                                }),
                                                      Selector<MeetingStore,
                                                              bool>(
                                                          selector: (_,
                                                                  meetingStore) =>
                                                              meetingStore
                                                                  .isNewMessageReceived,
                                                          builder: (_,
                                                              isNewMessageReceived,
                                                              __) {
                                                            return HMSEmbeddedButton(
                                                              onTap: () => {
                                                                context
                                                                    .read<
                                                                        MeetingStore>()
                                                                    .getSessionMetadata(
                                                                        SessionStoreKeyValues.getNameFromMethod(
                                                                            SessionStoreKey.pinnedMessageSessionKey)),
                                                                context
                                                                    .read<
                                                                        MeetingStore>()
                                                                    .setNewMessageFalse(),
                                                                showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      themeBottomSheetColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) => ChangeNotifierProvider.value(
                                                                      value: context
                                                                          .read<
                                                                              MeetingStore>(),
                                                                      child:
                                                                          const ChatBottomSheet()),
                                                                )
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              offColor:
                                                                  themeHintColor,
                                                              onColor:
                                                                  themeScreenBackgroundColor,
                                                              isActive: true,
                                                              child: SvgPicture
                                                                  .asset(
                                                                isNewMessageReceived
                                                                    ? "packages/hms_room_kit/lib/src/assets/icons/message_badge_on.svg"
                                                                    : "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "chat_button",
                                                              ),
                                                            );
                                                          }),
                                                      if (Provider.of<MeetingStore>(
                                                                  context)
                                                              .localPeer !=
                                                          null)
                                                        HMSEmbeddedButton(
                                                          onTap: () async => {
                                                            isAudioMixerDisabled =
                                                                await Utilities
                                                                        .getBoolData(
                                                                            key:
                                                                                "audio-mixer-disabled") ??
                                                                    true,
                                                            showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  themeBottomSheetColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  ChangeNotifierProvider
                                                                      .value(
                                                                          value: context.read<
                                                                              MeetingStore>(),
                                                                          child:
                                                                              MoreSettingsBottomSheet(
                                                                            isAudioMixerDisabled:
                                                                                AppDebugConfig.isAudioMixerDisabled,
                                                                          )),
                                                            )
                                                          },
                                                          width: 40,
                                                          height: 40,
                                                          offColor:
                                                              themeHintColor,
                                                          onColor:
                                                              themeScreenBackgroundColor,
                                                          isActive: true,
                                                          child: SvgPicture.asset(
                                                              "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                                              colorFilter:
                                                                  ColorFilter.mode(
                                                                      themeDefaultColor,
                                                                      BlendMode
                                                                          .srcIn),
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              semanticsLabel:
                                                                  "more_button"),
                                                        ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          )
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