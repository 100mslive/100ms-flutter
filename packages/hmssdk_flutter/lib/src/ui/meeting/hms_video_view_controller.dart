///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/services.dart';

///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_video_view_event.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSVideoViewController] is used to control the video view. It helps in controlling addTrack, removeTrack functionalities manually.
///It is useful in custom usecases where you wish to control the addTrack and removeTrack functionalities on your own.
class HMSVideoViewController {
  ///[_textureId] is the unique id of the texture view
  int? _textureId;

  ///getter for [_textureId]
  int? get textureId => _textureId;

  int? _height;
  int? _width;
  Function? _updateViewCallback;
  double aspectRatio = 1;

  HMSVideoViewController(
      {HMSVideoTrack? track,
      bool addTrackByDefault = true,
      bool? disableAutoSimulcastLayerSelect = false}) {
    createTextureView(
        track: track,
        addTrackByDefault: addTrackByDefault,
        disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect);
  }

  void createTextureView(
      {HMSTrack? track,
      bool addTrackByDefault = true,
      bool? disableAutoSimulcastLayerSelect}) async {
    log("VKohli Calling createTextureView -> disableAutoSimulcastLayerSelect:$disableAutoSimulcastLayerSelect height: $_height, width: $_width");
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

  void setCallbackMethod(Function callback) {
    log("VKohli Calling setCallbackMethod -> $callback");
    _updateViewCallback = callback;
  }

  void disposeTextureView() async {
    log("VKohli Calling disposeTextureView");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disposeTextureView,
        arguments: {"texture_id": textureId.toString()});
    if (result["success"]) {
      _textureId = null;
    }
  }

  void addTrack(
      {required HMSVideoTrack track,
      bool? disableAutoSimulcastLayerSelect}) async {
    log("VKohli Calling addTrack -> height: $_height, width: $_width");
    await PlatformService.invokeMethod(PlatformMethod.addTrack, arguments: {
      "track_id": track.trackId,
      "texture_id": textureId.toString(),
      "disable_auto_simulcast_layer_select":
          disableAutoSimulcastLayerSelect ?? false,
      "height": _height,
      "width": _width
    });
  }

  void _setDisplayResolution({required int height, required int width}) {
    PlatformService.invokeMethod(PlatformMethod.setDisplayResolution,
        arguments: {
          "texture_id": textureId.toString(),
          "height": height,
          "width": width
        });
  }

  void removeTrack() {
    PlatformService.invokeMethod(PlatformMethod.removeTrack,
        arguments: {"texture_id": textureId.toString()});
  }

  void setHeightWidth({required double height, required double width}) {
    if (_height != height.toInt() || _width != width.toInt()) {
      log("VKohli Calling setHeightWidth-> height: $height, width: $width");
      _height = height.toInt();
      _width = width.toInt();
      _setDisplayResolution(height: _height!, width: _width!);
    }
  }

  void _eventListener(dynamic event) {
    log("VKohli HMSVideoView Event Fired $event");

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
