//Dart imports
import 'dart:io';

//Package imports
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/full_screen_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_audio_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_hero_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/grid_video_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/title_bar.dart';
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
import 'meeting_participants_list.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initMeeting();
    checkAudioState();
    setInitValues();
  }

  void initMeeting() async {
    bool ans =
        await context.read<MeetingStore>().join(widget.user, widget.roomId);
    if (!ans) {
      UtilityComponents.showSnackBarWithString("Unable to Join", context);
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
  void dispose() {
    super.dispose();
  }

  void handleMenu(int value) async {
    final _meetingStore = context.read<MeetingStore>();
    switch (value) {
      case 1:
        // StaticLogger.logger?.d(
        //     "\n----------------------------Sending Logs-----------------\n");
        // StaticLogger.logger?.close();
        // ShareExtend.share(CustomLogger.file?.path ?? '', 'file');
        // logger.getCustomLogger();
        UtilityComponents.showSnackBarWithString("Coming Soon...", context);
        break;

      case 2:
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

      case 3:
        if (_meetingStore.isVideoOn) _meetingStore.switchCamera();

        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: context.read<MeetingStore>(), child: ParticipantsList()),
          ),
        );
        break;
      case 5:
        if (_meetingStore.meetingMode != MeetingMode.Audio) {
          _meetingStore.setMode(MeetingMode.Audio);
        } else {
          _meetingStore.setPlayBackAllowed(true);
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 6:
        _meetingStore.setActiveSpeakerMode();
        break;
      case 7:
        if (_meetingStore.meetingMode != MeetingMode.Hero) {
          _meetingStore.setMode(MeetingMode.Hero);
        } else {
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 8:
        if (_meetingStore.meetingMode != MeetingMode.Single) {
          _meetingStore.setMode(MeetingMode.Single);
        } else {
          _meetingStore.setMode(MeetingMode.Video);
        }
        break;
      case 9:
        String name = await UtilityComponents.showInputDialog(
            context: context, placeholder: "Enter Name");
        if (name.isNotEmpty) {
          _meetingStore.changeName(name: name);
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
        List<HMSRole> roles = await _meetingStore.getRoles();
        List<HMSRole> selectedRoles =
            await UtilityComponents.showRoleList(context, roles);
        if (selectedRoles.isNotEmpty)
          _meetingStore.changeTrackStateForRole(true, selectedRoles);
        break;
      case 12:
        _meetingStore.changeTrackStateForRole(true, null);
        break;
      case 13:
        _meetingStore.changeMetadataBRB();
        // raisedHand = false;
        isBRB = !isBRB;
        break;
      case 14:
        _meetingStore.changeStatsVisible();
        break;
      case 15:
        _meetingStore.toggleScreenShare();
        break;
      case 16:
        _meetingStore.endRoom(false, "Room Ended From Flutter");
        if (_meetingStore.isRoomEnded) {
          Navigator.pop(context);
        }
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
                  UtilityComponents.showSnackBarWithString(
                      context.read<MeetingStore>().description, context);
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
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.red.shade600)),
                                      child: Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 15,
                                      ),
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
                                  return Icon(isSpeakerOn
                                      ? Icons.volume_up
                                      : Icons.volume_off);
                                },
                              )),
                          dropDownMenu(),
                        ],
                      ),
                      body: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.81,
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
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                      CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      )
                                                    ],
                                                  ),
                                                );
                                        });
                                  }
                                  if (data.item3 == 0) {
                                    return Center(
                                        child: Text(
                                            'Waiting for others to join!'));
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
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Video',
                        iconSize: 24,
                        onPressed: (data.item2)
                            ? null
                            : () {
                                context.read<MeetingStore>().switchVideo();
                              },
                        icon: Icon(
                          data.item1 ? Icons.videocam : Icons.videocam_off,
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
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Audio',
                        iconSize: 24,
                        onPressed: () {
                          context.read<MeetingStore>().switchAudio();
                        },
                        icon: Icon(
                          isMicOn ? Icons.mic : Icons.mic_off,
                        )));
              },
            ),
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
                      UtilityComponents.showSnackBarWithString(
                          !raisedHand ? "Raised Hand ON" : "Raised Hand OFF",
                          context);
                    },
                    icon: Image.asset(
                      'assets/icons/raise_hand.png',
                      color: raisedHand ? Colors.amber.shade300 : Colors.white,
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
                    icon: Stack(children: [
                      Icon(Icons.chat_bubble),
                      if (isNewMessageReceived)
                        Positioned(
                          top: -1,
                          right: -1,
                          child: new Icon(Icons.brightness_1,
                              size: 14.0, color: Colors.red),
                        )
                    ]),
                  ),
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
                  child: Icon(Icons.call_end, color: Colors.white),
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
                      UtilityComponents.showSnackBarWithString(
                          !raisedHand ? "Raised Hand ON" : "Raised Hand OFF",
                          context);
                    },
                    icon: Image.asset(
                      'assets/icons/raise_hand.png',
                      color: raisedHand ? Colors.amber.shade300 : Colors.white,
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
                    icon: Stack(children: [
                      Icon(Icons.chat_bubble),
                      if (isNewMessageReceived)
                        Positioned(
                          top: -1,
                          right: -1,
                          child: new Icon(Icons.brightness_1,
                              size: 14.0, color: Colors.red),
                        )
                    ]),
                  ),
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
                  child: Icon(Icons.call_end, color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  Widget dropDownMenu() {
    return PopupMenuButton(
      icon: Icon(CupertinoIcons.gear),
      itemBuilder: (context) {
        final meetingStore = context.read<MeetingStore>();
        return [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Send Logs"),
                Icon(Icons.bug_report),
              ],
            ),
            value: 1,
          ),
          if (!(meetingStore.localPeer?.role.name.contains("hls-") ?? true))
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        meetingStore.isRecordingStarted
                            ? "Recording "
                            : "Record",
                        style: TextStyle(
                          color: meetingStore.isRecordingStarted
                              ? Colors.blue
                              : Colors.white,
                        )),
                    Icon(
                      Icons.circle,
                      color: meetingStore.isRecordingStarted
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ]),
              value: 2,
            ),
          if (!(meetingStore.localPeer?.role.name.contains("hls-") ?? true))
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Toggle Camera  ",
                    ),
                    Icon(Icons.switch_camera),
                  ]),
              value: 3,
            ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Participants  ",
                  ),
                  Icon(CupertinoIcons.person_3_fill),
                ]),
            value: 4,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meetingStore.meetingMode == MeetingMode.Audio
                        ? "Video View"
                        : "Audio View",
                  ),
                  Image.asset(
                    meetingStore.meetingMode == MeetingMode.Audio
                        ? 'assets/icons/video.png'
                        : 'assets/icons/audio.png',
                    color: Colors.white,
                    height: 24.0,
                    width: 24.0,
                  ),
                ]),
            value: 5,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Active Speaker Mode",
                      style: TextStyle(
                        color: meetingStore.isActiveSpeakerMode
                            ? Colors.blue
                            : Colors.white,
                      )),
                  Icon(
                    CupertinoIcons.person_3_fill,
                    color: meetingStore.isActiveSpeakerMode
                        ? Colors.blue
                        : Colors.white,
                  ),
                ]),
            value: 6,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hero Mode",
                      style: TextStyle(
                        color: meetingStore.meetingMode == MeetingMode.Hero
                            ? Colors.blue
                            : Colors.white,
                      )),
                  Icon(
                    CupertinoIcons.person_3_fill,
                    color: meetingStore.meetingMode == MeetingMode.Hero
                        ? Colors.blue
                        : Colors.white,
                  ),
                ]),
            value: 7,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Single Tile Mode",
                      style: TextStyle(
                        color: meetingStore.meetingMode == MeetingMode.Single
                            ? Colors.blue
                            : Colors.white,
                      )),
                  Icon(
                    CupertinoIcons.person,
                    color: meetingStore.meetingMode == MeetingMode.Single
                        ? Colors.blue
                        : Colors.white,
                  ),
                ]),
            value: 8,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Name",
                  ),
                  Icon(Icons.create_rounded),
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
                      style: TextStyle(
                        color: meetingStore.hasHlsStarted
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                    Icon(Icons.stream,
                        color: meetingStore.hasHlsStarted
                            ? Colors.blue
                            : Colors.white),
                  ]),
              value: 10,
            ),
          if (meetingStore.localPeer?.role.permissions.changeRole ?? false)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mute Roles",
                    ),
                    Icon(Icons.mic_off_sharp),
                  ]),
              value: 11,
            ),
          if (meetingStore.localPeer?.role.permissions.changeRole ?? false)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mute All",
                    ),
                    Icon(Icons.mic_off),
                  ]),
              value: 12,
            ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BRB",
                    style: TextStyle(
                        color: meetingStore.isBRB ? Colors.blue : Colors.white),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: meetingStore.isBRB
                                ? Colors.blue
                                : Colors.white)),
                    child: Text(
                      "BRB",
                      style: TextStyle(
                          color:
                              meetingStore.isBRB ? Colors.blue : Colors.white),
                    ),
                  ),
                ]),
            value: 13,
          ),
          PopupMenuItem(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stats",
                    style: TextStyle(
                        color: meetingStore.isStatsVisible
                            ? Colors.blue
                            : Colors.white),
                  ),
                  Icon(Icons.bar_chart_outlined,
                      color: meetingStore.isStatsVisible
                          ? Colors.blue
                          : Colors.white),
                ]),
            value: 14,
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
                      style: TextStyle(
                          color: meetingStore.isScreenShareOn
                              ? Colors.blue
                              : Colors.white),
                    ),
                    Icon(
                      Icons.screen_share,
                      color: meetingStore.isScreenShareOn
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ]),
              value: 15,
            ),
          if (meetingStore.localPeer!.role.permissions.endRoom!)
            PopupMenuItem(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Room",
                    ),
                    Icon(Icons.cancel_schedule_send),
                  ]),
              value: 16,
            ),
        ];
      },
      onSelected: handleMenu,
    );
  }
}
