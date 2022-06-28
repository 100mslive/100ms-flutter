import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/embedded_button.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSMeetingPage extends StatefulWidget {
  final String roomId;
  final String user;
  final bool isAudioOn;
  final int? localPeerNetworkQuality;
  const HLSMeetingPage(
      {Key? key,
      required this.roomId,
      required this.user,
      required this.isAudioOn,
      required this.localPeerNetworkQuality})
      : super(key: key);

  @override
  State<HLSMeetingPage> createState() => _HLSMeetingPageState();
}

class _HLSMeetingPageState extends State<HLSMeetingPage> {
  @override
  void initState() {
    super.initState();
    initMeeting();
    checkAudioState();
    setInitValues();
  }

  void initMeeting() async {
    bool ans =
        await context.read<MeetingStore>().join(widget.user, widget.roomId);
    if (!ans) {
      UtilityComponents.showToastWithString("Unable to Join");
      Navigator.of(context).pop();
    }
  }

  void checkAudioState() async {
    if (!widget.isAudioOn) context.read<MeetingStore>().switchAudio();
  }

  void setInitValues() async {
    context.read<MeetingStore>().localPeerNetworkQuality =
        widget.localPeerNetworkQuality;
    context.read<MeetingStore>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Selector<MeetingStore, Tuple3<bool, bool, List<PeerTrackNode>>>(
            selector: (_, meetingStore) => Tuple3(
                meetingStore.localPeer != null,
                meetingStore.peerTracks.length > 0,
                meetingStore.peerTracks),
            builder: (_, data, __) {
              if (data.item1 && data.item2 && data.item3[0].track != null) {
                if (data.item3[0].track!.isMute) {
                  return Center(
                    child: Center(
                      child: CircleAvatar(
                          backgroundColor: defaultAvatarColor,
                          radius: 40,
                          child: Text(
                            Utilities.getAvatarTitle(context
                                .read<MeetingStore>()
                                .peerTracks[0]
                                .peer
                                .name),
                            style: GoogleFonts.inter(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  );
                }
                return HMSVideoView(
                  scaleType: ScaleType.SCALE_ASPECT_FILL,
                  track: data.item3[0].track!,
                  setMirror: true,
                  matchParent: false,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
            },
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          EmbeddedButton(
                            onTap: () async => {
                              await UtilityComponents.onBackPressed(context)
                            },
                            width: 45,
                            height: 45,
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
                              builder: (_, hasHlsStarted, __) {
                                if (hasHlsStarted)
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SvgPicture.asset(
                                              "assets/icons/live_stream.svg",
                                              color: errorColor,
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                          Text(
                                            "Live",
                                            style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: defaultColor,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "01:23",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: subHeadingColor,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w400),
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
                                  width: 45,
                                  height: 45,
                                  offColor: backgroundColor,
                                  onColor: hintColor,
                                  isActive: handRaised,
                                  child: SvgPicture.asset(
                                    "assets/icons/hand.svg",
                                    color: handRaised
                                        ? Colors.yellow
                                        : defaultColor,
                                    fit: BoxFit.scaleDown,
                                  ),
                                );
                              }),
                          SizedBox(
                            width: 15,
                          ),
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isNewMessageReceived,
                              builder: (_, isNewMessageReceived, __) {
                                return EmbeddedButton(
                                  onTap: () => {},
                                  width: 45,
                                  height: 45,
                                  offColor: hintColor,
                                  onColor: backgroundColor,
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
                            width: 15,
                          ),
                          EmbeddedButton(
                            onTap: () =>
                                {context.read<MeetingStore>().switchCamera()},
                            width: 45,
                            height: 45,
                            offColor: hintColor,
                            onColor: backgroundColor,
                            isActive: true,
                            child: SvgPicture.asset(
                              "assets/icons/camera.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (Provider.of<MeetingStore>(context).localPeer !=
                                null &&
                            (Provider.of<MeetingStore>(context)
                                    .localPeer
                                    ?.role
                                    .publishSettings
                                    ?.allowed
                                    .contains("audio") ??
                                false))
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isMicOn,
                              builder: (_, isMicOn, __) {
                                return EmbeddedButton(
                                  onTap: () => {
                                    context.read<MeetingStore>().switchAudio()
                                  },
                                  width: 45,
                                  height: 45,
                                  offColor: hintColor,
                                  onColor: backgroundColor,
                                  isActive: isMicOn,
                                  child: SvgPicture.asset(
                                    isMicOn
                                        ? "assets/icons/mic_state_on.svg"
                                        : "assets/icons/mic_state_off.svg",
                                    color: defaultColor,
                                    fit: BoxFit.scaleDown,
                                  ),
                                );
                              }),
                        if (Provider.of<MeetingStore>(context).localPeer !=
                                null &&
                            (Provider.of<MeetingStore>(context)
                                    .localPeer
                                    ?.role
                                    .publishSettings
                                    ?.allowed
                                    .contains("video") ??
                                false))
                          Selector<MeetingStore, Tuple2<bool, bool>>(
                              selector: (_, meetingStore) => Tuple2(
                                  meetingStore.isVideoOn,
                                  meetingStore.meetingMode ==
                                      MeetingMode.Audio),
                              builder: (_, data, __) {
                                return EmbeddedButton(
                                  onTap: () => {
                                    (data.item2)
                                        ? null
                                        : context
                                            .read<MeetingStore>()
                                            .switchVideo(),
                                  },
                                  width: 45,
                                  height: 45,
                                  offColor: hintColor,
                                  onColor: backgroundColor,
                                  isActive: data.item1,
                                  child: SvgPicture.asset(
                                    data.item1
                                        ? "assets/icons/cam_state_on.svg"
                                        : "assets/icons/cam_state_off.svg",
                                    color: defaultColor,
                                    fit: BoxFit.scaleDown,
                                  ),
                                );
                              }),
                        if (Provider.of<MeetingStore>(context).localPeer !=
                            null)
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.hasHlsStarted,
                              builder: (_, hasHlsStarted, __) {
                                if (hasHlsStarted) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          UtilityComponents.onEndStream(
                                              context);
                                        },
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: errorColor,
                                          child: SvgPicture.asset(
                                            "assets/icons/end.svg",
                                            color: defaultColor,
                                            height: 36,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "END STREAM",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
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
                                          isScrollControlled: true,
                                          backgroundColor: bottomSheetColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          context: context,
                                          builder: (ctx) =>
                                              ChangeNotifierProvider.value(
                                                  value: context
                                                      .read<MeetingStore>(),
                                                  child: HLSBottomSheet(
                                                      roomId: widget.roomId)),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.blue,
                                        child: SvgPicture.asset(
                                          "assets/icons/live.svg",
                                          color: defaultColor,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "GO LIVE",
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                );
                              }),
                        if (Provider.of<MeetingStore>(context).localPeer !=
                                null &&
                            (Provider.of<MeetingStore>(context)
                                    .localPeer
                                    ?.role
                                    .publishSettings
                                    ?.allowed
                                    .contains("screen") ??
                                false))
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isScreenShareOn,
                              builder: (_, data, __) {
                                return EmbeddedButton(
                                  onTap: () {
                                    MeetingStore meetingStore =
                                        Provider.of<MeetingStore>(context,
                                            listen: false);
                                    if (meetingStore.isScreenShareOn) {
                                      meetingStore.stopScreenShare();
                                    } else {
                                      meetingStore.startScreenShare();
                                    }
                                  },
                                  width: 45,
                                  height: 45,
                                  offColor: hintColor,
                                  onColor: backgroundColor,
                                  isActive: data,
                                  child: SvgPicture.asset(
                                    "assets/icons/screen_share.svg",
                                    color: defaultColor,
                                    fit: BoxFit.scaleDown,
                                  ),
                                );
                              }),
                        if (Provider.of<MeetingStore>(context).localPeer !=
                            null)
                          EmbeddedButton(
                            onTap: () => {},
                            width: 45,
                            height: 45,
                            offColor: hintColor,
                            onColor: backgroundColor,
                            isActive: true,
                            child: SvgPicture.asset(
                              "assets/icons/more.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
