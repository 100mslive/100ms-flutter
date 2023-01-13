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
/// [HMSVideoView] will render video using trackId from HMSTrack
///
/// **parameters**
///
/// **track** - This will render video with trackId present in the track. Use video track only.
///
/// **matchParent** - To match the size of the parent widget.
///
/// **scaleType** - To set the video scaling. [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
///
/// **setMirror** - To set mirroring of video
///
/// **disableAutoSimulcastLayerSelect** -  To disable auto simulcast (Adaptive Bitrate)
///
/// **key** - [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
/// Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
///
/// Refer [HMSVideoView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
class HMSVideoView extends StatelessWidget {
  /// This will render video with trackId present in the track
  /// [track] - the video track to be displayed
  final HMSVideoTrack track;

  /// [matchParent] - to match the size of the parent widget
  final bool matchParent;

  /// [scaleType] - To set the video scaling.
  ///
  /// ScaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
  final ScaleType scaleType;

  /// [setMirror] - To set mirroring of video
  final bool setMirror;

  /// [disableAutoSimulcastLayerSelect] - To disable auto simulcast (Adaptive Bitrate)
  final bool disableAutoSimulcastLayerSelect;

  ///100ms HMSVideoView
  ///
  ///HMSVideoView used to render video in ios and android devices
  ///
  /// To use,import package:`hmssdk_flutter/ui/meeting/hms_video_view.dart`.
  ///
  /// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
  ///
  /// [HMSVideoView] will render video using trackId from HMSTrack
  ///
  /// **parameters**
  ///
  /// **track** - This will render video with trackId present in the track. Use video track only.
  ///
  /// **matchParent** - To match the size of the parent widget.
  ///
  /// **scaleType** - To set the video scaling.`[SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]`
  ///
  /// **setMirror** - To set mirroring of video
  ///
  /// **disableAutoSimulcastLayerSelect** -  To disable auto simulcast (Adaptive Bitrate)
  ///
  /// **key** - [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
  /// Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
  ///
  /// Refer [HMSVideoView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
  HMSVideoView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      this.scaleType = ScaleType.SCALE_ASPECT_FIT,
      this.disableAutoSimulcastLayerSelect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      track: track,
      matchParent: this.matchParent,
      setMirror: setMirror,
      scaleType: this.scaleType,
      disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect,
    );
  }
}

class _PlatformView extends StatelessWidget {
  final HMSTrack track;

  final bool setMirror;
  final bool matchParent;
  final ScaleType scaleType;
  final bool disableAutoSimulcastLayerSelect;

  _PlatformView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      required this.scaleType,
      this.disableAutoSimulcastLayerSelect = false})
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
          'disable_auto_simulcast_layer_select': disableAutoSimulcastLayerSelect
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
          'disable_auto_simulcast_layer_select': disableAutoSimulcastLayerSelect
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
