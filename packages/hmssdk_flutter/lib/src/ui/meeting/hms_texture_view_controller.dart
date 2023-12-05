///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/services.dart';

///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_video_view_event.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// (Android Only)
///[HMSTextureViewController] is used to control the video view. It helps in controlling addTrack, removeTrack functionalities manually.
///It is useful in custom usecases where you wish to control the addTrack and removeTrack functionalities on your own.
///Please note that if you control the view creation, addTrack etc. on application, then application has the responsibility
///to release the texture view as well by calling [disposeTextureView]
class HMSTextureViewController {
  ///[_textureId] is the unique id of the texture view
  int? _textureId;

  ///getter for [_textureId]
  int? get textureId => _textureId;

  ///[_height] is the height of the view
  int? _height;

  ///[_width] is the width of the view
  int? _width;

  ///[_updateViewCallback] is the callback required for refreshing the view when certain
  ///properties of the view changes.
  Function? _updateViewCallback;

  ///[aspectRatio] is the aspect ratio of the view
  double aspectRatio = 1;

  HMSTextureViewController(
      {HMSVideoTrack? track,
      bool addTrackByDefault = true,
      bool? disableAutoSimulcastLayerSelect = false}) {
    createTextureView(
        track: track,
        addTrackByDefault: addTrackByDefault,
        disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect);
  }

  /// (Android Only)
  ///[createTextureView] is used to create the texture view. It takes [track] as an optional parameter.
  ///If [track] is provided, then it will add the track to the texture view by default.
  ///If [addTrackByDefault] is set to true, then it will add the track to the texture view by default.
  ///If [disableAutoSimulcastLayerSelect] is set to true, then it will disable the auto simulcast layer selection.
  void createTextureView(
      {HMSTrack? track,
      bool addTrackByDefault = true,
      bool? disableAutoSimulcastLayerSelect}) async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.createTextureView,
          arguments: {
            "track_id": track?.trackId,
            "add_track_by_def": addTrackByDefault,
            "disable_auto_simulcast_layer_select":
                disableAutoSimulcastLayerSelect ?? false
          });
      if (result["success"]) {
        _textureId = result["data"]["texture_id"];
        EventChannel('HMSTextureView/Texture/$textureId')
            .receiveBroadcastStream()
            .listen(_eventListener);
        if (_updateViewCallback != null) {
          _updateViewCallback!();
        }
      }
    }
  }

  /// (Android Only)
  ///[setCallbackMethod] is used to set the callback method for the texture view.
  ///This callback method is used to refresh the view when certain properties of the view changes.
  void setCallbackMethod(Function callback) {
    if (Platform.isAndroid) {
      _updateViewCallback = callback;
    }
  }

  /// (Android Only)
  ///[disposeTextureView] is used to dispose the texture view.
  ///It is the responsibility of the application to dispose the texture view if the controller is created
  ///by the application.
  void disposeTextureView() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.disposeTextureView,
          arguments: {"texture_id": textureId.toString()});
      if (result["success"]) {
        _textureId = null;
      }
    }
  }

  /// (Android Only)
  ///[addTrack] is used to add the track to the texture view.
  ///If [disableAutoSimulcastLayerSelect] is set to true, then it will disable the auto simulcast layer selection.
  void addTrack(
      {required HMSVideoTrack track,
      bool? disableAutoSimulcastLayerSelect}) async {
    if (Platform.isAndroid) {
      await PlatformService.invokeMethod(PlatformMethod.addTrack, arguments: {
        "track_id": track.trackId,
        "texture_id": textureId.toString(),
        "disable_auto_simulcast_layer_select":
            disableAutoSimulcastLayerSelect ?? false,
        "height": _height,
        "width": _width
      });
    }
  }

  /// (Android Only)
  ///[_setDisplayResolution] is used to set the display resolution of the texture view.
  ///It is used internally by the SDK.
  void _setDisplayResolution({required int height, required int width}) {
    if (Platform.isAndroid) {
      PlatformService.invokeMethod(PlatformMethod.setDisplayResolution,
          arguments: {
            "texture_id": textureId.toString(),
            "height": height,
            "width": width
          });
    }
  }

  /// (Android Only)
  ///[removeTrack] is used to remove the track from the texture view.
  void removeTrack() {
    if (Platform.isAndroid) {
      PlatformService.invokeMethod(PlatformMethod.removeTrack,
          arguments: {"texture_id": textureId.toString()});
    }
  }

  /// (Android Only)
  ///[setHeightWidth] is used to set the height and width of the texture view.
  void setHeightWidth({required double height, required double width}) {
    if (Platform.isAndroid) {
      if (_height != height.toInt() || _width != width.toInt()) {
        _height = height.toInt();
        _width = width.toInt();
        _setDisplayResolution(height: _height!, width: _width!);
      }
    }
  }

  ///[_eventListener] is the callback method for the texture view.
  ///We get the native callbacks like [onResolutionChanged] from the texture view.
  void _eventListener(dynamic event) {
    HMSVideoViewEvent videoViewEvent =
        HMSVideoViewValues.getHMSVideoViewEventFromString(event['event_name']);
    switch (videoViewEvent) {
      case HMSVideoViewEvent.onResolutionChanged:
        int width = event['data']?['width'];
        int height = event['data']?['height'];

        if (width == 0.0 || height == 0.0) {
          aspectRatio = 1.0;
        }
        aspectRatio = width / height;
        if (_updateViewCallback != null) {
          _updateViewCallback!();
        }
        break;
      case HMSVideoViewEvent.unknown:
        break;
    }
  }
}
