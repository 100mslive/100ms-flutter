///VideoView used to render video in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/video_view.dart`.
///
/// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
///
/// if you want to pass height and width you can pass as a map.
// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSVideoView extends StatelessWidget {
  /// [HMSVideoView] will render video using trackId from HMSTrack
  final HMSVideoTrack track;
  final matchParent;

  /// [HMSVideoView] will use viewSize to get height and width of rendered video. If not passed, it will take whatever size is available to the widget.
  final Size? viewSize;
  final ScaleType scaleType;
  final bool setMirror;

  HMSVideoView(
      {Key? key,
        required this.track,
        this.viewSize,
        this.setMirror = false,
        this.matchParent = true,
        this.scaleType = ScaleType.SCALE_ASPECT_FIT})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tempViewSize = viewSize;
    if (tempViewSize != null) {
      return _PlatformView(
          track: track,
          matchParent: this.matchParent,
          viewSize: tempViewSize,
          setMirror: setMirror,
          scaleType: this.scaleType);
    } else
      return LayoutBuilder(builder: (_, constraints) {
        return _PlatformView(
            track: track,
            matchParent: this.matchParent,
            viewSize: Size(constraints.maxWidth, constraints.maxHeight),
            setMirror: setMirror,
            scaleType: this.scaleType);
      });
  }
}

class _PlatformView extends StatelessWidget {
  final HMSTrack track;
  final Size viewSize;

  final bool setMirror;
  final bool matchParent;
  final ScaleType scaleType;

  _PlatformView({
    Key? key,
    required this.track,
    required this.viewSize,
    this.setMirror = false,
    this.matchParent = true,
    required this.scaleType,
  }) : super(key: key);

  void onPlatformViewCreated(int id) {
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
          'track_id': track.trackId,
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          'scale_type': scaleType.value,
          'match_parent': matchParent,
        }..addAll({
          'height': viewSize.height,
          'width': viewSize.width,
        }),
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      ///UiKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        viewType: 'HMSFlutterPlatformView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'track_id': track.trackId,
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          'scale_type': scaleType.value,
          'match_parent': matchParent,
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