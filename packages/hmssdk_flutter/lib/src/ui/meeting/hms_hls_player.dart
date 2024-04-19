// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show AndroidViewController, PlatformViewsService, StandardMessageCodec;

///100ms HMSHLSPlayer
///
///HMSHLSPlayer used to render hls stream in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/hms_hls_player.dart`.
///
/// [HMSHLSPlayer] will render video using streamURL
///
/// **parameters**
///
/// **hlsUrl** - m3u8 Stream URL, if not passed HMSSDK tries to get it internally
///
/// **isHLSStatsRequired** - If HLS stats are required set this to true. Default is false
///
/// **showPlayerControls** - To show the default player UI set this to true. Default is false
///
/// Refer [HMSHLSPlayer guide here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player)
class HMSHLSPlayer extends StatelessWidget {
  /// This will render stream with the given stream URL
  /// [hlsUrl] - the video track to be displayed
  final String? hlsUrl;

  final bool? isHLSStatsRequired;

  final bool? showPlayerControls;

  const HMSHLSPlayer(
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
      return PlatformViewLink(
        viewType: 'HMSHLSPlayer',
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: 'HMSHLSPlayer',
            layoutDirection: TextDirection.ltr,
            creationParams: {
              'hls_url': hlsUrl,
              'is_hls_stats_required': isHLSStatsRequired,
              'show_player_controls': showPlayerControls
            },
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
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
