import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/manager/HmsSdkManager.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class MeetingController {
  final String roomUrl;
  final String user;
  final MeetingFlow flow;

  MeetingController(
      {required this.roomUrl, required this.user, required this.flow});

  Future<bool> joinMeeting() async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
        userId: Uuid().v1(),
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init");

    await HmsSdkManager.hmsSdkInteractor?.joinMeeting(config: config);
    return true;
  }

  Future<void> leaveMeeting() async {
    HmsSdkManager.hmsSdkInteractor?.leaveMeeting();
  }

  Future<HMSException?> switchAudio({bool isOn = false}) async {
    return await HmsSdkManager.hmsSdkInteractor?.switchAudio(isOn: isOn);
  }

  Future<HMSException?> switchVideo({bool isOn = false}) async {
    return await HmsSdkManager.hmsSdkInteractor?.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await HmsSdkManager.hmsSdkInteractor?.switchCamera();
  }

  void sendMessage(String message) {
    HmsSdkManager.hmsSdkInteractor?.sendMessage(message);
  }

  void sendDirectMessage(String message, String peerId) {
    HmsSdkManager.hmsSdkInteractor?.sendDirectMessage(message, peerId);
  }

  void sendGroupMessage(String message, String roleName) {
    HmsSdkManager.hmsSdkInteractor?.sendGroupMessage(message, roleName);
  }

  void addMeetingListener(HMSUpdateListener listener) {
    HmsSdkManager.hmsSdkInteractor?.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
    HmsSdkManager.hmsSdkInteractor?.removeMeetingListener(listener);
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    HmsSdkManager.hmsSdkInteractor?.startHMSLogger(webRtclogLevel, logLevel);
  }

  void removeHMSLogger() {
    HmsSdkManager.hmsSdkInteractor?.removeHMSLogger();
  }

  void addLogsListener(HMSLogListener listener) {
    HmsSdkManager.hmsSdkInteractor?.addLogsListener(listener);
  }

  void removeLogsListener(HMSLogListener listener) {
    HmsSdkManager.hmsSdkInteractor?.removeLogsListener(listener);
  }

  void setPlayBackAllowed(bool allow) {
    HmsSdkManager.hmsSdkInteractor?.setPlayBackAllowed(allow);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    HmsSdkManager.hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    HmsSdkManager.hmsSdkInteractor?.removePreviewListener(listener);
  }

  Future<HMSPeer?> getLocalPeer() async {
    return await HmsSdkManager.hmsSdkInteractor?.getLocalPeer();
  }

  void acceptRoleChangeRequest() {
    HmsSdkManager.hmsSdkInteractor?.acceptRoleChangeRequest();
  }

  void stopCapturing() {
    HmsSdkManager.hmsSdkInteractor?.stopCapturing();
  }

  void startCapturing() {
    HmsSdkManager.hmsSdkInteractor?.startCapturing();
  }

  void changeRole(
      {required String peerId,
      required String roleName,
      bool forceChange = false}) {
    HmsSdkManager.hmsSdkInteractor?.changeRole(
        peerId: peerId, roleName: roleName, forceChange: forceChange);
  }

  Future<List<HMSRole>> getRoles() async {
    return HmsSdkManager.hmsSdkInteractor!.getRoles();
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    bool isMute = await HmsSdkManager.hmsSdkInteractor!.isAudioMute(peer);
    print("isAudioMute $isMute");
    return isMute;
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    bool isMute = await HmsSdkManager.hmsSdkInteractor!.isVideoMute(peer);
    return isMute;
  }

  void changeTrackRequest(String peerId, bool mute, bool isVideoTrack) {
    HmsSdkManager.hmsSdkInteractor
        ?.changeTrackRequest(peerId, mute, isVideoTrack);
  }

  void endRoom(bool lock, String reason) {
    HmsSdkManager.hmsSdkInteractor?.endRoom(lock, reason);
  }

  void removePeer(String peerId) {
    HmsSdkManager.hmsSdkInteractor?.removePeer(peerId);
  }

  void unMuteAll() {
    HmsSdkManager.hmsSdkInteractor?.unMuteAll();
  }

  void muteAll() {
    HmsSdkManager.hmsSdkInteractor?.muteAll();
  }

  void startRtmpOrRecording(HMSRecordingConfig hmsRecordingConfig) {
    HmsSdkManager.hmsSdkInteractor!.startRtmpOrRecording(hmsRecordingConfig);
  }

  void stopRtmpAndRecording() {
    HmsSdkManager.hmsSdkInteractor?.stopRtmpAndRecording();
  }

  Future<HMSRoom?> getRoom() async {
    return await HmsSdkManager.hmsSdkInteractor?.getRoom();
  }

  void raiseHand() {
    HmsSdkManager.hmsSdkInteractor?.raiseHand();
  }
}
