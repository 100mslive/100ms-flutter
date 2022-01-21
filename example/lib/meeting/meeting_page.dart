//Package imports
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer.dart';
import 'package:mobx/mobx.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/logs/custom_singleton_logger.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'meeting_participants_list.dart';

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
      _reconnectingDisposer,
      _eventOccuredDisposer;
  late ReactionDisposer _recordingDisposer,
      _reconnectedDisposer,
      _roomEndedDisposer;
  CustomLogger logger = CustomLogger();
  int appBarIndex = 0;
  bool raisedHand = false;
  bool audioViewOn = false;
  int countOfVideoOnBetweenTwo = 1;
  bool videoPreviousState = false;
  bool isRecordingStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _meetingStore = context.read<MeetingStore>();
    allListeners();
    initMeeting();
    checkButtons();
  }

  void allListeners() {
    _eventOccuredDisposer =
        reaction((_) => _meetingStore.event, (eventOccured) {
      return UtilityComponents.showSnackBarWithString(eventOccured, context);
    });
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
                  Navigator.of(context).popUntil((route) => route.isFirst),
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
                UtilityComponents.showonExceptionDialog(event, context),
            });
  }

  void initMeeting() async {
    bool ans = await _meetingStore.join(widget.user, widget.roomId);
    if (!ans) {
      UtilityComponents.showSnackBarWithString("Unable to Join", context);
      Navigator.of(context).pop();
    }
    _meetingStore.startListen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkButtons();
  }

  void checkButtons() async {
    _meetingStore.isVideoOn =
        !(await _meetingStore.isVideoMute(_meetingStore.localPeer));
    _meetingStore.isMicOn =
        !(await _meetingStore.isAudioMute(_meetingStore.localPeer));
  }

  @override
  void dispose() {
    disposeAllListeners();
    super.dispose();
  }

  void disposeAllListeners() {
    _roleChangerequestDisposer.reaction.dispose();
    _trackChangerequestDisposer.reaction.dispose();
    _recordingDisposer.reaction.dispose();
    _roomEndedDisposer.reaction.dispose();
    _reconnectedDisposer.reaction.dispose();
    _reconnectingDisposer.reaction.dispose();
    _hmsExceptionDisposer.reaction.dispose();
    _eventOccuredDisposer.reaction.dispose();
  }

  void handleMenu(int value) async {
    switch (value) {
      case 1:
        // StaticLogger.logger?.d(
        //     "\n----------------------------Sending Logs-----------------\n");
        // StaticLogger.logger?.close();
        // ShareExtend.share(CustomLogger.file?.path ?? '', 'file');
        // logger.getCustomLogger();

        break;

      case 2:
        if (_meetingStore.isRecordingStarted) {
          _meetingStore.stopRtmpAndRecording();
          isRecordingStarted = false;
        } else {
          if (isRecordingStarted == false) {
            String url = await UtilityComponents.showInputDialog(
                context: context,
                placeholder: "Enter RTMP Url",
                prefilledValue: Constant.rtmpUrl);
            if (url.isNotEmpty) {
              _meetingStore.startRtmpOrRecording(
                  meetingUrl: url, toRecord: true, rtmpUrls: null);
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
        }
        setState(() {});
        break;
      case 8:
        String name = await UtilityComponents.showInputDialog(
            context: context, placeholder: "Enter Name");
        if (name.isNotEmpty) {
          _meetingStore.changeName(name: name);
        }
        break;
      case 9:
        if (_meetingStore.hasHlsStarted) {
          _meetingStore.stopHLSStreaming();
        } else {
          String url = await UtilityComponents.showInputDialog(
              context: context,
              placeholder: "Enter HLS Url",
              prefilledValue: widget.roomId + "?token=beam_recording");
          if (url.isNotEmpty) {
            _meetingStore.startHLSStreaming(url);
          }
        }
        break;
      case 10:
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
    var size = MediaQuery.of(context).size;
    final double itemWidth = (size.width - 12) / 2;
    return ConnectivityAppWrapper(
        app: WillPopScope(
      child: ConnectivityWidgetWrapper(
          disableInteraction: true,
          offlineWidget: OfflineWidget(),
          child: Observer(builder: (_) {
            return _meetingStore.reconnecting
                ? OfflineWidget()
                : Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: Text(Constant.meetingCode),
                      actions: [
                        _meetingStore.isRecordingStarted
                            ? Observer(
                                builder: (_) => Container(
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
                                    ))
                            : Container(),
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
                            if (!_meetingStore.localPeer!.role.name
                                .contains("hls-"))
                              PopupMenuItem(
                                child: Observer(
                                    builder: (_) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  _meetingStore
                                                          .isRecordingStarted
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
                            if (!_meetingStore.localPeer!.role.name
                                .contains("hls-"))
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
                            PopupMenuItem(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Change Name",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Icon(Icons.create_rounded,
                                        color: Colors.blue),
                                  ]),
                              value: 8,
                            ),
                            if (!_meetingStore.localPeer!.role.name
                                .contains("hls-"))
                              PopupMenuItem(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _meetingStore.hasHlsStarted
                                            ? "Stop HLS"
                                            : "Start HLS",
                                        style: TextStyle(
                                          color: _meetingStore.hasHlsStarted
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                      ),
                                      Icon(Icons.stream, color: Colors.blue),
                                    ]),
                                value: 9,
                              ),
                            if (_meetingStore
                                .localPeer!.role.permissions.endRoom!)
                              PopupMenuItem(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "End Room",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Icon(Icons.cancel_schedule_send,
                                          color: Colors.blue),
                                    ]),
                                value: 10,
                              ),
                          ],
                          onSelected: handleMenu,
                        )
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Observer(builder: (_) {
                            if (!_meetingStore.isHLSLink &&
                                _meetingStore.curentScreenShareTrack != null &&
                                !audioViewOn) {
                              return SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                child: InteractiveViewer(
                                  child: PeerItemOrganism(
                                    observableMap: {"highestAudio": ""},
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width,
                                    isVideoMuted: false,
                                    peerTracKNode: new PeerTracKNode(
                                        peerId: _meetingStore.screenSharePeerId,
                                        track:
                                            _meetingStore.curentScreenShareTrack
                                                as HMSVideoTrack,
                                        name: _meetingStore
                                                .curentScreenShareTrack!
                                                .peer
                                                ?.name ??
                                            ""),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          Flexible(
                            child: Observer(builder: (_) {
                              // if (!_meetingStore.isMeetingStarted)
                              //   return SizedBox();
                              if (!_meetingStore.isHLSLink) {
                                if (_meetingStore.peerTracks.isEmpty)
                                  return Center(
                                      child:
                                          Text('Waiting for others to join!'));
                                ObservableList<PeerTracKNode> peerFilteredList =
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
                                      crossAxisCount: (!audioViewOn &&
                                              _meetingStore
                                                  .screenShareTrack.isNotEmpty)
                                          ? 1
                                          : 2,
                                      mainAxisExtent: itemWidth,
                                    ),
                                    itemBuilder: (ctx, index) {
                                      return Observer(builder: (context) {
                                        ObservableMap<String, HMSTrackUpdate>
                                            map = _meetingStore.trackStatus;
                                        return VideoTile(
                                          tileIndex: index,
                                          filteredList: peerFilteredList,
                                          trackStatus: map,
                                          observerMap: audioKeyMap,
                                          audioView: audioViewOn,
                                        );
                                      });
                                    });
                              } else {
                                return SizedBox();
                              }
                            }),
                          ),
                          Observer(builder: (_) {
                            print(
                                "hasHLSStarted ${_meetingStore.hasHlsStarted}");
                            if (_meetingStore.isHLSLink &&
                                _meetingStore.hasHlsStarted == false) {
                              return Flexible(
                                child: Container(
                                  child: Center(
                                      child: Text(
                                    "Waiting for the HLS Streaming to start...",
                                    style: TextStyle(fontSize: 30.0),
                                  )),
                                ),
                              );
                            }
                            if (_meetingStore.isHLSLink &&
                                _meetingStore.hasHlsStarted) {
                              return Flexible(
                                child: Center(
                                  child: Container(
                                    child: HLSViewer(
                                        streamUrl: _meetingStore.streamUrl),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                        ],
                      ),
                    ),
                    bottomNavigationBar: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_meetingStore.peerTracks.isNotEmpty &&
                              _meetingStore
                                  .localPeer!.role.publishSettings!.allowed
                                  .contains("video"))
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Observer(builder: (context) {
                                return IconButton(
                                    tooltip: 'Video',
                                    iconSize: 32,
                                    onPressed: (audioViewOn)
                                        ? null
                                        : () {
                                            _meetingStore.switchVideo();
                                            countOfVideoOnBetweenTwo++;
                                          },
                                    icon: Icon(_meetingStore.isVideoOn
                                        ? Icons.videocam
                                        : Icons.videocam_off));
                              }),
                            ),
                          if (_meetingStore.peerTracks.isNotEmpty &&
                              _meetingStore
                                  .localPeer!.role.publishSettings!.allowed
                                  .contains("audio"))
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Observer(builder: (context) {
                                return IconButton(
                                    tooltip: 'Audio',
                                    iconSize: 32,
                                    onPressed: () {
                                      _meetingStore.switchAudio();
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
                                  _meetingStore.changeMetadata();
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
                          if (_meetingStore.peerTracks.isNotEmpty &&
                              _meetingStore
                                  .localPeer!.role.publishSettings!.allowed
                                  .contains("screen"))
                            Container(
                              padding: EdgeInsets.all(8),
                              child: IconButton(
                                  tooltip: 'Share',
                                  iconSize: 32,
                                  onPressed: () {
                                    if (!_meetingStore.isScreenShareOn)
                                      _meetingStore.startScreenShare();
                                    else
                                      _meetingStore.stopScreenShare();
                                  },
                                  icon: Icon(
                                    Icons.screen_share,
                                    color: _meetingStore.isScreenShareOn
                                        ? Colors.blue
                                        : Colors.black,
                                  )),
                            ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: IconButton(
                                color: Colors.red,
                                tooltip: 'Leave Or End',
                                iconSize: 32,
                                onPressed: () async {
                                  await UtilityComponents.onBackPressed(
                                      context);
                                },
                                icon: Icon(Icons.call_end)),
                          ),
                        ]),
                  );
          })),
      onWillPop: () async {
        bool ans = await UtilityComponents.onBackPressed(context) ?? false;
        return ans;
      },
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.startCapturing();
      } else {
        _meetingStore.stopCapturing();
      }
    } else if (state == AppLifecycleState.paused) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.stopCapturing();
      }
    } else if (state == AppLifecycleState.inactive) {
      if (_meetingStore.isVideoOn) {
        _meetingStore.stopCapturing();
      }
    }
  }
}
