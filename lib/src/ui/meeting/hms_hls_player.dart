// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

/// TODO: Update docs regarding HMSHLSPlayer
///100ms HMSHLSPlayer
///
///HMSHLSPlayer used to render hls stream in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/hms_video_view.dart`.
///
///
///
/// [HMSHLSPlayer] will render video using streamURL
///
/// **parameters**
///
///
///
/// Refer [HMSVideoView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
class HMSHLSPlayer extends StatelessWidget {
  /// This will render stream with the given stream URL
  /// [hlsUrl] - the video track to be displayed
  final String? hlsUrl;

  final bool? isHLSStatsRequired;

  final bool? showPlayerControls;

  ///100ms HMSHLSPlayer
  ///
  ///HMSHLSPlayer used to render HLS Stream in ios and android devices
  ///
  /// To use,import package:`hmssdk_flutter/ui/meeting/hms_hls_player.dart`.
  ///
  HMSHLSPlayer(
      {Key? key, this.hlsUrl, this.isHLSStatsRequired, this.showPlayerControls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      hlsUrl: hlsUrl,
      isHLSStatsRequired: isHLSStatsRequired,
      showPlayerControls: showPlayerControls,
      key: key,
    );
  }
}

class _PlatformView extends StatelessWidget {
  final String? hlsUrl;
  final bool? isHLSStatsRequired;

  final bool? showPlayerControls;

  _PlatformView(
      {Key? key,
      this.hlsUrl,
      this.isHLSStatsRequired = false,
      this.showPlayerControls = false})
      : super(key: key);

  void onPlatformViewCreated(int id) {}

  @override
  Widget build(BuildContext context) {
    ///AndroidView for android it uses surfaceRenderer provided internally by webrtc.
    if (Platform.isAndroid) {
      return AndroidView(
        key: key,
        viewType: 'HMSHLSPlayer',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'hls_url': hlsUrl,
          'is_hls_stats_required': isHLSStatsRequired,
          'show_player_controls': showPlayerControls
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
          'hls_url': hlsUrl,
          'is_hls_stats_required': isHLSStatsRequired,
          'show_player_controls': showPlayerControls
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
