import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_chat.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_waiting_ui.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerPage extends StatefulWidget {
  const HLSViewerPage({
    Key? key,
  }) : super(key: key);
  @override
  State<HLSViewerPage> createState() => _HLSViewerPageState();
}

class _HLSViewerPageState extends State<HLSViewerPage> {
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

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HLSPlayerStore>().startTimerToHideButtons();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool ans = await UtilityComponents.onBackPressed(context) ?? false;
        return ans;
      },
      child: Selector<MeetingStore, Tuple2<bool, HMSException?>>(
          selector: (_, meetingStore) =>
              Tuple2(meetingStore.isRoomEnded, meetingStore.hmsException),
          builder: (_, data, __) {
            if (data.item2 != null &&
                (data.item2?.code?.errorCode == 1003 ||
                    data.item2?.code?.errorCode == 2000 ||
                    data.item2?.code?.errorCode == 4005)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                UtilityComponents.showErrorDialog(
                    context: context,
                    errorMessage:
                        "Error Code: ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description}",
                    errorTitle: data.item2!.message ?? "",
                    actionMessage: "Leave Room",
                    action: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    });
              });
            }
            if (data.item1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Utilities.showToast(context.read<MeetingStore>().description);
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
            return Selector<MeetingStore, bool>(
                selector: (_, meetingStore) => meetingStore.isPipActive,
                builder: (_, isPipActive, __) {
                  return isPipActive
                      ? HMSHLSPlayer()
                      : Scaffold(
                          resizeToAvoidBottomInset: true,
                          body: SafeArea(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Selector<HLSPlayerStore, bool>(
                                      selector: (_, hlsPlayerStore) =>
                                          hlsPlayerStore.isFullScreen,
                                      builder: (_, isFullScreen, __) {
                                        return Visibility(
                                          visible: !isFullScreen,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 2),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "packages/hms_room_kit/lib/src/assets/icons/generic.svg",
                                                  width: 45,
                                                  height: 40,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    HMSSubheadingText(
                                                      text: "100ms HLS Player",
                                                      textColor:
                                                          onSurfaceHighEmphasis,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.1,
                                                    ),
                                                    HMSSubtitleText(
                                                        text:
                                                            "Session ${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
                                                        textColor:
                                                            onSurfaceLowEmphasis)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  Selector<MeetingStore, bool>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.hasHlsStarted,
                                      builder: (_, hasHlsStarted, __) {
                                        return (hasHlsStarted)
                                            ? Selector<HLSPlayerStore, bool>(
                                                selector: (_, hlsPlayerStore) =>
                                                    hlsPlayerStore.isFullScreen,
                                                builder: (_, isFullScreen, __) {
                                                  return SizedBox(
                                                    height: isFullScreen
                                                        ? MediaQuery.of(context)
                                                            .size
                                                            .height
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    child: Stack(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    HLSPlayerStore>()
                                                                .toggleButtonsVisibility();
                                                          },
                                                          child: Center(
                                                            child: HLSPlayer(
                                                              key: Key(context
                                                                      .read<
                                                                          MeetingStore>()
                                                                      .localPeer
                                                                      ?.peerId ??
                                                                  "HLS_PLAYER"),
                                                              ratio: Utilities
                                                                  .getHLSPlayerDefaultRatio(
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Selector<
                                                                  HLSPlayerStore,
                                                                  bool>(
                                                              selector: (_,
                                                                      hlsPlayerStore) =>
                                                                  hlsPlayerStore
                                                                      .areStreamControlsVisible,
                                                              builder: (_,
                                                                  areButtonsVisible,
                                                                  __) {
                                                                return AnimatedOpacity(
                                                                  opacity:
                                                                      areButtonsVisible
                                                                          ? 1.0
                                                                          : 0.0,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  child: Selector<
                                                                          HLSPlayerStore,
                                                                          bool>(
                                                                      selector: (_,
                                                                              hlsPlayerStore) =>
                                                                          hlsPlayerStore
                                                                              .isStreamPlaying,
                                                                      builder: (_,
                                                                          isPlaying,
                                                                          __) {
                                                                        return ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            context.read<HLSPlayerStore>().togglePlayPause();
                                                                          },
                                                                          style: ButtonStyle(
                                                                              enableFeedback: false,
                                                                              backgroundColor: isPlaying ? MaterialStatePropertyAll(primaryDefault) : MaterialStatePropertyAll(surfaceDefault),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.9)),
                                                                              ),
                                                                              fixedSize: MaterialStateProperty.all<Size>(const Size(8, 8))),
                                                                          child:
                                                                              Icon(
                                                                            isPlaying
                                                                                ? Icons.pause
                                                                                : Icons.play_arrow_rounded,
                                                                            color:
                                                                                onSurfaceHighEmphasis,
                                                                          ),
                                                                        );
                                                                      }),
                                                                );
                                                              }),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Selector<
                                                                  HLSPlayerStore,
                                                                  bool>(
                                                              selector: (_,
                                                                      hlsPlayerStore) =>
                                                                  hlsPlayerStore
                                                                      .areStreamControlsVisible,
                                                              builder: (_,
                                                                  areButtonsVisible,
                                                                  __) {
                                                                return AnimatedOpacity(
                                                                  opacity:
                                                                      areButtonsVisible
                                                                          ? 1.0
                                                                          : 0.0,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10.0,
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        SvgPicture
                                                                            .asset(
                                                                          "packages/hms_room_kit/lib/src/assets/icons/red_dot.svg",
                                                                          width:
                                                                              4,
                                                                          height:
                                                                              4,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap: () =>
                                                                                HMSHLSPlayerController.seekToLivePosition(),
                                                                            child: HMSTitleText(
                                                                              text: "LIVE",
                                                                              textColor: onSurfaceHighEmphasis,
                                                                              fontSize: 12,
                                                                              lineHeight: 16,
                                                                              letterSpacing: 0.4,
                                                                            )),
                                                                        const SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        SvgPicture
                                                                            .asset(
                                                                          "packages/hms_room_kit/lib/src/assets/icons/settings.svg",
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          semanticsLabel:
                                                                              "settings",
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () => context
                                                                              .read<HLSPlayerStore>()
                                                                              .toggleFullScreen(context),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "packages/hms_room_kit/lib/src/assets/icons/${isFullScreen ? "minimize" : "maximize"}.svg",
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                })
                                            : const Center(
                                                child: HLSWaitingUI());
                                      }),
                                  Selector<HLSPlayerStore, bool>(
                                      selector: (_, hlsPlayerStore) =>
                                          hlsPlayerStore.isFullScreen,
                                      builder: (_, isFullScreen, __) {
                                        return Visibility(
                                          visible: !isFullScreen,
                                          child: ChangeNotifierProvider.value(
                                              value:
                                                  context.read<MeetingStore>(),
                                              child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.50,
                                                  child: const HLSChat())),
                                        );
                                      }),
                                  isPipActive
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Selector<HLSPlayerStore, bool>(
                                              selector: (_, hlsPlayerStore) =>
                                                  hlsPlayerStore.isFullScreen,
                                              builder: (_, isFullScreen, __) {
                                                return Visibility(
                                                  visible: !isFullScreen,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 20.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            HMSEmbeddedButton(
                                                              onTap: () async =>
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
                                                              child: SvgPicture
                                                                  .asset(
                                                                "packages/hms_room_kit/lib/src/assets/icons/phone_hangup.svg",
                                                                colorFilter: ColorFilter.mode(
                                                                    onSurfaceHighEmphasis,
                                                                    BlendMode
                                                                        .srcIn),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "leave_button",
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            if (Provider.of<MeetingStore>(
                                                                        context)
                                                                    .localPeer !=
                                                                null)
                                                              Selector<
                                                                      MeetingStore,
                                                                      bool>(
                                                                  selector: (_,
                                                                          meetingStore) =>
                                                                      meetingStore
                                                                          .isMicOn,
                                                                  builder: (_,
                                                                      isMicOn,
                                                                      __) {
                                                                    return HMSEmbeddedButton(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        if (!(context.read<MeetingStore>().localPeer?.role.publishSettings?.allowed.contains("audio") ??
                                                                            true))
                                                                          {
                                                                            context.read<MeetingStore>().toggleMicMuteState()
                                                                          }
                                                                      },
                                                                      width: 40,
                                                                      height:
                                                                          40,
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
                                                                            (context.read<MeetingStore>().localPeer?.role.publishSettings?.allowed.contains("audio") ?? false)
                                                                                ? onSurfaceHighEmphasis
                                                                                : onSurfaceLowEmphasis,
                                                                            BlendMode.srcIn),
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        semanticsLabel:
                                                                            "audio_mute_button",
                                                                      ),
                                                                    );
                                                                  }),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () => {},
                                                              child: SvgPicture
                                                                  .asset(
                                                                "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "chat_button",
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            HMSEmbeddedButton(
                                                              height: 40,
                                                              width: 40,
                                                              onTap: () async =>
                                                                  {},
                                                              isActive: true,
                                                              child: SvgPicture
                                                                  .asset(
                                                                "packages/hms_room_kit/lib/src/assets/icons/emoji.svg",
                                                                colorFilter: ColorFilter.mode(
                                                                    onSurfaceHighEmphasis,
                                                                    BlendMode
                                                                        .srcIn),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "emoji_button",
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Selector<
                                                                    MeetingStore,
                                                                    bool>(
                                                                selector: (_,
                                                                        meetingStore) =>
                                                                    meetingStore
                                                                        .isRaisedHand,
                                                                builder: (_,
                                                                    handRaised,
                                                                    __) {
                                                                  return HMSEmbeddedButton(
                                                                    height: 40,
                                                                    width: 40,
                                                                    onTap: () =>
                                                                        {
                                                                      context
                                                                          .read<
                                                                              MeetingStore>()
                                                                          .changeMetadata()
                                                                    },
                                                                    isActive:
                                                                        true,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                                                                      colorFilter: ColorFilter.mode(
                                                                          handRaised
                                                                              ? const Color.fromRGBO(250, 201, 25,
                                                                                  1)
                                                                              : onSurfaceHighEmphasis,
                                                                          BlendMode
                                                                              .srcIn),
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                      semanticsLabel:
                                                                          "hand_raise_button",
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                  Selector<MeetingStore, HMSRoleChangeRequest?>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.currentRoleChangeRequest,
                                      builder: (_, roleChangeRequest, __) {
                                        if (roleChangeRequest != null) {
                                          HMSRoleChangeRequest currentRequest =
                                              roleChangeRequest;
                                          context
                                              .read<MeetingStore>()
                                              .currentRoleChangeRequest = null;
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
                                      builder: (_, hmsTrackChangeRequest, __) {
                                        if (hmsTrackChangeRequest != null) {
                                          HMSTrackChangeRequest currentRequest =
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
                                      builder:
                                          (_, showAudioDeviceChangePopup, __) {
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
                                                          .read<MeetingStore>()
                                                          .currentAudioOutputDevice!,
                                                      audioDevicesList: context
                                                          .read<MeetingStore>()
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
                                              .showReconnectingDialog(context);
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
    );
  }
}
