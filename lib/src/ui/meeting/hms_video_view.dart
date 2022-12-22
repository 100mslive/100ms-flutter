// Dart imports:
import 'dart:developer';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show EventChannel, MethodChannel, StandardMessageCodec;

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_video_view_state_change_listener_method.dart';

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
  final HMSVideoTrack track;
  final matchParent;
  final ScaleType scaleType;
  final bool setMirror;
  final HMSVideoViewStateChangeListener? videoViewStateChangeListener;

  HMSVideoView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      this.scaleType = ScaleType.SCALE_ASPECT_FIT,
      this.videoViewStateChangeListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      track: track,
      matchParent: this.matchParent,
      setMirror: setMirror,
      scaleType: this.scaleType,
      videoViewStateChangeListener: videoViewStateChangeListener,
    );
  }
}

class _PlatformView extends StatelessWidget {
  final HMSTrack track;

  final bool setMirror;
  final bool matchParent;
  final ScaleType scaleType;
  final HMSVideoViewStateChangeListener? videoViewStateChangeListener;

  _PlatformView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      required this.scaleType,
      this.videoViewStateChangeListener})
      : super(key: key);

  void onPlatformViewCreated(int id) {}

  @override
  Widget build(BuildContext context) {
    ///AndroidView for android it uses surfaceRenderer provided internally by webrtc.
    if (Platform.isAndroid) {
      if (videoViewStateChangeListener != null) {
        EventChannel _hmsVideoViewChannel =
            EventChannel('hms_video_view_channel${track.trackId}');

        _hmsVideoViewChannel.receiveBroadcastStream({
          'name': 'hms_video_view${track.trackId}'
        }).map<HMSVideoViewStateChangeListenerMethodResponse>((event) {
          Map<String, dynamic>? data = {};
          if (event is Map && event['data'] != null && event['data'] is Map) {
            (event['data'] as Map).forEach((key, value) {
              data[key.toString()] = value;
            });
          }

          HMSVideoViewStateChangeListenerMethod method =
              HMSVideoViewStateChangeListenerMethodValues.getMethodFromName(
                  event['event_name']);
          return HMSVideoViewStateChangeListenerMethodResponse(
              method: method, data: data, response: event);
        }).listen((event) {
          HMSVideoViewStateChangeListenerMethod method = event.method;
          Map data = event.data;
          switch (method) {
            case HMSVideoViewStateChangeListenerMethod.onFirstFrameRendered:
              // TODO: Handle this case.
              log("xyzonFirstFrameRendered called $data trackId: ${track.trackId}");
              break;
            case HMSVideoViewStateChangeListenerMethod.onResolutionChange:
              // TODO: Handle this case.
              log("xyzonResolutionChange called $data trackId: ${track.trackId}");
              break;
            case HMSVideoViewStateChangeListenerMethod.unknown:
              // TODO: Handle this case.

              log("xyzunknowncalled $data trackId: ${track.trackId}");
              break;
          }
        });
      }

    MethodChannel hmsVideoViewChannel = MethodChannel('hms_video_view${track.trackId}');

      return AndroidView(
        viewType: 'HMSVideoView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'track_id': track.trackId,
          'set_mirror': track.source != "REGULAR" ? false : setMirror,
          'scale_type': scaleType.value,
          'match_parent': matchParent,
          'is_video_view_state_change_listener_added':
              (videoViewStateChangeListener != null)
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
          'match_parent': matchParent
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
