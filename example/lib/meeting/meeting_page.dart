import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/leave_or_end_meeting.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/main.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:mobx/mobx.dart';
import 'package:rect_getter/rect_getter.dart';
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
  late ReactionDisposer _roleChangerequestDisposer, _trackChangerequestDisposer;
  late ReactionDisposer _errorDisposer;
  late ScrollController _scrollController;
  var _keys = {};
  var listViewKey = RectGetter.createGlobalKey();


  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _scrollController = ScrollController();
    _meetingStore = MeetingStore();
    MeetingController meetingController = MeetingController(
        roomUrl: widget.roomId, flow: widget.flow, user: widget.user);
    _meetingStore.meetingController = meetingController;
    _roleChangerequestDisposer = reaction(
        (_) => _meetingStore.roleChangeRequest,
        (event) => {
              if ((event as HMSRoleChangeRequest).suggestedBy !=
                  _meetingStore.localPeer)
                showRoleChangeDialog(event)
            });
    _trackChangerequestDisposer = reaction(
        (_) => _meetingStore.hmsTrackChangeRequest,
        (event) => {showTrackChangeDialog(event)});
    _errorDisposer = reaction(
        (_) => _meetingStore.error,
        (event) => {
              UtilityComponents.showSnackBarWithString(
                  (event as HMSError).description, context)
            });
    reaction(
        (_) => _meetingStore.reconnected,
        (event) => {
              if ((event as bool) == true)
                UtilityComponents.showSnackBarWithString(
                    "reconnected", context),
              _meetingStore.reconnected = false
            });
    reaction(
        (_) => _meetingStore.reconnecting,
        (event) => {
              if ((event as bool) == true)
                UtilityComponents.showSnackBarWithString(
                    "reconnecting", context),
            });
    super.initState();
    initMeeting();
    checkButtons();
  }

  void initMeeting() async{
    bool ans=await _meetingStore.joinMeeting();
    if(!ans){
      UtilityComponents.showSnackBarWithString("Unable to Join", context);
      Navigator.of(context).pop();
    }
    _meetingStore.startListen();
  }

  void checkButtons() async {
    _meetingStore.isVideoOn = !(await _meetingStore.meetingController.isVideoMute(null));
    _meetingStore.isMicOn =   !(await _meetingStore.meetingController.isAudioMute(null));
  }

  void showRoleChangeDialog(event) async {
    event = event as HMSRoleChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => RoleChangeDialogOrganism(roleChangeRequest: event));
    if (answer == "Ok") {
      debugPrint("OK accepted");
      _meetingStore.meetingController.acceptRoleChangeRequest();
      UtilityComponents.showSnackBarWithString(
          (event as HMSError).description, context);
    }
  }

  Future<dynamic> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Do You Want to leave meeting"),
              actions: [
                FlatButton(
                    onPressed: () => {
                          _meetingStore.meetingController.leaveMeeting(),
                          Navigator.pop(context, true),
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (ctx) => HomePage()))
                        },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
              ],
            ));
  }

  @override
  void dispose() {
    _roleChangerequestDisposer.reaction.dispose();
    _errorDisposer.reaction.dispose();
    _trackChangerequestDisposer.reaction.dispose();
    super.dispose();
  }

  List<int> getVisible() {
    /// First, get the rect of ListView, and then traver the _keys
    /// get rect of each item by keys in _keys, and if this rect in the range of ListView's rect,
    /// add the index into result list.
    var rect = RectGetter.getRectFromKey(listViewKey);
    var _items = <int>[];
    _keys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (itemRect != null && !(itemRect.top > rect!.bottom || itemRect.bottom < rect.top)) _items.add(index);
    });

    /// so all visible item's index are in this _items.
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.roomId),
          actions: [
            Observer(
              builder: (_) => IconButton(
                onPressed: () {
                  _meetingStore.toggleSpeaker();
                },
                icon: Icon(_meetingStore.isSpeakerOn
                    ? Icons.volume_up
                    : Icons.volume_off),
              ),
            ),
            IconButton(
              onPressed: () async {
                if (_meetingStore.isVideoOn) _meetingStore.toggleCamera();
              },
              icon: Icon(Icons.switch_camera),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ParticipantsList(
                      meetingStore: _meetingStore,
                    ),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.person_3_fill),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Observer(builder: (_) {
                if (_meetingStore.screenTrack != null) {
                  return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: PeerItemOrganism(
                        track: _meetingStore.screenTrack!, isVideoMuted: false,),
                  );
                } else {
                  return Text('');
                }
              }),
              Flexible(
                child: Observer(
                  builder: (_) {
                    if (!_meetingStore.isMeetingStarted) return SizedBox();
                    if (_meetingStore.tracks.isEmpty)
                      return Text('Waiting for other to join!');
                    List<HMSTrack> filteredList = _meetingStore.tracks;

                    return NotificationListener<ScrollUpdateNotification>(
                      onNotification: (notification) {
                        print(getVisible());
                        return false;
                      },

                      child: RectGetter(
                        key: listViewKey,
                        child: GridView.count(
                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 2),
                          crossAxisCount: 2,
                          controller: _scrollController,
                          childAspectRatio: itemWidth/itemHeight,
                          children: List.generate(filteredList.length, (index) {
                            _keys[index] = RectGetter.createGlobalKey();
                            return RectGetter(
                              key: _keys[index],
                              child: InkWell(
                                onLongPress: () {
                                  if (!filteredList[index].peer!.isLocal && filteredList[index].source!=HMSTrackSource.kHMSTrackSourceScreen)
                                    showDialog(
                                        context: context,
                                        builder: (_) => Column(
                                              children: [
                                                ChangeTrackOptionDialog(
                                                    isAudioMuted: _meetingStore
                                                                .audioTrackStatus[
                                                            filteredList[index]
                                                                .peer
                                                                ?.peerId] ==
                                                        HMSTrackUpdate.trackMuted,
                                                    isVideoMuted:
                                                        _meetingStore.trackStatus[
                                                                filteredList[index]
                                                                    .peer
                                                                    ?.peerId] ==
                                                            HMSTrackUpdate.trackMuted,
                                                    peerName: filteredList[index]
                                                            .peer
                                                            ?.name ??
                                                        '',
                                                    changeTrack:
                                                        (mute, isVideoTrack) {
                                                      Navigator.pop(context);
                                                      if (filteredList[index]
                                                              .source !=
                                                          HMSTrackSource
                                                              .kHMSTrackSourceScreen)
                                                        _meetingStore
                                                            .changeTrackRequest(
                                                                filteredList[index]
                                                                        .peer
                                                                        ?.peerId ??
                                                                    "",
                                                                mute,
                                                                isVideoTrack);
                                                    },
                                                    removePeer: () {
                                                      Navigator.pop(context);
                                                        _meetingStore
                                                            .removePeerFromRoom(
                                                                filteredList[index]
                                                                    .peer!
                                                                    .peerId);
                                                    }),
                                              ],
                                            ));
                                },
                                child: PeerItemOrganism(
                                    track: filteredList[index],
                                    isVideoMuted: _meetingStore.localPeer?.peerId !=
                                            filteredList[index].peer!.peerId
                                        ? ((_meetingStore
                                                    .trackStatus[filteredList[index]
                                                        .peer!
                                                        .peerId +
                                                    (filteredList[index].source ==
                                                            HMSTrackSource
                                                                .kHMSTrackSourceScreen
                                                        ? "Screen"
                                                        : "")] ??
                                                '') ==
                                            HMSTrackUpdate.trackMuted)
                                        : !_meetingStore.isVideoOn),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
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
              padding: EdgeInsets.all(16),
              child: Observer(builder: (context) {
                return IconButton(
                    tooltip: 'Video',
                    onPressed: () {
                      _meetingStore.toggleVideo();
                    },
                    icon: Icon(_meetingStore.isVideoOn
                        ? Icons.videocam
                        : Icons.videocam_off));
              }),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Observer(builder: (context) {
                return IconButton(
                    tooltip: 'Audio',
                    onPressed: () {
                      _meetingStore.toggleAudio();
                    },
                    icon: Icon(
                        _meetingStore.isMicOn ? Icons.mic : Icons.mic_off));
              }),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: IconButton(
                  tooltip: 'Chat',
                  onPressed: () {
                    chatMessages(context, _meetingStore);
                  },
                  icon: Icon(Icons.chat_bubble)),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: IconButton(
                  tooltip: 'Leave Or End',
                  onPressed: () async {
                    String ans = await showDialog(
                        context: context,
                        builder: (_) => LeaveOrEndMeetingDialogOption(
                              meetingStore: _meetingStore,
                            ));
                    if (ans != null && (ans == "leave" || ans == "end"))
                      Navigator.pop(context);
                  },
                  icon: Icon(Icons.call_end)),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        bool ans = await _onBackPressed();
        return ans;
      },
    );
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

  showTrackChangeDialog(event) async {
    event = event as HMSTrackChangeRequest;
    String answer = await showDialog(
        context: context,
        builder: (ctx) => TrackChangeDialogOrganism(trackChangeRequest: event));
    if (answer == "Ok") {
      debugPrint("OK accepted");
      _meetingStore.changeTracks();
    }
  }
}
