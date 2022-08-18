import 'package:example_riverpod/hms_sdk_interactor.dart';
import 'package:example_riverpod/meeting/meeting_store.dart';
import 'package:example_riverpod/meeting/video_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingPage extends ConsumerStatefulWidget {
  final String roomLink, name;
  final bool isAudioOn;
  final HMSSDKInteractor hmsSDKInteractor;
  const MeetingPage(
      {Key? key,
      required this.name,
      required this.roomLink,
      required this.isAudioOn,
      required this.hmsSDKInteractor})
      : super(key: key);

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends ConsumerState<MeetingPage> {
  late ChangeNotifierProvider<MeetingStore> meetingStoreProvider;
  @override
  void initState() {
    super.initState();
    joinMeeting();
  }

  joinMeeting() async {
    meetingStoreProvider = ChangeNotifierProvider<MeetingStore>((ref) {
      return MeetingStore(hmsSDKInteractor: widget.hmsSDKInteractor);
    });
    bool ans =
        await ref.read(meetingStoreProvider).join(widget.name, widget.roomLink);
    if (ans == false) {
      Navigator.of(context).pop();
    }
    if (!widget.isAudioOn) ref.read(meetingStoreProvider).switchAudio();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Riverpod Example"),
          automaticallyImplyLeading: false,
        ),
        body: VideoTiles(
          peerTracks: ref.watch(meetingStoreProvider).peerTracks,
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.greenAccent,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.cancel),
                label: 'Leave Meeting',
              ),
              BottomNavigationBarItem(
                icon: Icon(ref.watch(meetingStoreProvider).isMicOn
                    ? Icons.mic
                    : Icons.mic_off),
                label: 'Mic',
              ),
              BottomNavigationBarItem(
                icon: Icon(ref.watch(meetingStoreProvider).isVideoOn
                    ? Icons.videocam
                    : Icons.videocam_off),
                label: 'Camera',
              ),
            ],
            onTap: _onItemTapped),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      ref.read(meetingStoreProvider).leave();
      Navigator.pop(context);
    } else if (index == 1) {
      ref.read(meetingStoreProvider).switchAudio();
    } else {
      ref.read(meetingStoreProvider).switchVideo();
    }
  }
}
