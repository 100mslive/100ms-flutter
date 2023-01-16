import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_device_change.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/embedded_button.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/full_screen_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_audio_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_hero_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/one_to_one_mode.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/stream_timer.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/hls_start_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/hls_message.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/hls_more_settings.dart';
import 'package:hmssdk_flutter_example/hls-streaming/meeting_mode/hls_grid_view.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/hls_participant_sheet.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/pip_view.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer.dart';
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSBroadcasterPage extends StatefulWidget {
  final String meetingLink;
  final bool isAudioOn;
  final bool isStreamingLink;
  final bool isRoomMute;
  const HLSBroadcasterPage(
      {Key? key,
      required this.meetingLink,
      required this.isAudioOn,
      this.isStreamingLink = false,
      this.isRoomMute = true})
      : super(key: key);

  @override
  State<HLSBroadcasterPage> createState() => _HLSBroadcasterPageState();
}

class _HLSBroadcasterPageState extends State<HLSBroadcasterPage> {
  bool isAudioMixerDisabled = true;
  @override
  void initState() {
    super.initState();
    checkAudioState();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
  }

  Widget _showPopupMenuButton({required bool isHLSRunning}) {
    return PopupMenuButton(
        tooltip: "leave_end_stream",
        offset: Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: SvgPicture.asset(
          "assets/icons/leave_hls.svg",
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
                child: Row(children: [
                  SvgPicture.asset("assets/icons/leave_hls.svg",
                      width: 17, color: themeDefaultColor),
                  SizedBox(
                    width: 12,
                  ),
                  HLSTitleText(
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
                value: 1,
              ),
              PopupMenuItem(
                child: Row(children: [
                  SvgPicture.asset("assets/icons/end_warning.svg",
                      width: 17, color: errorColor),
                  SizedBox(
                    width: 12,
                  ),
                  HLSTitleText(
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
                value: 2,
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
        child: WillStartForegroundTask(
          onWillStart: () async {
            // Return whether to start the foreground service.
            return true;
          },
          androidNotificationOptions: AndroidNotificationOptions(
            channelId: '100ms_flutter_notification',
            channelName: '100ms Flutter Notification',
            channelDescription:
                'This notification appears when the foreground service is running.',
            channelImportance: NotificationChannelImportance.LOW,
            priority: NotificationPriority.LOW,
            iconData: NotificationIconData(
              resType: ResourceType.mipmap,
              resPrefix: ResourcePrefix.ic,
              name: 'launcher',
            ),
          ),
          iosNotificationOptions: const IOSNotificationOptions(
            showNotification: false,
            playSound: false,
          ),
          foregroundTaskOptions: const ForegroundTaskOptions(
            interval: 5000,
            autoRunOnBoot: false,
            allowWifiLock: false,
          ),
          notificationTitle: '100ms foreground service running',
          notificationText: 'Tap to return to the app',
          child: Selector<MeetingStore, Tuple2<bool, HMSException?>>(
              selector: (_, meetingStore) =>
                  Tuple2(meetingStore.isRoomEnded, meetingStore.hmsException),
              builder: (_, data, __) {
                if (data.item2 != null) {
                  if (data.item2?.code?.errorCode == 1003 ||
                      data.item2?.code?.errorCode == 2000 ||
                      data.item2?.code?.errorCode == 4005) {
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
                      return isPipActive
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
                                            meetingStore.peerTracks.length > 0
                                                ? meetingStore.peerTracks[
                                                    meetingStore
                                                        .screenShareCount]
                                                : null),
                                        builder: (_, data, __) {
                                          if (data.item2) {
                                            return Selector<MeetingStore, bool>(
                                                selector: (_, meetingStore) =>
                                                    meetingStore.hasHlsStarted,
                                                builder:
                                                    (_, hasHlsStarted, __) {
                                                  return hasHlsStarted
                                                      ? Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.735,
                                                          child: Center(
                                                            child: HLSPlayer(),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.735,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8.0),
                                                                  child: Text(
                                                                    "Waiting for HLS to start...",
                                                                    style: GoogleFonts.inter(
                                                                        color:
                                                                            iconColor,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                });
                                          }
                                          if (data.item3 == 0) {
                                            return Center(
                                                child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                if (context
                                                        .read<MeetingStore>()
                                                        .peers
                                                        .length >
                                                    0)
                                                  Text(
                                                      "Please wait for broadcaster to join")
                                              ],
                                            ));
                                          }
                                          return Selector<
                                                  MeetingStore,
                                                  Tuple3<MeetingMode, HMSPeer?,
                                                      int>>(
                                              selector: (_, meetingStore) =>
                                                  Tuple3(
                                                      meetingStore.meetingMode,
                                                      meetingStore.localPeer,
                                                      meetingStore
                                                          .peers.length),
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
                                                    bottom: (widget.isStreamingLink &&
                                                            (modeData.item2?.role.permissions.hlsStreaming ==
                                                                true))
                                                        ? 108
                                                        : 68,
                                                    child: Container(
                                                        child: ((modeData.item1 == MeetingMode.Video) &&
                                                                (data.item3 ==
                                                                    2) &&
                                                                (modeData.item2 !=
                                                                    null) &&
                                                                (modeData.item3 ==
                                                                    2))
                                                            ? OneToOneMode(
                                                                bottomMargin: (widget.isStreamingLink && (modeData.item2?.role.permissions.hlsStreaming == true))
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
                                                                        .Hero)
                                                                ? gridHeroView(
                                                                    peerTracks: data.item1,
                                                                    itemCount: data.item3,
                                                                    screenShareCount: data.item4,
                                                                    context: context,
                                                                    isPortrait: isPortraitMode,
                                                                    size: size)
                                                                : (modeData.item1 == MeetingMode.Audio)
                                                                    ? gridAudioView(peerTracks: data.item1.sublist(data.item4), itemCount: data.item1.sublist(data.item4).length, context: context, isPortrait: isPortraitMode, size: size)
                                                                    : (data.item5 == MeetingMode.Single)
                                                                        ? fullScreenView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                                        : hlsGridView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: true, size: size)));
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
                                                            ? EmbeddedButton(
                                                                onTap:
                                                                    () async =>
                                                                        {},
                                                                width: 40,
                                                                height: 40,
                                                                offColor: Color(
                                                                    0xffCC525F),
                                                                onColor: Color(
                                                                    0xffCC525F),
                                                                disabledBorderColor:
                                                                    Color(
                                                                        0xffCC525F),
                                                                isActive: false,
                                                                child: _showPopupMenuButton(
                                                                    isHLSRunning:
                                                                        hasHlsStarted))
                                                            : EmbeddedButton(
                                                                onTap:
                                                                    () async =>
                                                                        {
                                                                  await UtilityComponents
                                                                      .onBackPressed(
                                                                          context)
                                                                },
                                                                width: 40,
                                                                height: 40,
                                                                offColor: Color(
                                                                    0xffCC525F),
                                                                onColor: Color(
                                                                    0xffCC525F),
                                                                disabledBorderColor:
                                                                    Color(
                                                                        0xffCC525F),
                                                                isActive: false,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "assets/icons/leave_hls.svg",
                                                                  color: Colors
                                                                      .white,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "leave_button",
                                                                ),
                                                              );
                                                      }),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Selector<MeetingStore, bool>(
                                                      selector: (_,
                                                              meetingStore) =>
                                                          meetingStore
                                                              .hasHlsStarted,
                                                      builder: (_,
                                                          hasHlsStarted, __) {
                                                        if (hasHlsStarted)
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
                                                                      "assets/icons/live_stream.svg",
                                                                      color:
                                                                          errorColor,
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Live",
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
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/icons/clock.svg",
                                                                        color:
                                                                            themeSubHeadingColor,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            6,
                                                                      ),
                                                                      Selector<
                                                                              MeetingStore,
                                                                              HMSRoom?>(
                                                                          selector: (_, meetingStore) => meetingStore
                                                                              .hmsRoom,
                                                                          builder: (_,
                                                                              hmsRoom,
                                                                              __) {
                                                                            if (hmsRoom != null &&
                                                                                hmsRoom.hmshlsStreamingState != null &&
                                                                                hmsRoom.hmshlsStreamingState!.variants.length != 0 &&
                                                                                hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt != null) {
                                                                              return StreamTimer(startedAt: hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt!);
                                                                            }
                                                                            return HLSSubtitleText(
                                                                              text: "00:00",
                                                                              textColor: themeSubHeadingColor,
                                                                            );
                                                                          }),
                                                                    ],
                                                                  ),
                                                                  HLSSubtitleText(
                                                                    text: " | ",
                                                                    textColor:
                                                                        dividerColor,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        "assets/icons/watching.svg",
                                                                        color:
                                                                            themeSubHeadingColor,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            6,
                                                                      ),
                                                                      Selector<
                                                                              MeetingStore,
                                                                              int>(
                                                                          selector: (_, meetingStore) => meetingStore
                                                                              .peers
                                                                              .length,
                                                                          builder: (_,
                                                                              length,
                                                                              __) {
                                                                            return HLSSubtitleText(
                                                                                text: length.toString(),
                                                                                textColor: themeSubHeadingColor);
                                                                          })
                                                                    ],
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        return SizedBox();
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
                                                        return EmbeddedButton(
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
                                                            "assets/icons/hand_outline.svg",
                                                            color:
                                                                themeDefaultColor,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            semanticsLabel:
                                                                "hand_raise_button",
                                                          ),
                                                        );
                                                      }),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  EmbeddedButton(
                                                    onTap: () => {
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            themeBottomSheetColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        context: context,
                                                        builder: (ctx) =>
                                                            ChangeNotifierProvider.value(
                                                                value: context.read<
                                                                    MeetingStore>(),
                                                                child:
                                                                    HLSParticipantSheet()),
                                                      )
                                                    },
                                                    width: 40,
                                                    height: 40,
                                                    offColor:
                                                        themeScreenBackgroundColor,
                                                    onColor:
                                                        themeScreenBackgroundColor,
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/participants.svg",
                                                      color: themeDefaultColor,
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "participants_button",
                                                    ),
                                                  ),
                                                  SizedBox(
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
                                                        return EmbeddedButton(
                                                          onTap: () => {
                                                            context
                                                                .read<
                                                                    MeetingStore>()
                                                                .getSessionMetadata(),
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
                                                                          HLSMessage()),
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
                                                                ? "assets/icons/message_badge_on.svg"
                                                                : "assets/icons/message_badge_off.svg",
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
                                                                return EmbeddedButton(
                                                                  onTap: () => {
                                                                    context
                                                                        .read<
                                                                            MeetingStore>()
                                                                        .switchAudio()
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
                                                                        ? "assets/icons/mic_state_on.svg"
                                                                        : "assets/icons/mic_state_off.svg",
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
                                                                return EmbeddedButton(
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
                                                                          ? "assets/icons/speaker_state_on.svg"
                                                                          : "assets/icons/speaker_state_off.svg",
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
                                                                return EmbeddedButton(
                                                                  onTap: () => {
                                                                    (data.item2)
                                                                        ? null
                                                                        : context
                                                                            .read<MeetingStore>()
                                                                            .switchVideo(),
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
                                                                          ? "assets/icons/cam_state_on.svg"
                                                                          : "assets/icons/cam_state_off.svg",
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
                                                                return EmbeddedButton(
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
                                                                      "assets/icons/stats.svg",
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
                                                                  SizedBox(
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
                                                                          "assets/icons/end.svg",
                                                                          color:
                                                                              themeDefaultColor,
                                                                          height:
                                                                              36,
                                                                          semanticsLabel:
                                                                              "hls_end_button"),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                                  SizedBox(
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
                                                                SizedBox(
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
                                                                              HLSStartBottomSheet()),
                                                                    );
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 40,
                                                                    backgroundColor:
                                                                        hmsdefaultColor,
                                                                    child: SvgPicture.asset(
                                                                        "assets/icons/live.svg",
                                                                        color:
                                                                            themeDefaultColor,
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "start_hls_button"),
                                                                  ),
                                                                ),
                                                                SizedBox(
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
                                                                return EmbeddedButton(
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
                                                                      "assets/icons/screen_share.svg",
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
                                                                return EmbeddedButton(
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
                                                                      "assets/icons/brb.svg",
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
                                                      EmbeddedButton(
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
                                                                            HLSMoreSettings(
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
                                                            "assets/icons/more.svg",
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
                                          return SizedBox();
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
                                          return SizedBox();
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
                                          return SizedBox();
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
                                          return SizedBox();
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
