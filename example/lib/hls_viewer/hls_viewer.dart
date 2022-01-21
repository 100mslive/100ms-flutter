import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HLSViewer extends StatefulWidget {
  final String streamUrl;

  HLSViewer({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSViewerState createState() => _HLSViewerState();
}

class _HLSViewerState extends State<HLSViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.streamUrl,
    )..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller.dispose();
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
          return Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Text(
                    "Waiting for the HLS Streaming to start...",
                    style: TextStyle(fontSize: 30.0),
                  ),
          );
      }),
    );
  }
}
