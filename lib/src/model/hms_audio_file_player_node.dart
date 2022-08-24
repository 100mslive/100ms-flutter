import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSAudioFilePlayerNode extends HMSAudioNode {
  final String methodName;

  HMSAudioFilePlayerNode(this.methodName) : super(methodName);

  void setVolume(double volume) async {
    await PlatformService.invokeMethod(PlatformMethod.setAudioShareVolume,
        arguments: {"name": methodName, "volume": volume});
  }

  Future<HMSException?> play(
      {required String fileUrl,
      bool loop = false,
      bool interrupts = true}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.playAudioShare,
        arguments: {
          "name": methodName,
          "file_url": fileUrl,
          "loops": loop,
          "interrupts": interrupts
        });
    if (result == null) {
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }

  void pause() {
    PlatformService.invokeMethod(PlatformMethod.pauseAudioShare,
        arguments: {"name": methodName});
  }

  Future<HMSException?> resume() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.resumeAudioShare,
        arguments: {"name": methodName});
    if (result == null) {
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }

  void stop() {
    PlatformService.invokeMethod(PlatformMethod.stopAudioShare,
        arguments: {"name": methodName});
  }

  Future<bool> isPlaying() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.audioSharePlaying,
        arguments: {"name": methodName});
    if (result != null) {
      return result["is_playing"];
    }
    return false;
  }

  Future<int?> currentDuration() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.audioShareCurrentTime,
        arguments: {"name": methodName});
    if (result != null) {
      return result["current_duration"];
    }
    return null;
  }

  Future<int?> duration() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.audioShareDuration,
        arguments: {"name": methodName});
    if (result != null) {
      return result["duration"];
    }
    return null;
  }
}
