///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/services.dart';

///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
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

  HMSVideoViewController(
      {HMSVideoTrack? track,
      bool addTrackByDefault = true,
      Function? callback,
      bool? disableAutoSimulcastLayerSelect = false}) {
    createTextureView(
        track: track,
        addTrackByDefault: addTrackByDefault,
        callback: callback,
        disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect);
  }

  void createTextureView(
      {HMSTrack? track,
      bool addTrackByDefault = true,
      Function? callback,
      bool? disableAutoSimulcastLayerSelect}) async {
    log("VKohli Calling createTextureView -> disableAutoSimulcastLayerSelect:$disableAutoSimulcastLayerSelect height: $_height, width: $_width");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.createTextureView,
        arguments: {
          "track_id": track?.trackId,
          "add_track_by_def": addTrackByDefault,
          "disable_auto_simulcast_layer_select":
              disableAutoSimulcastLayerSelect ?? false,
          "width": _width,
          "height": _height
        });
    if (result["success"]) {
      _textureId = result["data"]["texture_id"];
      EventChannel('HMSTextureView/Texture/$textureId')
          .receiveBroadcastStream()
          .listen(_eventListener);
      if (callback != null) {
        callback();
      }
    }
  }

  void disposeTextureView({Function? callback}) async {
    log("VKohli Calling disposeTextureView");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disposeTextureView,
        arguments: {"texture_id": textureId.toString()});
    if (result["success"]) {
      _textureId = null;
      if (callback != null) {
        callback();
      }
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

  void removeTrack() async {
    log("VKohli Calling removeTrack");
    await PlatformService.invokeMethod(PlatformMethod.removeTrack,
        arguments: {"texture_id": textureId.toString()});
  }

  void setHeightWidth(double height, double width) {
    log("VKohli Calling setHeightWidth-> height: $height, width: $width");
    _height = height.toInt();
    _width = width.toInt();
  }

  void _eventListener(dynamic event) {
    log("HMSVideoView Event Fired $event");
  }
}
