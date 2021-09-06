import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class MeetingController {
  final String roomId;
  final String user;
  final MeetingFlow flow;
  HMSSDKInteractor? _hmsSdkInteractor;

  MeetingController(
      {required this.roomId, required this.user, required this.flow})
      : _hmsSdkInteractor = HMSSDKInteractor();

  Future<void> joinMeeting() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig config = HMSConfig(
        userId: Uuid().v1(),
        roomId: roomId,
        authToken: token,
        // endPoint: Constant.getTokenURL,
        userName: user);

    await _hmsSdkInteractor?.joinMeeting(config: config);
  }

  void leaveMeeting() {
    _hmsSdkInteractor?.leaveMeeting();
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await _hmsSdkInteractor?.switchAudio(isOn: isOn);
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await _hmsSdkInteractor?.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await _hmsSdkInteractor?.switchCamera();
  }

  Future<void> sendMessage(String message) async {
    return await _hmsSdkInteractor?.sendMessage(message);
  }

  void addMeetingListener(HMSUpdateListener listener) {
    _hmsSdkInteractor?.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
    _hmsSdkInteractor?.removeMeetingListener(listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    _hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    _hmsSdkInteractor?.removePreviewListener(listener);
  }

  void acceptRoleChangeRequest() {
    _hmsSdkInteractor?.acceptRoleChangeRequest();
  }

  void stopCapturing() {
    _hmsSdkInteractor?.stopCapturing();
  }

  void startCapturing() {
    _hmsSdkInteractor?.startCapturing();
  }

  void changeRole(
      {required String peerId,
      required String roleName,
      bool forceChange = false}) {
    _hmsSdkInteractor?.changeRole(
        peerId: peerId, roleName: roleName, forceChange: forceChange);
  }

  Future<List<HMSRole>> getRoles() async {
    return _hmsSdkInteractor!.getRoles();
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    bool isMute = await _hmsSdkInteractor!.isAudioMute(peer);
    return isMute;
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    bool isMute = await _hmsSdkInteractor!.isVideoMute(peer);
    return isMute;
  }

  void changeTrackRequest(String peerId,bool mute,bool isVideoTrack){
    _hmsSdkInteractor?.changeTrackRequest(peerId, mute, isVideoTrack);
  }
}
