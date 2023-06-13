import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/enums/meeting_mode.dart';
import 'package:hmssdk_uikit/enums/session_store_keys.dart';
import 'package:hmssdk_uikit/hmssdk_interactor.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/more_settings_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/start_hls_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/stream_timer.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/subtitle_text.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/audio_mode.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/basic_grid_view.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/full_screen_mode.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/hero_mode.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/one_to_one_mode.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
import 'package:hmssdk_uikit/widgets/meeting/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:wakelock/wakelock.dart';

class MeetingPage extends StatefulWidget {
  final String meetingLink;
  final bool isStreamingLink;
  final bool isRoomMute;
  const MeetingPage(
      {Key? key,
      required this.meetingLink,
      this.isStreamingLink = false,
      this.isRoomMute = true})
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
    Wakelock.enable();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
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
          "packages/hmssdk_uikit/lib/assets/icons/leave_hls.svg",
          color: Colors.white,
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
                      "packages/hmssdk_uikit/lib/assets/icons/leave_hls.svg",
                      width: 17,
                      color: themeDefaultColor),
                  const SizedBox(
                    width: 12,
                  ),
                  TitleText(
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
                      "packages/hmssdk_uikit/lib/assets/icons/end_warning.svg",
                      width: 17,
                      color: errorColor),
                  const SizedBox(
                    width: 12,
                  ),
                  TitleText(
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
                          ? PipView()
                          : Scaffold(
                              resizeToAvoidBottomInset: false,
                              body: SafeArea(
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
                                                      meetingStore.meetingMode,
                                                      meetingStore.localPeer),
                                              builder: (_, modeData, __) {
                                                Size size = Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height -
                                                        ((widget.isStreamingLink &&
                                                                (modeData
                                                                        .item2
                                                                        ?.role
                                                                        .permissions
                                                                        .hlsStreaming ==
                                                                    true))
                                                            ? 163
                                                            : 122) -
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
                                                    bottom: (widget.isStreamingLink && (modeData.item2?.role.permissions.hlsStreaming == true))
                                                        ? 108
                                                        : 68,
                                                    /***
                                                     * The logic for gridview is as follows:
                                                     * - Default mode is Active Speaker mode which displays only 4 tiles on screen without scroll and updates the tile according to who is currently speaking
                                                     * - If there are only 2 peers in the room in which one is local peer then automatically the mode is switched to oneToOne mode
                                                     * - As the peer count increases the mode is switched back to active speaker view in case of default mode
                                                     * - Remaining as the mode from bottom sheet is selected corresponding grid layout is rendered
                                                    */
                                                    child: Container(
                                                        child: (((modeData.item1 == MeetingMode.OneToOne) || ((data.item3 == 2) && context.read<MeetingStore>().peers.length == 2)) &&
                                                                (modeData.item2 !=
                                                                    null))
                                                            ? OneToOneMode(
                                                                bottomMargin:
                                                                    (widget.isStreamingLink && (modeData.item2?.role.permissions.hlsStreaming == true))
                                                                        ? 272
                                                                        : 235,
                                                                peerTracks:
                                                                    data.item1,
                                                                screenShareCount:
                                                                    data.item4,
                                                                context:
                                                                    context,
                                                                size: size)
                                                            : (modeData.item1 ==
                                                                    MeetingMode
                                                                        .ActiveSpeaker)
                                                                ? basicGridView(
                                                                    peerTracks:
                                                                        data.item1.sublist(0, min(data.item1.length, data.item4 + 4)),
                                                                    itemCount: min(data.item3, data.item4 + 4),
                                                                    screenShareCount: data.item4,
                                                                    context: context,
                                                                    isPortrait: true,
                                                                    size: size)
                                                                : (modeData.item1 == MeetingMode.Hero)
                                                                    ? heroMode(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                                    : (modeData.item1 == MeetingMode.Audio)
                                                                        ? audioMode(peerTracks: data.item1.sublist(data.item4), itemCount: data.item1.sublist(data.item4).length, context: context, isPortrait: isPortraitMode, size: size)
                                                                        : (data.item5 == MeetingMode.Single)
                                                                            ? fullScreenMode(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                                            : basicGridView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: true, size: size)));
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Selector<MeetingStore, bool>(
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
                                                                isActive: false,
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
                                                                isActive: false,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "packages/hmssdk_uikit/lib/assets/icons/leave_hls.svg",
                                                                  color: Colors
                                                                      .white,
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
                                                              Map<String, bool>,
                                                              Map<String,
                                                                  bool>>>(
                                                      selector: (_, meetingStore) => Tuple4(
                                                          ((meetingStore.streamingType[
                                                                      "rtmp"] ??
                                                                  false) ||
                                                              (meetingStore
                                                                          .streamingType[
                                                                      "hls"] ??
                                                                  false)),
                                                          ((meetingStore.recordingType[
                                                                      "browser"] ??
                                                                  false) ||
                                                              (meetingStore
                                                                          .recordingType[
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
                                                                      "packages/hmssdk_uikit/lib/assets/icons/live_stream.svg",
                                                                      color:
                                                                          errorColor,
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (!roomState
                                                                              .item1 &&
                                                                          roomState
                                                                              .item2) {
                                                                        Utilities.showToast(
                                                                            recordingState());
                                                                      }
                                                                    },
                                                                    child: Text(
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
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        (roomState.item3["hls"] ??
                                                                                false)
                                                                            ? Row(
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                    "packages/hmssdk_uikit/lib/assets/icons/clock.svg",
                                                                                    color: themeSubHeadingColor,
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
                                                                                        return SubtitleText(
                                                                                          text: "00:00",
                                                                                          textColor: themeSubHeadingColor,
                                                                                        );
                                                                                      }),
                                                                                ],
                                                                              )
                                                                            : Container(),
                                                                        SubtitleText(
                                                                          text:
                                                                              " | ",
                                                                          textColor:
                                                                              dividerColor,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              "packages/hmssdk_uikit/lib/assets/icons/watching.svg",
                                                                              color: themeSubHeadingColor,
                                                                              fit: BoxFit.scaleDown,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 6,
                                                                            ),
                                                                            Selector<MeetingStore, int>(
                                                                                selector: (_, meetingStore) => meetingStore.peers.length,
                                                                                builder: (_, length, __) {
                                                                                  return SubtitleText(text: length.toString(), textColor: themeSubHeadingColor);
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
                                                  Selector<MeetingStore, bool>(
                                                      selector: (_,
                                                              meetingStore) =>
                                                          meetingStore
                                                              .isRaisedHand,
                                                      builder:
                                                          (_, handRaised, __) {
                                                        return HMSEmbeddedButton(
                                                          onTap: () => {
                                                            context
                                                                .read<
                                                                    MeetingStore>()
                                                                .changeMetadata()
                                                          },
                                                          width: 40,
                                                          height: 40,
                                                          disabledBorderColor:
                                                              borderColor,
                                                          offColor:
                                                              themeScreenBackgroundColor,
                                                          onColor:
                                                              themeHintColor,
                                                          isActive: handRaised,
                                                          child:
                                                              SvgPicture.asset(
                                                            "packages/hmssdk_uikit/lib/assets/icons/hand_outline.svg",
                                                            color:
                                                                themeDefaultColor,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            semanticsLabel:
                                                                "hand_raise_button",
                                                          ),
                                                        );
                                                      }),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Selector<MeetingStore, bool>(
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
                                                                        SessionStoreKey
                                                                            .PINNED_MESSAGE_SESSION_KEY)),
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  ChangeNotifierProvider.value(
                                                                      value: context
                                                                          .read<
                                                                              MeetingStore>(),
                                                                      child:
                                                                          ChatBottomSheet()),
                                                            )
                                                          },
                                                          width: 40,
                                                          height: 40,
                                                          offColor:
                                                              themeHintColor,
                                                          onColor:
                                                              themeScreenBackgroundColor,
                                                          isActive: true,
                                                          child:
                                                              SvgPicture.asset(
                                                            isNewMessageReceived
                                                                ? "packages/hmssdk_uikit/lib/assets/icons/message_badge_on.svg"
                                                                : "packages/hmssdk_uikit/lib/assets/icons/message_badge_off.svg",
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            semanticsLabel:
                                                                "chat_button",
                                                          ),
                                                        );
                                                      })
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
                                                              builder: (_,
                                                                  isMicOn, __) {
                                                                return HMSEmbeddedButton(
                                                                  onTap: () => {
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
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    isMicOn
                                                                        ? "packages/hmssdk_uikit/lib/assets/icons/mic_state_on.svg"
                                                                        : "packages/hmssdk_uikit/lib/assets/icons/mic_state_off.svg",
                                                                    color:
                                                                        themeDefaultColor,
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
                                                              builder: (_, isSpeakerOn, __) {
                                                                return HMSEmbeddedButton(
                                                                  onTap: () => {
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
                                                                          ? "packages/hmssdk_uikit/lib/assets/icons/speaker_state_on.svg"
                                                                          : "packages/hmssdk_uikit/lib/assets/icons/speaker_state_off.svg",
                                                                      color:
                                                                          themeDefaultColor,
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
                                                                          .Audio),
                                                              builder: (_, data, __) {
                                                                return HMSEmbeddedButton(
                                                                  onTap: () => {
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
                                                                          ? "packages/hmssdk_uikit/lib/assets/icons/cam_state_on.svg"
                                                                          : "packages/hmssdk_uikit/lib/assets/icons/cam_state_off.svg",
                                                                      color:
                                                                          themeDefaultColor,
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
                                                                      "packages/hmssdk_uikit/lib/assets/icons/stats.svg",
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      semanticsLabel:
                                                                          "stats_button"),
                                                                );
                                                              }),
                                                    if ((Provider.of<MeetingStore>(
                                                                    context)
                                                                .localPeer !=
                                                            null) &&
                                                        (context
                                                                .read<
                                                                    MeetingStore>()
                                                                .localPeer
                                                                ?.role
                                                                .permissions
                                                                .hlsStreaming ==
                                                            true) &&
                                                        widget.isStreamingLink)
                                                      Selector<
                                                              MeetingStore,
                                                              Tuple2<bool,
                                                                  bool>>(
                                                          selector: (_,
                                                                  meetingStore) =>
                                                              Tuple2(
                                                                  meetingStore
                                                                      .hasHlsStarted,
                                                                  meetingStore
                                                                      .isHLSLoading),
                                                          builder:
                                                              (_, data, __) {
                                                            if (data.item1) {
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      UtilityComponents.onEndStream(
                                                                          context:
                                                                              context,
                                                                          title:
                                                                              'End live stream for all?',
                                                                          content:
                                                                              "Your live stream will end and stream viewers will go offline immediately in this room. You can’t undo this action.",
                                                                          ignoreText:
                                                                              "Don't End ",
                                                                          actionText:
                                                                              'End Stream');
                                                                    },
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          40,
                                                                      backgroundColor:
                                                                          errorColor,
                                                                      child: SvgPicture.asset(
                                                                          "packages/hmssdk_uikit/lib/assets/icons/end.svg",
                                                                          color:
                                                                              themeDefaultColor,
                                                                          height:
                                                                              36,
                                                                          semanticsLabel:
                                                                              "hls_end_button"),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    "END STREAM",
                                                                    style: GoogleFonts.inter(
                                                                        letterSpacing:
                                                                            1.5,
                                                                        fontSize:
                                                                            10,
                                                                        height:
                                                                            1.6,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )
                                                                ],
                                                              );
                                                            } else if (data
                                                                .item2) {
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child: CircleAvatar(
                                                                        radius: 40,
                                                                        backgroundColor: themeScreenBackgroundColor,
                                                                        child: CircularProgressIndicator(
                                                                          semanticsLabel:
                                                                              "hls_loader",
                                                                          strokeWidth:
                                                                              2,
                                                                          color:
                                                                              hmsdefaultColor,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    "STARTING HLS",
                                                                    style: GoogleFonts.inter(
                                                                        letterSpacing:
                                                                            1.5,
                                                                        fontSize:
                                                                            10,
                                                                        height:
                                                                            1.6,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                            return Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          themeBottomSheetColor,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      context:
                                                                          context,
                                                                      builder: (ctx) => ChangeNotifierProvider.value(
                                                                          value: context.read<
                                                                              MeetingStore>(),
                                                                          child:
                                                                              StartHLSBottomSheet()),
                                                                    );
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 40,
                                                                    backgroundColor:
                                                                        hmsdefaultColor,
                                                                    child: SvgPicture.asset(
                                                                        "packages/hmssdk_uikit/lib/assets/icons/live.svg",
                                                                        color:
                                                                            themeDefaultColor,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "start_hls_button"),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "GO LIVE",
                                                                  style: GoogleFonts.inter(
                                                                      letterSpacing:
                                                                          1.5,
                                                                      fontSize:
                                                                          10,
                                                                      height:
                                                                          1.6,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )
                                                              ],
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
                                                                      "screen") ??
                                                              false)
                                                          ? Selector<
                                                                  MeetingStore,
                                                                  bool>(
                                                              selector: (_,
                                                                      meetingStore) =>
                                                                  meetingStore
                                                                      .isScreenShareOn,
                                                              builder: (_, data,
                                                                  __) {
                                                                return HMSEmbeddedButton(
                                                                  onTap: () {
                                                                    MeetingStore
                                                                        meetingStore =
                                                                        Provider.of<MeetingStore>(
                                                                            context,
                                                                            listen:
                                                                                false);
                                                                    if (meetingStore
                                                                        .isScreenShareOn) {
                                                                      meetingStore
                                                                          .stopScreenShare();
                                                                    } else {
                                                                      meetingStore
                                                                          .startScreenShare();
                                                                    }
                                                                  },
                                                                  width: 40,
                                                                  height: 40,
                                                                  disabledBorderColor:
                                                                      borderColor,
                                                                  offColor:
                                                                      themeScreenBackgroundColor,
                                                                  onColor:
                                                                      borderColor,
                                                                  isActive:
                                                                      data,
                                                                  child: SvgPicture.asset(
                                                                      "packages/hmssdk_uikit/lib/assets/icons/screen_share.svg",
                                                                      color:
                                                                          themeDefaultColor,
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      semanticsLabel:
                                                                          "screen_share_button"),
                                                                );
                                                              })
                                                          : Selector<
                                                                  MeetingStore,
                                                                  bool>(
                                                              selector: (_,
                                                                      meetingStore) =>
                                                                  (meetingStore.isBRB),
                                                              builder: (_, isBRB, __) {
                                                                return HMSEmbeddedButton(
                                                                  width: 40,
                                                                  height: 40,
                                                                  onTap: () => context
                                                                      .read<
                                                                          MeetingStore>()
                                                                      .changeMetadataBRB(),
                                                                  disabledBorderColor:
                                                                      borderColor,
                                                                  offColor:
                                                                      themeScreenBackgroundColor,
                                                                  onColor:
                                                                      borderColor,
                                                                  isActive:
                                                                      isBRB,
                                                                  child: SvgPicture.asset(
                                                                      "packages/hmssdk_uikit/lib/assets/icons/brb.svg",
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      semanticsLabel:
                                                                          "brb_button"),
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
                                                                              isAudioMixerDisabled,
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
                                                            "packages/hmssdk_uikit/lib/assets/icons/more.svg",
                                                            color:
                                                                themeDefaultColor,
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
                                                      currentRequest, context);
                                            });
                                          }
                                          return const SizedBox();
                                        }),
                                    Selector<MeetingStore,
                                            HMSTrackChangeRequest?>(
                                        selector: (_, meetingStore) =>
                                            meetingStore.hmsTrackChangeRequest,
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
                                                      context, currentRequest);
                                            });
                                          }
                                          return const SizedBox();
                                        }),
                                    Selector<MeetingStore, bool>(
                                        selector: (_, meetingStore) =>
                                            meetingStore
                                                .showAudioDeviceChangePopup,
                                        builder: (_, showAudioDeviceChangePopup,
                                            __) {
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
                            );
                    });
              }),
        ));
  }
}
