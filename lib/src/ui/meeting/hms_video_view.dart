///VideoView used to render video in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/video_view.dart`.
///
/// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
///
/// if you want to pass height and width you can pass as a map.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSVideoView extends StatelessWidget {
  /// [HMSVideoView] will render video using trackId from HMSTrack
  final HMSTrack track;

  /// [HMSVideoView] will use viewSize to get height and width of rendered video. If not passed, it will take whatever size is available to the widget.
  final Size? viewSize;
  final bool isAuxiliaryTrack;
  const HMSVideoView({Key? key, required this.track, this.viewSize,required this.isAuxiliaryTrack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempViewSize = viewSize;
    if (tempViewSize != null) {
      return _PlatformView(track: track, viewSize: tempViewSize,isAuxiliaryTrack: this.isAuxiliaryTrack,);
    } else
      return LayoutBuilder(builder: (_, constraints) {
        return _PlatformView(
            track: track,
            viewSize: Size(constraints.maxWidth, constraints.maxHeight),isAuxiliaryTrack: this.isAuxiliaryTrack,);
      });
  }
}

class _PlatformView extends StatelessWidget {
  final HMSTrack track;
  final Size viewSize;
  final bool isAuxiliaryTrack;
  const _PlatformView({Key? key, required this.track, required this.viewSize,required this.isAuxiliaryTrack})
      : super(key: key);

  void onPlatformViewCreated(int id) {
    print('On PlatformView Created:: id:$id');
  }

  @override
  Widget build(BuildContext context) {
    ///AndroidView for android it uses surfaceRenderer provided internally by webrtc.
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'peer_id': track.peer?.peerId,
          'is_local': track.peer?.isLocal,
          'track_id': track.trackId,
          'is_aux': isAuxiliaryTrack
        }..addAll({
            'height': viewSize.height,
            'width': viewSize.width,
          }),
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      ///UiKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'peer_id': track.peer?.peerId,
          'is_local': track.peer?.isLocal,
          'track_id': track.trackId
        }..addAll({
            'height': viewSize.height,
            'width': viewSize.width,
          }),
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
