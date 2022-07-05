//Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class HLSPlayer extends StatefulWidget {
  final String streamUrl;

  HLSPlayer({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> {
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
    context.watch<MeetingStore>();
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Text(
                "Waiting for the HLS Streaming to start...",
                style: GoogleFonts.inter(color: iconColor, fontSize: 20.0),
              ),
      ),
    );
  }
}
