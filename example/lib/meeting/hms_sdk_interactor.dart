import 'package:hmssdk_flutter/meeting/meeting.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSMeeting _meeting;

  HMSSDKInteractor({required this.config}) {
    _meeting = HMSMeeting();
  }

  Future<void> setup() async {
    await _meeting.startMeeting(config: this.config);
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

  Future<void> sendMessage(String message) async {
    return await _meeting.sendMessage(message);
  }
  Future<void> previewVideo()async{
   return _meeting.previewVideo(config: config);
  }

  void addMeetingListener(HMSUpdateListener listener) {
    _meeting.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
     _meeting.removeMeetingListener(listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
     _meeting.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
     _meeting.removePreviewListener(listener);
  }
}
