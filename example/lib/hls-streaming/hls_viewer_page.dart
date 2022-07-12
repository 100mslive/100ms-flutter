import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/embedded_button.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/stream_timer.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_message.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_viewer_settings.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerPage extends StatefulWidget {
  final String meetingLink;
  final String user;
  final int? localPeerNetworkQuality;
  const HLSViewerPage(
      {Key? key,
      required this.meetingLink,
      required this.user,
      required this.localPeerNetworkQuality})
      : super(key: key);
  @override
  State<HLSViewerPage> createState() => _HLSViewerPageState();
}

class _HLSViewerPageState extends State<HLSViewerPage> {
  @override
  void initState() {
    super.initState();
    initMeeting();
    setInitValues();
  }

  void initMeeting() async {
    bool ans = await context
        .read<MeetingStore>()
        .join(widget.user, widget.meetingLink);
    if (!ans) {
      UtilityComponents.showToastWithString("Unable to Join");
      Navigator.of(context).pop();
    }
  }

  void setInitValues() async {
    context.read<MeetingStore>().localPeerNetworkQuality =
        widget.localPeerNetworkQuality;
    context.read<MeetingStore>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: WillPopScope(
        onWillPop: () async {
          bool ans = await UtilityComponents.onBackPressed(context) ?? false;
          return ans;
        },
        child: ConnectivityWidgetWrapper(
          disableInteraction: true,
          offlineWidget: OfflineWidget(),
          child: Selector<MeetingStore, Tuple2<bool, bool>>(
              selector: (_, meetingStore) =>
                  Tuple2(meetingStore.reconnecting, meetingStore.isRoomEnded),
              builder: (_, data, __) {
                if (data.item2) {
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    Utilities.showToast(
                        context.read<MeetingStore>().description);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                }
                return data.item1
                    ? OfflineWidget()
                    : Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: SafeArea(
                          child: Stack(
                            children: [
                              Selector<MeetingStore, bool>(
                                  selector: (_, meetingStore) =>
                                      meetingStore.hasHlsStarted,
                                  builder: (_, hasHlsStarted, __) {
                                    return hasHlsStarted
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.735,
                                            child: Center(
                                              child: HLSPlayer(
                                                  streamUrl: context
                                                      .read<MeetingStore>()
                                                      .streamUrl),
                                            ),
                                          )
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.735,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Text(
                                                      "Waiting for HLS to start...",
                                                      style: GoogleFonts.inter(
                                                          color: iconColor,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                  }),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5, bottom: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            EmbeddedButton(
                                              onTap: () async => {
                                                await UtilityComponents
                                                    .onBackPressed(context)
                                              },
                                              disabledBorderColor:
                                                              Color(0xffCC525F),
                                              width: 40,
                                              height: 40,
                                              offColor: Color(0xffCC525F),
                                              onColor: Color(0xffCC525F),
                                              isActive: false,
                                              child: SvgPicture.asset(
                                                "assets/icons/leave_hls.svg",
                                                color: Colors.white,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Selector<MeetingStore, bool>(
                                                selector: (_, meetingStore) =>
                                                    meetingStore.hasHlsStarted,
                                                builder:
                                                    (_, hasHlsStarted, __) {
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
                                                              padding:
                                                                  const EdgeInsets
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
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 16,
                                                                  color:
                                                                      defaultColor,
                                                                  letterSpacing:
                                                                      0.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
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
                                                                      subHeadingColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Selector<
                                                                        MeetingStore,
                                                                        HMSRoom?>(
                                                                    selector: (_,
                                                                            meetingStore) =>
                                                                        meetingStore
                                                                            .hmsRoom,
                                                                    builder: (_,
                                                                        hmsRoom,
                                                                        __) {
                                                                      if (hmsRoom != null &&
                                                                          hmsRoom.hmshlsStreamingState !=
                                                                              null &&
                                                                          hmsRoom.hmshlsStreamingState!.variants.length !=
                                                                              0 &&
                                                                          hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt !=
                                                                              null) {
                                                                        return StreamTimer(
                                                                            startedAt:
                                                                                hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt!);
                                                                      }
                                                                      return HLSSubtitleText(
                                                                        text:
                                                                            "00:00",
                                                                        textColor:
                                                                            subHeadingColor,
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
                                                                      subHeadingColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                Selector<
                                                                        MeetingStore,
                                                                        int>(
                                                                    selector: (_,
                                                                            meetingStore) =>
                                                                        meetingStore
                                                                            .peers
                                                                            .length,
                                                                    builder: (_,
                                                                        length,
                                                                        __) {
                                                                      return HLSSubtitleText(
                                                                          text: length
                                                                              .toString(),
                                                                          textColor:
                                                                              subHeadingColor);
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
                                                selector: (_, meetingStore) =>
                                                    meetingStore.isRaisedHand,
                                                builder: (_, handRaised, __) {
                                                  return EmbeddedButton(
                                                    onTap: () => {
                                                      context
                                                          .read<MeetingStore>()
                                                          .changeMetadata()
                                                    },
                                                    width: 40,
                                                    height: 40,
                                                    disabledBorderColor:
                                                        borderColor,
                                                    offColor:
                                                        screenBackgroundColor,
                                                    onColor: hintColor,
                                                    isActive: handRaised,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/hand_outline.svg",
                                                      color: defaultColor,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  );
                                                }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Selector<MeetingStore, bool>(
                                                selector: (_, meetingStore) =>
                                                    meetingStore
                                                        .isNewMessageReceived,
                                                builder: (_,
                                                    isNewMessageReceived, __) {
                                                  return EmbeddedButton(
                                                    onTap: () => {
                                                      context
                                                          .read<MeetingStore>()
                                                          .setNewMessageFalse(),
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            bottomSheetColor,
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
                                                                    HLSMessage()),
                                                      )
                                                    },
                                                    width: 40,
                                                    height: 40,
                                                    offColor: hintColor,
                                                    onColor:
                                                        screenBackgroundColor,
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      isNewMessageReceived
                                                          ? "assets/icons/message_badge_on.svg"
                                                          : "assets/icons/message_badge_off.svg",
                                                      color: defaultColor,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  );
                                                }),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            EmbeddedButton(
                                              onTap: () => {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        bottomSheetColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    context: context,
                                                    builder: (ctx) =>
                                                        ChangeNotifierProvider.value(
                                                            value: context.read<
                                                                MeetingStore>(),
                                                            child:
                                                                HLSViewerSettings()))
                                              },
                                              width: 40,
                                              height: 40,
                                              offColor: hintColor,
                                              onColor: screenBackgroundColor,
                                              isActive: true,
                                              child: SvgPicture.asset(
                                                "assets/icons/more.svg",
                                                color: defaultColor,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
