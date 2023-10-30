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

  HMSVideoViewController(
      {HMSVideoTrack? track,
      bool addTrackByDefault = true,
      Function? callback}) {
    createTextureView(track, addTrackByDefault, callback);
  }

  void createTextureView(
      HMSTrack? track, bool addTrackByDefault, Function? callback) async {
    log("HMSVideoViewController createTextureView called");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.createTextureView,
        arguments: {
          "track_id": track?.trackId,
          "add_track_by_def": addTrackByDefault
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
    log("HMSVideoViewController dispose video track");
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

  void addTrack({required HMSVideoTrack track}) async {
    await PlatformService.invokeMethod(PlatformMethod.addTrack, arguments: {
      "track_id": track.trackId,
      "texture_id": textureId.toString()
    });
  }

  void removeTrack() async {
    await PlatformService.invokeMethod(PlatformMethod.removeTrack,
        arguments: {"texture_id": textureId.toString()});
  }

  void _eventListener(dynamic event) {
    log("HMSVideoView Event Fired $event");
  }
}
