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
import 'package:hmssdk_flutter/src/enum/hms_video_scale_type.dart';

// ignore: must_be_immutable
class HMSVideoView extends StatelessWidget {
  /// [HMSVideoView] will render video using trackId from HMSTrack
  final HMSTrack track;
  final matchParent;

  /// [HMSVideoView] will use viewSize to get height and width of rendered video. If not passed, it will take whatever size is available to the widget.
  final Size? viewSize;
  bool setMirror;

  HMSVideoView(
      {Key? key,
      required this.track,
      this.viewSize,
      this.setMirror = false,
      this.matchParent = true})
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
      );
    } else
      return LayoutBuilder(builder: (_, constraints) {
        return _PlatformView(
          track: track,
          matchParent: this.matchParent,
          viewSize: Size(constraints.maxWidth, constraints.maxHeight),
          setMirror: setMirror,
        );
      });
  }
}

// ignore: must_be_immutable
class _PlatformView extends StatelessWidget {
  final HMSTrack track;
  final Size viewSize;
  bool setMirror;
  final bool matchParent;

  _PlatformView({
    Key? key,
    required this.track,
    required this.viewSize,
    this.setMirror = false,
    this.matchParent = true,
  }) : super(key: key);

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
          'is_aux': track.source != "REGULAR",
          'screen_share': track.source != "REGULAR",
          // TODO: add config setting for mirror
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          // TODO: add config setting for scale type
          'scale_type': track.source != "REGULAR"
              ? ScalingType.SCALE_ASPECT_FIT.value
              : ScalingType.SCALE_ASPECT_FILL.value,
          // TODO: add config setting for match_parent
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
          'peer_id': track.peer?.peerId,
          'is_local': track.peer?.isLocal,
          'track_id': track.trackId,
          'is_aux': track.source != "REGULAR",
          'screen_share': track.source != "REGULAR",
          // TODO: add config setting for mirror
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          // TODO: add config setting for scale type
          'scale_type': track.source != "REGULAR"
              ? ScalingType.SCALE_ASPECT_FIT.value
              : ScalingType.SCALE_ASPECT_FILL.value,
          // TODO: add config setting for match_parent
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
