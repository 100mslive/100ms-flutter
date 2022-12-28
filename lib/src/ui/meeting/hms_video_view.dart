// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSVideoView
///
///HMSVideoView used to render video in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/hms_video_view.dart`.
///
/// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
///
/// if you want to pass height and width you can pass as a map.
///
/// [HMSVideoView] will render video using trackId from HMSTrack
///
/// [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
/// Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
class HMSVideoView extends StatelessWidget {
  ///  This will render video with trackId present in track.
  ///
  ///[track] - track to be displayed
  final HMSVideoTrack track;

  ///[matchParent] - to match the size of parent widget
  final matchParent;

  ///[scaleType] - To set the video scaling
  final ScaleType scaleType;

  ///[setMirror] - To set mirroring of video
  ///
  ///Generally true for local peer and false for a remote peer
  final bool setMirror;

  ///[isAutoSimulcast] - To set auto simulcast (Adaptive Bitrate)
  final bool isAutoSimulcast;

  HMSVideoView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      this.scaleType = ScaleType.SCALE_ASPECT_FIT,
      this.isAutoSimulcast = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      track: track,
      matchParent: this.matchParent,
      setMirror: setMirror,
      scaleType: this.scaleType,
      isAutoSimulcast: isAutoSimulcast,
    );
  }
}

class _PlatformView extends StatelessWidget {
  final HMSTrack track;

  final bool setMirror;
  final bool matchParent;
  final ScaleType scaleType;
  final bool isAutoSimulcast;

  _PlatformView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      required this.scaleType,
      this.isAutoSimulcast = true})
      : super(key: key);

  void onPlatformViewCreated(int id) {}

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
          'is_auto_simulcast': isAutoSimulcast
        },
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      ///UIKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        viewType: 'HMSFlutterPlatformView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'track_id': track.trackId,
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          'scale_type': scaleType.value,
          'match_parent': matchParent,
          'is_auto_simulcast': isAutoSimulcast
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
