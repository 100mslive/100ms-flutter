import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/audio_device_change_dialog.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_embedded_button.dart';
import 'package:hmssdk_flutter_example/common/widgets/stream_timer.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/viewer_settings_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_player.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerPage extends StatefulWidget {
  HLSViewerPage({
    Key? key,
  }) : super(key: key);
  @override
  State<HLSViewerPage> createState() => _HLSViewerPageState();
}

class _HLSViewerPageState extends State<HLSViewerPage> {
  String recordingState() {
    String _message = "";

    Map<String, bool> _recordingType =
        context.read<MeetingStore>().recordingType;

    if (_recordingType["hls"] ?? false) {
      _message += "HLS ";
    }
    if (_recordingType["server"] ?? false) {
      _message += "Server ";
    }
    if (_recordingType["browser"] ?? false) {
      _message += "Beam ";
    }
    _message += "Recording";
    return _message;
  }

  String streamingState() {
    String _message = "Live";
    Map<String, bool> _streamingType =
        context.read<MeetingStore>().streamingType;
    if (_streamingType["hls"] ?? false) {
      _message += " with HLS";
    } else if (_streamingType["rtmp"] ?? false) {
      _message += " with RTMP";
    }
    return _message;
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
                  return Scaffold(
                          resizeToAvoidBottomInset: false,
                          body: SafeArea(
                            child: Stack(
                              children: [
                                Selector<MeetingStore, bool>(
                                    selector: (_, meetingStore) =>
                                        meetingStore.hasHlsStarted,
                                    builder: (_, hasHlsStarted, __) {
                                      return (hasHlsStarted)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50.0),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  child: Center(
                                                    child: HLSPlayer(
                                                      ratio: Utilities
                                                          .getHLSPlayerDefaultRatio(
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size),
                                                    ),
                                                  )),
                                            )
                                          : Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: TitleText(
                                                      text:
                                                          "Waiting for HLS to start...",
                                                      textColor:
                                                          themeDefaultColor)),
                                            );
                                    }),
                                isPipActive
                                    ? Container()
                                    : Column(
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
                                                    HMSEmbeddedButton(
                                                      onTap: () async => {
                                                        await UtilityComponents
                                                            .onBackPressed(
                                                                context)
                                                      },
                                                      disabledBorderColor:
                                                          Color(0xffCC525F),
                                                      width: 40,
                                                      height: 40,
                                                      offColor:
                                                          Color(0xffCC525F),
                                                      onColor:
                                                          Color(0xffCC525F),
                                                      isActive: false,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/leave_hls.svg",
                                                        color: Colors.white,
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "leave_button",
                                                      ),
                                                    ),
                                                    SizedBox(
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
                                                              roomState.item2)
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
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (!roomState.item1 &&
                                                                            roomState.item2)
                                                                          Utilities.showToast(
                                                                              recordingState());
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
                                                                                      "assets/icons/clock.svg",
                                                                                      color: themeSubHeadingColor,
                                                                                      fit: BoxFit.scaleDown,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 6,
                                                                                    ),
                                                                                    Selector<MeetingStore, HMSRoom?>(
                                                                                        selector: (_, meetingStore) => meetingStore.hmsRoom,
                                                                                        builder: (_, hmsRoom, __) {
                                                                                          if (hmsRoom != null && hmsRoom.hmshlsStreamingState != null && hmsRoom.hmshlsStreamingState!.variants.length != 0 && hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt != null) {
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
                                                                                "assets/icons/watching.svg",
                                                                                color: themeSubHeadingColor,
                                                                                fit: BoxFit.scaleDown,
                                                                              ),
                                                                              SizedBox(
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
                                                          return SizedBox();
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  children: [
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
                                                                context:
                                                                    context,
                                                                builder: (ctx) => ChangeNotifierProvider.value(
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
                                                            child: SvgPicture
                                                                .asset(
                                                              isNewMessageReceived
                                                                  ? "assets/icons/message_badge_on.svg"
                                                                  : "assets/icons/message_badge_off.svg",
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              semanticsLabel:
                                                                  "chat_button",
                                                            ),
                                                          );
                                                        }),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    HMSEmbeddedButton(
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
                                                                        ViewerSettingsBottomSheet()))
                                                      },
                                                      width: 40,
                                                      height: 40,
                                                      offColor: themeHintColor,
                                                      onColor:
                                                          themeScreenBackgroundColor,
                                                      isActive: true,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/more.svg",
                                                        color:
                                                            themeDefaultColor,
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "more_button",
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
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
                                      return SizedBox();
                                    }),
                                Selector<MeetingStore, HMSTrackChangeRequest?>(
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
                                      return SizedBox();
                                    }),
                                Selector<MeetingStore, bool>(
                                    selector: (_, meetingStore) =>
                                        meetingStore.showAudioDeviceChangePopup,
                                    builder:
                                        (_, showAudioDeviceChangePopup, __) {
                                      if (showAudioDeviceChangePopup) {
                                        context
                                            .read<MeetingStore>()
                                            .showAudioDeviceChangePopup = false;
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
                                                          .read<MeetingStore>()
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
                                            .showReconnectingDialog(context);
                                      }
                                      return SizedBox();
                                    }),
                              ],
                            ),
                          ),
                        );
                });
          }),
    );
  }
}
