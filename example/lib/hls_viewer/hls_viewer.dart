import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HLSViewer extends StatefulWidget {
  String streamUrl;

  HLSViewer({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSViewerState createState() => _HLSViewerState();
}

class _HLSViewerState extends State<HLSViewer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    MeetingStore meetingStore = context.read<MeetingStore>();
    flickManager = FlickManager(
      onVideoEnd: () {
        flickManager.handleChangeVideo(VideoPlayerController.network(
          meetingStore.streamUrl,
        ));
      },
      videoPlayerController: VideoPlayerController.network(
        meetingStore.streamUrl,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.watch<MeetingStore>();
    return Scaffold(
      body: Observer(builder: (context) {
        if (meetingStore.hasHlsStarted == false) {
          return Container(
            child: Center(
                child: Text(
              "Waiting for the HLS Streaming to start...",
              style: TextStyle(fontSize: 30.0),
            )),
          );
        } else
          return VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && this.mounted) {
                flickManager.flickControlManager?.autoPause();
              } else if (visibility.visibleFraction == 1) {
                flickManager.flickControlManager?.autoResume();
              }
            },
            child: Container(
              height: 200,
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: FlickPortraitControls(),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: FlickLandscapeControls(),
                ),
              ),
            ),
          );
      }),
    );
  }
}
