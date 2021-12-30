import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/leave_or_end_meeting.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/logs/custom_singleton_logger.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'meeting_participants_list.dart';
import '../logs/static_logger.dart';

class MeetingPage extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;

  const MeetingPage(
      {Key? key, required this.roomId, required this.flow, required this.user})
      : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> with WidgetsBindingObserver {
  late MeetingStore _meetingStore;
  late ReactionDisposer _roleChangerequestDisposer,
      _hmsExceptionDisposer,
      _trackChangerequestDisposer,
      _reconnectingDisposer;
  late ReactionDisposer _errorDisposer,
      _recordingDisposer,
      _reconnectedDisposer,
      _roomEndedDisposer;
  CustomLogger logger = CustomLogger();
  int appBarIndex = 0;
  bool raisedHand = false;
  bool audioViewOn = false;
  int countOfVideoOnBetweenTwo = 1;
  bool videoPreviousState = false;
  late PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _meetingStore = context.read<MeetingStore>();
    MeetingController meetingController = MeetingController(
        roomUrl: widget.roomId, flow: widget.flow, user: widget.user);
    _meetingStore.meetingController = meetingController;
    allListeners();
    initMeeting();
    checkButtons();
  }

  void allListeners() {
    _roleChangerequestDisposer = reaction(
        (_) => _meetingStore.roleChangeRequest,
        (event) => {
              if ((event as HMSRoleChangeRequest).suggestedBy !=
                  _meetingStore.localPeer)
                UtilityComponents.showRoleChangeDialog(event, context)
            });
    _trackChangerequestDisposer = reaction(
        (_) => _meetingStore.hmsTrackChangeRequest,
        (event) => {UtilityComponents.showTrackChangeDialog(event, context)});
    _errorDisposer = reaction(
        (_) => _meetingStore.error,
        (event) => {
              UtilityComponents.showSnackBarWithString(
                  (event as HMSException).description, context)
            });
    _recordingDisposer = reaction(
        (_) => _meetingStore.isRecordingStarted,
        (event) => {
              UtilityComponents.showSnackBarWithString(
                  event == true ? "Recording Started" : "Recording Stopped",
                  context)
            });
    _reconnectedDisposer = reaction(
        (_) => _meetingStore.reconnected,
        (event) => {
              if ((event as bool) == true)
                UtilityComponents.showSnackBarWithString(
                    "reconnected", context),
              _meetingStore.reconnected = false
            });
    _roomEndedDisposer = reaction(
        (_) => _meetingStore.isRoomEnded,
        (event) => {
              if ((event as bool) == true)
                {
                  Navigator.of(context).pop(),
                  UtilityComponents.showSnackBarWithString(
                      "Meeting Ended", context),
                },
              _meetingStore.isRoomEnded = false,
            });
    _reconnectingDisposer = reaction(
        (_) => _meetingStore.reconnecting,
        (event) => {
              if ((event as bool) == true)
                UtilityComponents.showSnackBarWithString(
                    "reconnecting", context),
            });

    _hmsExceptionDisposer = reaction(
        (_) => _meetingStore.hmsException,
        (event) => {
              if ((event as HMSException?) != null)
                UtilityComponents.showSnackBarWithString(
                    event?.description, context),
            });
  }

  void initMeeting() async {
    bool ans = await _meetingStore.joinMeeting();
    if (!ans) {
      UtilityComponents.showSnackBarWithString("Unable to Join", context);
      Navigator.of(context).pop();
    }
    _meetingStore.startListen();
  }

  void checkButtons() async {
    _meetingStore.isVideoOn =
        !(await _meetingStore.meetingController.isVideoMute(null));
    _meetingStore.isMicOn =
        !(await _meetingStore.meetingController.isAudioMute(null));
    print("${_meetingStore.isMicOn} isMicOn");
  }

  @override
  void dispose() {
    disposeAllListeners();
    super.dispose();
  }

  void disposeAllListeners() {
    _roleChangerequestDisposer.reaction.dispose();
    _errorDisposer.reaction.dispose();
    _trackChangerequestDisposer.reaction.dispose();
    _recordingDisposer.reaction.dispose();
    _roomEndedDisposer.reaction.dispose();
    _reconnectedDisposer.reaction.dispose();
    _reconnectingDisposer.reaction.dispose();
    _hmsExceptionDisposer.reaction.dispose();
  }

  void handleMenu(int value) async {
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
        } else {
          print("${Constant.meetingUrl} meetingUrl");
          _meetingStore.startRtmpOrRecording(Constant.meetingUrl, true, null);
        }
        break;

      case 3:
        if (_meetingStore.isVideoOn) _meetingStore.toggleCamera();

        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ParticipantsList(
              meetingStore: _meetingStore,
            ),
          ),
        );
        break;
      case 5:
        audioViewOn = !audioViewOn;
        if (audioViewOn) {
          countOfVideoOnBetweenTwo = 0;
          _meetingStore.trackStatus.forEach((key, value) {
            _meetingStore.trackStatus[key] = HMSTrackUpdate.trackMuted;
          });
          videoPreviousState = _meetingStore.isVideoOn;
          _meetingStore.isVideoOn = false;
          _meetingStore.setPlayBackAllowed(false);
        } else {
          _meetingStore.peerTracks.forEach((element) {
            _meetingStore.trackStatus[element.peerId] =
                element.track?.isMute ?? false
                    ? HMSTrackUpdate.trackMuted
                    : HMSTrackUpdate.trackUnMuted;
          });
          _meetingStore.setPlayBackAllowed(true);
          if (countOfVideoOnBetweenTwo == 0) {
            _meetingStore.isVideoOn = videoPreviousState;
          } else
            _meetingStore.isVideoOn =
                !(_meetingStore.localTrack?.isMute ?? true);
          print(
              "${_meetingStore.isVideoOn} ISVIDEOON ${_meetingStore.localTrack == null}");
        }
        setState(() {});
        break;
      case 6:
        // if(!_meetingStore.isActiveSpeakerMode){
        //     _meetingStore.activeSpeakerPeerTracksStore = _meetingStore.peerTracks;
        //     _meetingStore.isActiveSpeakerMode = true;
        //     _pageController.animateToPage(0,duration: Duration(seconds: 1),curve: Curves.decelerate);
        //     setState(() {});
        //     UtilityComponents.showSnackBarWithString(
        //           "Active Speaker Mode", context);
        // }
        UtilityComponents.showSnackBarWithString("Coming Soon...", context);
        break;
      case 7:
        // if (_meetingStore.isActiveSpeakerMode) {
        //   _meetingStore.isActiveSpeakerMode = false;
        //   setState(() {});
        //   UtilityComponents.showSnackBarWithString(
        //       "Switched to Hero Mode", context);
        // }
        UtilityComponents.showSnackBarWithString("Coming Soon...", context);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    // final double itemHeightWithSs =
    //     (size.height - kToolbarHeight - kBottomNavigationBarHeight) /
    //         (orientation == Orientation.landscape ? 2.5 : 3);
    // final double itemHeightWithoutSs =
    //     (size.height - kToolbarHeight - kBottomNavigationBarHeight) /
    //         (orientation == Orientation.landscape ? 2.5 : 2.8);

    final double itemHeightWithSs =
        (size.height - kToolbarHeight - kBottomNavigationBarHeight) / 2;
    final double itemHeightWithoutSs =
        (size.height - kToolbarHeight - kBottomNavigationBarHeight) / 2.3;

    final double itemWidth = (size.width - 12) / 2;
    // itemWidth / itemHeightWithSs;
    //final aspectRatio = itemWidth / itemHeight;
    //print(aspectRatio.toString() + "AspectRatio");
    return ConnectivityAppWrapper(
        app: WillPopScope(
      child: ConnectivityWidgetWrapper(
          disableInteraction: true,
          offlineWidget: OfflineWidget(),
          child: Observer(builder: (_) {
            return _meetingStore.reconnecting
                ? OfflineWidget()
                : Scaffold(
                    appBar: AppBar(
                      title: Text(widget.roomId),
                      actions: [
                        Observer(
                          builder: (_) => IconButton(
                            iconSize: 32,
                            onPressed: () {
                              _meetingStore.toggleSpeaker();
                            },
                            icon: Icon(_meetingStore.isSpeakerOn
                                ? Icons.volume_up
                                : Icons.volume_off),
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(CupertinoIcons.gear),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Send Logs",
                                      style: TextStyle(color: Colors.blue)),
                                  Icon(Icons.bug_report, color: Colors.blue),
                                ],
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Observer(
                                  builder: (_) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                _meetingStore.isRecordingStarted
                                                    ? "Recording "
                                                    : "Record",
                                                style: TextStyle(
                                                  color: _meetingStore
                                                          .isRecordingStarted
                                                      ? Colors.red
                                                      : Colors.blue,
                                                )),
                                            Icon(
                                              Icons.circle,
                                              color: _meetingStore
                                                      .isRecordingStarted
                                                  ? Colors.red
                                                  : Colors.blue,
                                            ),
                                          ])),
                              value: 2,
                            ),
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Toggle Camera  ",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(Icons.switch_camera,
                                        color: Colors.blue),
                                  ]),
                              value: 3,
                            ),
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Participants  ",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(CupertinoIcons.person_3_fill,
                                        color: Colors.blue),
                                  ]),
                              value: 4,
                            ),
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      audioViewOn ? "Video View" : "Audio View",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Image.asset(
                                      audioViewOn
                                          ? 'assets/icons/video.png'
                                          : 'assets/icons/audio.png',
                                      color: Colors.blue,
                                      height: 24.0,
                                      width: 24.0,
                                    ),
                                  ]),
                              value: 5,
                            ),
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Active Speaker Mode ",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(CupertinoIcons.person_3_fill,
                                        color: Colors.blue),
                                  ]),
                              value: 6,
                            ),
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Hero Mode ",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(CupertinoIcons.person_3_fill,
                                        color: Colors.blue),
                                  ]),
                              value: 7,
                            ),
                          ],
                          onSelected: handleMenu,
                        ),
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(builder: (_) {
                            if (_meetingStore.screenShareTrack != null &&
                                !audioViewOn) {
                              return SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height /
                                    2.5,
                                child: PeerItemOrganism(
                                  observableMap: {"highestAudio": ""},
                                  height:
                                      MediaQuery.of(context).size.height /
                                          2,
                                  width: MediaQuery.of(context).size.width,
                                  isVideoMuted: false,
                                  peerTracKNode: new PeerTracKNode(
                                      peerId:
                                          _meetingStore.screenSharePeerId,
                                      track:
                                          _meetingStore.screenShareTrack!,
                                      name: _meetingStore.screenShareTrack
                                              ?.peer?.name ??
                                          ""),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          Flexible(
                            child: Observer(
                              builder: (_) {
                                print("rebuilding");
                                if (!_meetingStore.isMeetingStarted)
                                  return SizedBox();
                                if (_meetingStore.peerTracks.isEmpty)
                                  return Center(
                                      child: Text(
                                          'Waiting for others to join!'));
                                ObservableList<PeerTracKNode>
                                    peerFilteredList =
                                    _meetingStore.isActiveSpeakerMode
                                        ? _meetingStore
                                            .activeSpeakerPeerTracksStore
                                        : _meetingStore.peerTracks;
                                ObservableMap<String, String> audioKeyMap =
                                    _meetingStore.observableMap;
                                return GridView.builder(
                                    physics: PageScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    addAutomaticKeepAlives: false,
                                    itemCount: peerFilteredList.length,
                                    shrinkWrap: true,
                                    cacheExtent: 0,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:( !audioViewOn &&
                                              _meetingStore
                                                      .screenShareTrack !=
                                                  null)
                                          ? 1
                                          : 2,
                                      mainAxisExtent:itemWidth,
                                    ),
                                    itemBuilder: (ctx, index) {
                                      return Observer(builder: (context) {
                                        ObservableMap<String,
                                                HMSTrackUpdate> map =
                                            _meetingStore.trackStatus;
                                        print("GRIDVIEW ${map.toString()}");
                                        return VideoTile(
                                          tileIndex: index,
                                          filteredList: peerFilteredList,
                                          trackStatus: map,
                                          observerMap: audioKeyMap,
                                          audioView: audioViewOn,
                                        );
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Observer(builder: (context) {
                              return IconButton(
                                  tooltip: 'Video',
                                  iconSize: 32,
                                  onPressed: (audioViewOn)
                                      ? null
                                      : () {
                                          _meetingStore.toggleVideo();
                                          countOfVideoOnBetweenTwo++;
                                        },
                                  icon: Icon(_meetingStore.isVideoOn
                                      ? Icons.videocam
                                      : Icons.videocam_off));
                            }),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Observer(builder: (context) {
                              return IconButton(
                                  tooltip: 'Audio',
                                  iconSize: 32,
                                  onPressed: () {
                                    _meetingStore.toggleAudio();
                                  },
                                  icon: Icon(_meetingStore.isMicOn
                                      ? Icons.mic
                                      : Icons.mic_off));
                            }),
                          ),
                          Container(
                              padding: EdgeInsets.all(8),
                              child: IconButton(
                                tooltip: 'RaiseHand',
                                iconSize: 32,
                                onPressed: () {
                                  setState(() {
                                    raisedHand = !raisedHand;
                                  });
                                  _meetingStore.raiseHand();
                                  UtilityComponents.showSnackBarWithString(
                                      raisedHand
                                          ? "Raised Hand ON"
                                          : "Raised Hand OFF",
                                      context);
                                },
                                icon: Image.asset(
                                  'assets/icons/raise_hand.png',
                                  color: raisedHand
                                      ? Colors.amber.shade300
                                      : Colors.black,
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: IconButton(
                                tooltip: 'Chat',
                                iconSize: 32,
                                onPressed: () {
                                  chatMessages(context, _meetingStore);
                                },
                                icon: Icon(Icons.chat_bubble)),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: IconButton(
                                color: Colors.red,
                                tooltip: 'Leave Or End',
                                iconSize: 32,
                                onPressed: () async {
                                  String ans = await showDialog(
                                      context: context,
                                      builder: (_) =>
                                          LeaveOrEndMeetingDialogOption(
                                            meetingStore: _meetingStore,
                                          ));
                                  if (ans == 'Leave' || ans == 'End')
                                    Navigator.pop(context);
                                },
                                icon: Icon(Icons.call_end)),
                          ),
                        ]),
                  );
          })),
      onWillPop: () async {
        bool ans = await UtilityComponents.onBackPressed(context);
        return ans;
      },
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.meetingController.startCapturing();
      }
    } else if (state == AppLifecycleState.paused) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.meetingController.stopCapturing();
      }
    } else if (state == AppLifecycleState.inactive) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.meetingController.stopCapturing();
      }
    }
  }
}
