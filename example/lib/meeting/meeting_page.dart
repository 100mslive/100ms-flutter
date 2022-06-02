//Dart imports
import 'dart:io';

//Package imports
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/full_screen_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_audio_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_hero_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_video_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/title_bar.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/logs/custom_singleton_logger.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

// ignore: implementation_imports
import 'package:tuple/tuple.dart';

class MeetingPage extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;
  final bool isAudioOn;
  final int? localPeerNetworkQuality;

  const MeetingPage({
    Key? key,
    required this.roomId,
    required this.flow,
    required this.user,
    required this.isAudioOn,
    this.localPeerNetworkQuality = -1,
  }) : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CustomLogger logger = CustomLogger();
  int appBarIndex = 0;
  bool audioViewOn = false;
  bool videoPreviousState = false;
  bool isRecordingStarted = false;
  bool isBRB = false;
  final scrollController = DraggableScrollableController();
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initMeeting();
    checkAudioState();
    setInitValues();
    initAnimation();
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

  void initAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 5000),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void handleMenu(int value) async {
    final _meetingStore = context.read<MeetingStore>();
    switch (value) {
      case 1:
        _meetingStore.setActiveSpeakerMode();
        break;
      case 2:
        if (_meetingStore.meetingMode != MeetingMode.Audio) {
          _meetingStore.setMode(MeetingMode.Audio);
        } else {
          _meetingStore.setPlayBackAllowed(true);
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 3:
        if (_meetingStore.meetingMode != MeetingMode.Hero) {
          _meetingStore.setMode(MeetingMode.Hero);
        } else {
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 4:
        if (_meetingStore.meetingMode != MeetingMode.Single) {
          _meetingStore.setMode(MeetingMode.Single);
        } else {
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 5:
        _meetingStore.toggleScreenShare();
        break;
      case 6:
        if (_meetingStore.isVideoOn) _meetingStore.switchCamera();
        break;
      case 7:
        String name = await UtilityComponents.showInputDialog(
            context: context, placeholder: "Enter Name");
        if (name.isNotEmpty) {
          _meetingStore.changeName(name: name);
        }
        break;
      case 8:
        List<HMSRole> roles = await _meetingStore.getRoles();
        UtilityComponents.showRoleList(context, roles, _meetingStore);
        break;
      case 9:
        if (_meetingStore.isRecordingStarted) {
          _meetingStore.stopRtmpAndRecording();
          isRecordingStarted = false;
        } else {
          if (isRecordingStarted == false) {
            Map<String, String> data =
                await UtilityComponents.showRTMPInputDialog(
                    context: context,
                    placeholder: "Enter Comma separated RTMP Urls",
                    isRecordingEnabled: false);
            List<String>? urls;
            if (data["url"]!.isNotEmpty) {
              urls = data["url"]!.split(",");
            }
            if (data["toRecord"] == "true" || urls != null) {
              _meetingStore.startRtmpOrRecording(
                  meetingUrl: Constant.rtmpUrl,
                  toRecord: data["toRecord"] == "true" ? true : false,
                  rtmpUrls: urls);
              isRecordingStarted = true;
            }
          }
        }
        break;
      case 10:
        if (_meetingStore.hasHlsStarted) {
          _meetingStore.stopHLSStreaming();
        } else {
          String url = await UtilityComponents.showInputDialog(
              context: context,
              placeholder: "Enter HLS Url",
              prefilledValue: Constant.rtmpUrl);
          if (url.isNotEmpty) {
            _meetingStore.startHLSStreaming(url);
          }
        }
        break;
      case 11:
        _meetingStore.changeStatsVisible();
        break;
      case 12:
        UtilityComponents.onEndRoomPressed(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
        app: WillPopScope(
      child: ConnectivityWidgetWrapper(
          disableInteraction: true,
          offlineWidget: OfflineWidget(),
          child: Selector<MeetingStore, Tuple2<bool, bool>>(
            selector: (_, meetingStore) =>
                Tuple2(meetingStore.reconnecting, meetingStore.isRoomEnded),
            builder: (_, data, __) {
              if (data.item2) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  UtilityComponents.showToastWithString(
                      context.read<MeetingStore>().description);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              }
              return data.item1
                  ? OfflineWidget()
                  : Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: AppBar(
                        title: TitleBar(),
                        actions: [
                          Selector<MeetingStore, bool>(
                            selector: (_, meetingStore) =>
                                meetingStore.isRecordingStarted,
                            builder: (_, isRecordingStarted, __) {
                              return isRecordingStarted
                                  ? SvgPicture.asset(
                                      "assets/icons/record.svg",
                                      color: Colors.red,
                                    )
                                  : Container();
                            },
                          ),
                          IconButton(
                              iconSize: 24,
                              onPressed: () {
                                context.read<MeetingStore>().toggleSpeaker();
                              },
                              icon: Selector<MeetingStore, bool>(
                                selector: (_, meetingStore) =>
                                    meetingStore.isSpeakerOn,
                                builder: (_, isSpeakerOn, __) {
                                  return (isSpeakerOn)
                                      ? SvgPicture.asset(
                                          "assets/icons/speaker_state_on.svg",
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/speaker_state_off.svg",
                                        );
                                },
                              )),
                          dropDownMenu(),
                        ],
                      ),
                      body: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: Selector<
                                    MeetingStore,
                                    Tuple6<List<PeerTrackNode>, bool, int, int,
                                        MeetingMode, PeerTrackNode?>>(
                                selector: (_, meetingStore) => Tuple6(
                                    meetingStore.peerTracks,
                                    meetingStore.isHLSLink,
                                    meetingStore.peerTracks.length,
                                    meetingStore.screenShareCount,
                                    meetingStore.meetingMode,
                                    meetingStore.peerTracks.length > 0
                                        ? meetingStore.peerTracks[
                                            meetingStore.screenShareCount]
                                        : null),
                                builder: (_, data, __) {
                                  if (data.item2) {
                                    return Selector<MeetingStore, bool>(
                                        selector: (_, meetingStore) =>
                                            meetingStore.hasHlsStarted,
                                        builder: (_, hasHlsStarted, __) {
                                          return hasHlsStarted
                                              ? Center(
                                                  child: Container(
                                                    child: HLSViewer(
                                                        streamUrl: context
                                                            .read<
                                                                MeetingStore>()
                                                            .streamUrl),
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Text(
                                                          "Waiting for HLS to start...",
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color:
                                                                      iconColor,
                                                                  fontSize: 20),
                                                        ),
                                                      ),
                                                      RotationTransition(
                                                        child: Image.asset(
                                                            "assets/icons/hms_icon_loading.png"),
                                                        turns:
                                                            animationController,
                                                      )
                                                    ],
                                                  ),
                                                );
                                        });
                                  }
                                  if (data.item3 == 0) {
                                    return Center(
                                        child: RotationTransition(
                                      child: Image.asset(
                                          "assets/icons/hms_icon_loading.png"),
                                      turns: animationController,
                                    ));
                                  }
                                  Size size = MediaQuery.of(context).size;
                                  if (data.item5 == MeetingMode.Hero) {
                                    return gridHeroView(
                                        peerTracks: data.item1,
                                        itemCount: data.item3,
                                        screenShareCount: data.item4,
                                        context: context,
                                        size: size);
                                  }
                                  if (data.item5 == MeetingMode.Audio) {
                                    return gridAudioView(
                                        peerTracks:
                                            data.item1.sublist(data.item4),
                                        itemCount: data.item1
                                            .sublist(data.item4)
                                            .length,
                                        size: size);
                                  }
                                  if (data.item5 == MeetingMode.Single) {
                                    return fullScreenView(
                                        peerTracks: data.item1,
                                        itemCount: data.item3,
                                        screenShareCount: data.item4,
                                        context: context,
                                        size: size);
                                  }
                                  return gridVideoView(
                                      peerTracks: data.item1,
                                      itemCount: data.item3,
                                      screenShareCount: data.item4,
                                      context: context,
                                      size: size);
                                }),
                          ),
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isHLSLink,
                              builder: (_, isHlsRunning, __) {
                                return Positioned(
                                  bottom: 0,
                                  child: isHlsRunning
                                      ? hlsBottomBarWidget()
                                      : normalBottomBarWidget(),
                                );
                              }),
                          Selector<MeetingStore, HMSRoleChangeRequest?>(
                              selector: (_, meetingStore) =>
                                  meetingStore.roleChangeRequest,
                              builder: (_, roleChangeRequest, __) {
                                if (roleChangeRequest != null) {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    UtilityComponents.showRoleChangeDialog(
                                        roleChangeRequest, context);
                                  });
                                }
                                return Container();
                              }),
                          Selector<MeetingStore, HMSTrackChangeRequest?>(
                              selector: (_, meetingStore) =>
                                  meetingStore.hmsTrackChangeRequest,
                              builder: (_, hmsTrackChangeRequest, __) {
                                if (hmsTrackChangeRequest != null) {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    UtilityComponents.showTrackChangeDialog(
                                        hmsTrackChangeRequest, context);
                                  });
                                }
                                return Container();
                              }),
                        ],
                      ),
                    );
            },
          )),
      onWillPop: () async {
        bool ans = await UtilityComponents.onBackPressed(context) ?? false;
        return ans;
      },
    ));
  }

  Widget normalBottomBarWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (Provider.of<MeetingStore>(context).localPeer != null &&
              (Provider.of<MeetingStore>(context)
                      .localPeer
                      ?.role
                      .publishSettings
                      ?.allowed
                      .contains("video") ??
                  false))
            Selector<MeetingStore, Tuple2<bool, bool>>(
              selector: (_, meetingStore) => Tuple2(meetingStore.isVideoOn,
                  meetingStore.meetingMode == MeetingMode.Audio),
              builder: (_, data, __) {
                return Container(
                    padding: EdgeInsets.all(5),
                    child: IconButton(
                        tooltip: 'Video',
                        iconSize: 24,
                        onPressed: (data.item2)
                            ? null
                            : () {
                                context.read<MeetingStore>().switchVideo();
                              },
                        icon: data.item1
                            ? SvgPicture.asset(
                                "assets/icons/cam_state_on.svg",
                                color: iconColor,
                              )
                            : SvgPicture.asset(
                                "assets/icons/cam_state_off.svg",
                                color: data.item2 ? Colors.grey : iconColor,
                              )));
              },
            ),
          if (Provider.of<MeetingStore>(context).localPeer != null &&
              (Provider.of<MeetingStore>(context)
                      .localPeer
                      ?.role
                      .publishSettings
                      ?.allowed
                      .contains("audio") ??
                  false))
            Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isMicOn,
              builder: (_, isMicOn, __) {
                return Container(
                    padding: EdgeInsets.all(5),
                    child: IconButton(
                        tooltip: 'Audio',
                        iconSize: 24,
                        onPressed: () {
                          context.read<MeetingStore>().switchAudio();
                        },
                        icon: isMicOn
                            ? SvgPicture.asset(
                                "assets/icons/mic_state_on.svg",
                                color: iconColor,
                              )
                            : SvgPicture.asset(
                                "assets/icons/mic_state_off.svg",
                                color: iconColor,
                              )));
              },
            ),
          Selector<MeetingStore, bool>(
            selector: (_, meetingStore) => meetingStore.isRaisedHand,
            builder: (_, raisedHand, __) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: IconButton(
                      tooltip: 'RaiseHand',
                      iconSize: 20,
                      onPressed: () {
                        context.read<MeetingStore>().changeMetadata();
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/hand.svg",
                        color: raisedHand ? Colors.yellow : iconColor,
                      )));
            },
          ),
          Selector<MeetingStore, bool>(
            selector: (_, meetingStore) => meetingStore.isBRB,
            builder: (_, isBRB, __) {
              return Container(
                  padding: EdgeInsets.all(5),
                  child: IconButton(
                      tooltip: 'BRB',
                      iconSize: 20,
                      onPressed: () {
                        context.read<MeetingStore>().changeMetadataBRB();
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/brb.svg",
                        color: isBRB ? Colors.red : iconColor,
                      )));
            },
          ),
          Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isNewMessageReceived,
              builder: (_, isNewMessageReceived, __) {
                return Container(
                  padding: EdgeInsets.all(5),
                  child: IconButton(
                      tooltip: 'Chat',
                      iconSize: 24,
                      onPressed: () {
                        chatMessages(context);
                        context.read<MeetingStore>().setNewMessageFalse();
                      },
                      icon: isNewMessageReceived
                          ? SvgPicture.asset(
                              "assets/icons/message_badge_on.svg",
                              color: iconColor,
                            )
                          : SvgPicture.asset(
                              "assets/icons/message_badge_off.svg",
                              color: iconColor,
                            )),
                );
              }),
          Container(
            padding: EdgeInsets.all(5),
            child: IconButton(
                color: Colors.white,
                tooltip: 'Leave Or End',
                iconSize: 24,
                onPressed: () async {
                  await UtilityComponents.onBackPressed(context);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: SvgPicture.asset("assets/icons/leave.svg"),
                )),
          ),
        ],
      ),
    );
  }

  Widget hlsBottomBarWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Selector<MeetingStore, bool>(
            selector: (_, meetingStore) => meetingStore.isRaisedHand,
            builder: (_, raisedHand, __) {
              return Container(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    tooltip: 'RaiseHand',
                    iconSize: 20,
                    onPressed: () {
                      context.read<MeetingStore>().changeMetadata();
                      UtilityComponents.showToastWithString(
                          !raisedHand ? "Raised Hand ON" : "Raised Hand OFF");
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/hand.svg",
                      color: raisedHand ? Colors.yellow : iconColor,
                    ),
                  ));
            },
          ),
          Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isNewMessageReceived,
              builder: (_, isNewMessageReceived, __) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                      tooltip: 'Chat',
                      iconSize: 24,
                      onPressed: () {
                        chatMessages(context);
                        context.read<MeetingStore>().setNewMessageFalse();
                      },
                      icon: isNewMessageReceived
                          ? SvgPicture.asset(
                              "assets/icons/message_badge_on.svg",
                              color: iconColor,
                            )
                          : SvgPicture.asset(
                              "assets/icons/message_badge_off.svg",
                              color: iconColor,
                            )),
                );
              }),
          Container(
            padding: EdgeInsets.all(8),
            child: IconButton(
                color: Colors.white,
                tooltip: 'Leave Or End',
                iconSize: 24,
                onPressed: () async {
                  await UtilityComponents.onBackPressed(context);
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: SvgPicture.asset("assets/icons/leave.svg"),
                )),
          ),
        ],
      ),
    );
  }

  Widget dropDownMenu() {
    return PopupMenuButton(
      icon: SvgPicture.asset("assets/icons/settings.svg"),
      itemBuilder: (context) {
        final meetingStore = context.read<MeetingStore>();
        return [
          // PopupMenuItem(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Send Logs",
          //         style: GoogleFonts.inter(color:iconColor,),
          //       ),
          //       SvgPicture.asset("assets/icons/bug.svg",color:iconColor,),
          //     ],
          //   ),
          //   value: 1,
          // ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Active Speaker Mode",
                      style: GoogleFonts.inter(
                        color: meetingStore.isActiveSpeakerMode
                            ? Colors.blue
                            : iconColor,
                      )),
                  SvgPicture.asset(
                    "assets/icons/participants.svg",
                    color: meetingStore.isActiveSpeakerMode
                        ? Colors.blue
                        : iconColor,
                  ),
                ]),
            value: 1,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meetingStore.meetingMode == MeetingMode.Audio
                        ? "Video View"
                        : "Audio View",
                    style: GoogleFonts.inter(
                      color: iconColor,
                    ),
                  ),
                  SvgPicture.asset(
                    meetingStore.meetingMode == MeetingMode.Audio
                        ? 'assets/icons/cam_state_on.svg'
                        : 'assets/icons/mic_state_on.svg',
                    color: iconColor,
                    height: 24.0,
                    width: 24.0,
                  ),
                ]),
            value: 2,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hero Mode",
                      style: GoogleFonts.inter(
                        color: meetingStore.meetingMode == MeetingMode.Hero
                            ? Colors.blue
                            : iconColor,
                      )),
                  SvgPicture.asset(
                    "assets/icons/participants.svg",
                    color: meetingStore.meetingMode == MeetingMode.Hero
                        ? Colors.blue
                        : iconColor,
                  ),
                ]),
            value: 3,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Single Tile Mode",
                      style: GoogleFonts.inter(
                        color: meetingStore.meetingMode == MeetingMode.Single
                            ? Colors.blue
                            : iconColor,
                      )),
                  SvgPicture.asset(
                    "assets/icons/single_tile.svg",
                    color: meetingStore.meetingMode == MeetingMode.Single
                        ? Colors.blue
                        : iconColor,
                  ),
                ]),
            value: 4,
          ),
          if ((meetingStore.localPeer != null) &&
              meetingStore.localPeer!.role.publishSettings!.allowed
                  .contains("screen") &&
              Platform.isAndroid)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Screen share",
                      style: GoogleFonts.inter(
                          color: meetingStore.isScreenShareOn
                              ? Colors.blue
                              : iconColor),
                    ),
                    SvgPicture.asset(
                      "assets/icons/screen_share.svg",
                      color: meetingStore.isScreenShareOn
                          ? Colors.blue
                          : iconColor,
                    ),
                  ]),
              value: 5,
            ),
          if (!(meetingStore.localPeer?.role.name.contains("hls-") ?? true))
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Toggle Camera  ",
                      style: GoogleFonts.inter(
                        color: iconColor,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/camera.svg",
                      color: iconColor,
                    ),
                  ]),
              value: 6,
            ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Name",
                    style: GoogleFonts.inter(
                      color: iconColor,
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/icons/pencil.svg",
                    color: iconColor,
                  ),
                ]),
            value: 7,
          ),
          if (meetingStore.localPeer?.role.permissions.changeRole ?? false)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mute",
                      style: GoogleFonts.inter(
                        color: iconColor,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/mic_state_off.svg",
                      color: iconColor,
                    ),
                  ]),
              value: 8,
            ),
          if (!(meetingStore.localPeer?.role.name.contains("hls-") ?? true))
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        meetingStore.isRecordingStarted
                            ? "Stop RTMP/Rec"
                            : "Start RTMP/Rec",
                        style: GoogleFonts.inter(
                          color: meetingStore.isRecordingStarted
                              ? Colors.blue
                              : iconColor,
                        )),
                    SvgPicture.asset(
                      "assets/icons/record.svg",
                      color: meetingStore.isRecordingStarted
                          ? Colors.red
                          : iconColor,
                    ),
                  ]),
              value: 9,
            ),
          if (!(meetingStore.localPeer?.role.name.contains("hls-") ?? true))
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meetingStore.hasHlsStarted ? "Stop HLS" : "Start HLS",
                      style: GoogleFonts.inter(
                        color: meetingStore.hasHlsStarted
                            ? Colors.blue
                            : iconColor,
                      ),
                    ),
                    SvgPicture.asset("assets/icons/hls.svg",
                        color: meetingStore.hasHlsStarted
                            ? Colors.blue
                            : iconColor),
                  ]),
              value: 10,
            ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stats",
                    style: GoogleFonts.inter(
                        color: meetingStore.isStatsVisible
                            ? Colors.blue
                            : iconColor),
                  ),
                  SvgPicture.asset("assets/icons/stats.svg",
                      color: meetingStore.isStatsVisible
                          ? Colors.blue
                          : iconColor),
                ]),
            value: 11,
          ),
          if (meetingStore.localPeer!.role.permissions.endRoom!)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Room",
                      style: GoogleFonts.inter(
                        color: iconColor,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/icons/end_room.svg",
                      color: iconColor,
                    ),
                  ]),
              value: 12,
            ),
        ];
      },
      onSelected: handleMenu,
    );
  }
}
