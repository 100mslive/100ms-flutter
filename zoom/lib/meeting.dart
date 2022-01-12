import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zoom/message.dart';
import 'package:zoom/setup/meeting_controller.dart';
import 'package:zoom/setup/meeting_store.dart';
import 'package:zoom/setup/peerTrackNode.dart';

class Meeting extends StatefulWidget {
  final String name, roomLink;

  const Meeting({Key? key, required this.name, required this.roomLink})
      : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> with WidgetsBindingObserver {
  late MeetingStore _meetingStore;
  late HMSMeeting meeting;
  bool raisedHand = false;
  bool audioViewOn = false;
  int countOfVideoOnBetweenTwo = 1;
  bool videoPreviousState = false;
  late PageController _pageController = PageController(initialPage: 0);

  late HMSPeer localPeer;

  initMeeting() async {
    bool ans = await _meetingStore.joinMeeting();
    if (!ans) {
      const SnackBar(content: Text("Unable to Join"));
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
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _meetingStore = MeetingStore();
    MeetingController meetingController =
        MeetingController(roomUrl: widget.roomLink, user: widget.name);
    _meetingStore.meetingController = meetingController;
    _meetingStore.removeLogsListener();
    _meetingStore.removeHMSLogger();
    initMeeting();
    checkButtons();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text("100ms Zoom"),
          actions: [
            IconButton(
                onPressed: () {
                  chatMessages(context, _meetingStore);
                },
                icon: const Icon(Icons.message))
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Flexible(
                        child: Observer(
                          builder: (_) {
                            print("rebuilding");
                            if (_meetingStore.peerTracks.isEmpty) {
                              return const Center(
                                  child: Text('Waiting for others to join!'));
                            }
                            ObservableList<PeerTracKNode> peerFilteredList =
                                _meetingStore.peerTracks;

                            return videoTile(
                              filteredList: peerFilteredList,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Observer(builder: (context) {
                      return CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          icon: _meetingStore.isMicOn
                              ? const Icon(Icons.mic)
                              : const Icon(Icons.mic_off),
                          onPressed: () {
                            _meetingStore.toggleAudio();
                          },
                          color: Colors.blue,
                        ),
                      );
                    }),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: IconButton(
                        icon: const Icon(Icons.call_end),
                        onPressed: () {
                          _meetingStore.leaveMeeting();
                          Navigator.pop(context);
                        },
                        color: Colors.red,
                      ),
                    ),
                    Observer(builder: (context) {
                      return CircleAvatar(
                        backgroundColor: Colors.black,
                        child: IconButton(
                          icon: _meetingStore.isVideoOn
                              ? const Icon(Icons.videocam)
                              : const Icon(Icons.videocam_off),
                          onPressed: () {
                            _meetingStore.toggleVideo();
                            countOfVideoOnBetweenTwo++;
                          },
                          color: Colors.blue,
                        ),
                      );
                    }),
                  ],
                ),
              ),
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

  Future<dynamic> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Leave the Meeting?'),
              actions: [
                TextButton(
                    onPressed: () => {
                          _meetingStore.leaveMeeting(),
                          Navigator.pop(context, true),
                        },
                    child: const Text('Yes',
                        style: TextStyle(height: 1, fontSize: 24))),
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel',
                        style: TextStyle(
                            height: 1, fontSize: 24, color: Colors.red))),
              ],
            ));
  }

  Widget videoTile({
    required List<PeerTracKNode> filteredList,
  }) {
    List<Widget> pageChild = [];
    for (int i = 0; i < filteredList.length; i = i + 6) {
      if (filteredList.length - i > 5) {
        Widget temp = videoView(6, i, filteredList);
        pageChild.add(temp);
      } else {
        Widget temp = videoView(filteredList.length - i, i, filteredList);
        pageChild.add(temp);
      }
    }
    return PageView(
      children: pageChild,
    );
  }

  Widget videoView(int count, int index, List<PeerTracKNode> tracks) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            margin: const EdgeInsets.only(
                bottom: 100, left: 10, right: 10, top: 10),
            child: videoTileView(count, index, tracks)));
  }

  Widget videoTileView(int count, int start, List<PeerTracKNode> tracks) {
    return GridView.builder(
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (itemBuilder, index) {
        ObservableMap<String, HMSTrackUpdate> map = _meetingStore.trackStatus;
        return screenView(
            tracks[start + index],
            tracks[start + index].track?.peer?.isLocal ?? true
                ? !_meetingStore.isVideoOn
                : (map[tracks[index].peerId]) == HMSTrackUpdate.trackMuted);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.88),
    );
  }

  Widget screenView(PeerTracKNode track, bool isVideoMuted) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(bottom: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Observer(builder: (context) {
                  return (isVideoMuted || track.track != null)
                      ? HMSVideoView(
                          track: track.track!,
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          color: Colors.black,
                          child: Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.green,
                              child: track.name.contains(" ")
                                  ? Text(
                                      (track.name.toString().substring(0, 1) +
                                              track.name
                                                  .toString()
                                                  .split(" ")[1]
                                                  .substring(0, 1))
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    )
                                  : Text(track.name
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase()),
                            ),
                          ));
                })),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            track.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (await meeting.isVideoMute(localPeer)) {
        meeting.startCapturing();
      }
    } else if (state == AppLifecycleState.paused) {
      if (await meeting.isVideoMute(localPeer)) {
        meeting.stopCapturing();
      }
    } else if (state == AppLifecycleState.inactive) {
      if (await meeting.isVideoMute(localPeer)) {
        meeting.stopCapturing();
      }
    }
  }
}
