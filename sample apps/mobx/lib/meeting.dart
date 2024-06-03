import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_example/setup/meeting_store.dart';
import 'package:mobx_example/setup/peer_track_node.dart';

class Meeting extends StatefulWidget {
  final MeetingStore meetingStore;

  const Meeting({Key? key, required this.meetingStore}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  late MeetingStore _meetingStore;
  bool raisedHand = false;

  @override
  void initState() {
    super.initState();
    _meetingStore = widget.meetingStore;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _meetingStore.leave();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  kBottomNavigationBarHeight,
              child: Observer(
                name: "MeetingStore",
                builder: (context) {
                  if (_meetingStore.isRoomEnded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    });
                  }
                  if (_meetingStore.peerTracks.isEmpty) {
                    return const Center(
                        child: Text('Waiting for others to join!'));
                  }
                  ObservableList<PeerTrackNode> peerFilteredList =
                      _meetingStore.peerTracks;

                  return videoPageView(
                    filteredList: peerFilteredList,
                  );
                },
              )),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.grey,
              unselectedItemColor: Colors.grey,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Observer(builder: (context) {
                    return Icon(
                        _meetingStore.isMicOn ? Icons.mic : Icons.mic_off);
                  }),
                  label: 'Mic',
                ),
                BottomNavigationBarItem(
                  icon: Observer(builder: (context) {
                    return Icon(_meetingStore.isVideoOn
                        ? Icons.videocam
                        : Icons.videocam_off);
                  }),
                  label: 'Camera',
                ),
                //For screenshare in iOS follow the steps here : https://www.100ms.live/docs/flutter/v2/features/Screen-Share
                if (Platform.isAndroid)
                  BottomNavigationBarItem(
                      icon: Observer(builder: (context) {
                        return Icon(
                          Icons.screen_share,
                          color: (_meetingStore.isScreenShareOn)
                              ? Colors.green
                              : Colors.grey,
                        );
                      }),
                      label: "ScreenShare"),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.cancel),
                  label: 'Leave',
                ),
              ],
              onTap: (index) => _onItemTapped(index)),
        ),
      ),
    );
  }

  void _onItemTapped(int index) async {
    switch (index) {
      case 0:
        _meetingStore.toggleMicMuteStatus();
        break;
      case 1:
        _meetingStore.toggleCameraMuteStatus();
        break;
      case 2:
        if (Platform.isIOS) {
          _meetingStore.leave();
          return;
        }
        _meetingStore.toggleScreenShare();
        break;
      case 3:
        _meetingStore.leave();
        break;
    }
  }

  Widget videoPageView({required List<PeerTrackNode> filteredList}) {
    List<Widget> pageChild = [];
    for (int i = 0; i < filteredList.length; i = i + 6) {
      if (filteredList.length - i > 5) {
        Widget temp = singleVideoPageView(6, i, filteredList);
        pageChild.add(temp);
      } else {
        Widget temp =
            singleVideoPageView(filteredList.length - i, i, filteredList);
        pageChild.add(temp);
      }
    }
    return PageView(
      children: pageChild,
    );
  }

  Widget singleVideoPageView(int count, int index, List<PeerTrackNode> tracks) {
    return Align(
        alignment: Alignment.center,
        child: Observer(builder: (context) {
          return videoViewGrid(count, index, tracks);
        }));
  }

  Widget videoViewGrid(int count, int start, List<PeerTrackNode> tracks) {
    ObservableMap<String, HMSTrackUpdate> trackUpdate =
        _meetingStore.trackStatus;
    return GridView.builder(
      itemCount: count,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (itemBuilder, index) {
        return Observer(builder: (context) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: videoTile(
                tracks[start + index],
                (trackUpdate[tracks[start + index].uid] ==
                    HMSTrackUpdate.trackMuted)),
          );
        });
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height -
                  kBottomNavigationBarHeight -
                  25)),
    );
  }

  Widget videoTile(PeerTrackNode track, bool isVideoMuted) {
    return (track.track != null && !isVideoMuted)
        ? ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: [
                //To know more about HMSVideoView checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/overview
                HMSVideoView(
                    key: Key(track.uid),
                    track: track.track as HMSVideoTrack,
                    matchParent: false,
                    scaleType: track.track?.source == "REGULAR"
                        ? ScaleType.SCALE_ASPECT_FILL
                        : ScaleType.SCALE_ASPECT_FIT),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    track.name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 36,
                      child: Text(
                        track.name[0],
                        style:
                            const TextStyle(fontSize: 36, color: Colors.white),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      track.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ));
  }
}
