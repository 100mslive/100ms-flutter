import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoView extends StatefulWidget {
  final HMSVideoTrack track;
  final String name;
  const VideoView(this.track, this.name, {Key? key}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    //To know more about HMSVideoView checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/overview
    return HMSVideoView(
      track: widget.track,
      scaleType: widget.track.source == "REGULAR"
          ? ScaleType.SCALE_ASPECT_FILL
          : ScaleType.SCALE_ASPECT_FIT,
    );
  }
}
