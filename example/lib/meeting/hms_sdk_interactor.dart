import 'package:hmssdk_flutter/meeting/meeting.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';


class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSMeeting _meeting;

  HMSSDKInteractor({required this.config}) {
    _meeting = HMSMeeting();
  }

  Future<Stream<PlatformMethodResponse>> setup() async {
    await _meeting.startMeeting(config: this.config);
    return _meeting.startListening();
  }

  Future<void> leaveMeeting() async {
    return await _meeting.leaveMeeting();
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await _meeting.switchAudio(isOn: isOn);
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await _meeting.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await _meeting.switchCamera();
  }

  Future<void> sendMessage(String message) async{
    return await _meeting.sendMessage(message);
  }
}
