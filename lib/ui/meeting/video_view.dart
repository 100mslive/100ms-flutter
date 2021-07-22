import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';

class VideoView extends StatelessWidget {
  final HMSPeer peer;
  final Map<String, Object>? args;

  const VideoView({Key? key, required this.peer, this.args}) : super(key: key);

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
        creationParams: {'peer_id': peer.peerId,'is_local':peer.isLocal}..addAll(args ?? {}),
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {'peer_id': peer.peerId, 'is_local': peer.isLocal}
          ..addAll(args ?? {}),
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
