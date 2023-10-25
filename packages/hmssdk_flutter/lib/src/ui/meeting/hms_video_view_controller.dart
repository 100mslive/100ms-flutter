import 'dart:developer';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSVideoViewController {
  int? textureId;

  HMSVideoViewController(
      {HMSVideoTrack? track, bool addTrackByDefault = true,Function? callback}) {
    createTextureView(track, addTrackByDefault,callback);
  }

  void createTextureView(HMSTrack? track, bool addTrackByDefault, Function? callback) async {
    log("HMSVideoViewController createTextureView called");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.createTextureView,
        arguments: {
          "track_id": track?.trackId,
          "add_track_by_def": addTrackByDefault
        });
    if (result["success"]) {
      textureId = result["data"]["texture_id"];
      if(callback  != null){
        callback();
      }
    }
  }

  void disposeTextureView({ Function? callback}) async {
    log("HMSVideoViewController dispose video track");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disposeTextureView,
        arguments: {"texture_id": textureId.toString()});
    if (result["success"]) {
      textureId = null;
      if(callback != null){
        callback();
      }
    }
  }

  void addTrack({required HMSVideoTrack track}) async {
    await PlatformService.invokeMethod(PlatformMethod.addTrack, arguments: {
      "track_id": track.trackId,
      "texture_id":textureId.toString()
    });
  }

  void removeTrack() async {
    await PlatformService.invokeMethod(PlatformMethod.removeTrack, arguments: {
      "texture_id":textureId.toString()
    });
  }
}
