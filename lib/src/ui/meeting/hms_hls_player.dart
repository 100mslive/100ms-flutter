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
/// [HMSHLSPlayer] will render video using trackId from HMSTrack
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
class HMSHLSPlayer extends StatelessWidget {
  /// This will render video with trackId present in the track
  /// [track] - the video track to be displayed
  final String? hlsUrl;

  ///100ms HMSHLSPlayer
  ///
  ///HMSHLSPlayer used to render video in ios and android devices
  ///
  /// To use,import package:`hmssdk_flutter/ui/meeting/hms_hls_player.dart`.
  ///
  HMSHLSPlayer(
      {Key? key,
      this.hlsUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      hlsUrl: hlsUrl
    );
  }
}

class _PlatformView extends StatelessWidget {
  final String? hlsUrl;

  _PlatformView(
      {Key? key,
      this.hlsUrl})
      : super(key: key);

  void onPlatformViewCreated(int id) {}

  @override
  Widget build(BuildContext context) {
    ///AndroidView for android it uses surfaceRenderer provided internally by webrtc.
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'HMSHLSPlayer',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
           'hls_url': hlsUrl 
        },
        gestureRecognizers: {},
      );
    } else if (Platform.isIOS) {
      ///UIKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        viewType: 'HMSHLSPlayer',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'hls_url': hlsUrl 
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
