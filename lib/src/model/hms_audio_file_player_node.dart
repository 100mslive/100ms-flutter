import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSAudioFilePlayerNode
///
///[HMSAudioFilePlayerNode] required a parameter type [String] which will be used at the control music player in the room.
///
///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
class HMSAudioFilePlayerNode extends HMSAudioNode {
  final String methodName;

  HMSAudioFilePlayerNode(this.methodName) : super(methodName);

  ///you can use the volume property on nodes to control the volume.
  ///
  ///`Note: volume value range from 0.0 to 1.0`
  ///
  ///Refer [audio share setVolume guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#how-to-change-the-volume-of-different-nodes)
  void setVolume(double volume) async {
    await PlatformService.invokeMethod(PlatformMethod.setAudioShareVolume,
        arguments: {"name": methodName, "volume": volume});
  }

  ///The [play] function on [HMSAudioFilePlayerNode] to play a file on a local device in a meeting room.
  ///
  ///**Parameters**:
  ///
  ///**fileUrl** - Enter the path of file [Refer example App](https://github.com/100mslive/100ms-flutter/tree/main/example)
  ///
  ///**loop** - Play audio in loop. Example background Music
  ///
  ///**interrupts** - Set interrupts parameter to false to tell [HMSAudioFilePlayerNode] to not interrupt the current file playback, but schedule the file after the current file is finished.
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
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
    if (result["success"]) {
      return null;
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///The [pause] function on [HMSAudioFilePlayerNode] to pause a file on a local device in a meeting room.
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
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

  ///The [stop] function on [HMSAudioFilePlayerNode] to stop a file on a local device in a meeting room.
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
  void stop() {
    PlatformService.invokeMethod(PlatformMethod.stopAudioShare,
        arguments: {"name": methodName});
  }

  ///The [isPlaying] function on [HMSAudioFilePlayerNode] to check if audio is playing or not. It will return [bool]
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
  Future<bool> isPlaying() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.audioSharePlaying,
        arguments: {"name": methodName});
    if (result != null) {
      return result["is_playing"];
    }
    return false;
  }

  ///The [currentDuration] function on [HMSAudioFilePlayerNode] will return the current duration of audio shared.
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
  Future<int?> currentDuration() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.audioShareCurrentTime,
        arguments: {"name": methodName});
    if (result != null) {
      return result["current_duration"];
    }
    return null;
  }

  ///The [duration] function on [HMSAudioFilePlayerNode] will return the total duration of audio shared.
  ///
  ///Refer [Audio sharing in iOS guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#i-os-setup)
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
