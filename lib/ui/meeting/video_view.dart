import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;
import 'package:hmssdk_flutter/model/hms_track.dart';

class VideoView extends StatelessWidget {
  final HMSTrack track;
  final Map<String, Object>? args;

  const VideoView({Key? key, required this.track, this.args}) : super(key: key);

  void onPlatformViewCreated(int id) {
    print('On PlatformView Created:: id:$id');
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'peer_id': track.peer?.peerId,
          'is_local': track.peer?.isLocal,
          'track_id': track.trackId
        }..addAll(args ?? {}),
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'peer_id': track.peer?.peerId,
          'is_local': track.peer?.isLocal,
          'track_id': track.trackId
        }..addAll(args ?? {}),
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
