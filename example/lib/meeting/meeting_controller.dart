import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class MeetingController {
  final String roomUrl;
  final String user;
  final MeetingFlow flow;
  HMSSDKInteractor? _hmsSdkInteractor;

  MeetingController(
      {required this.roomUrl, required this.user, required this.flow})
      : _hmsSdkInteractor = HMSSDKInteractor();

  Future<bool> joinMeeting() async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
      userId: Uuid().v1(),
      roomId: roomUrl,
      authToken: token[0]!,
      userName: user,
    );

    await _hmsSdkInteractor?.joinMeeting(
        config: config,
        isProdLink: token[1] == "true" ? true : false,
        setWebRtcLogs: true);
    return true;
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

  Future<void> sendDirectMessage(String message, String peerId) async {
    return await _hmsSdkInteractor?.sendDirectMessage(message, peerId);
  }

  Future<void> sendGroupMessage(String message, String roleName) async {
    return await _hmsSdkInteractor?.sendGroupMessage(message, roleName);
  }

  void addMeetingListener(HMSUpdateListener listener) {
    _hmsSdkInteractor?.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
    _hmsSdkInteractor?.removeMeetingListener(listener);
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    _hmsSdkInteractor?.startHMSLogger(webRtclogLevel, logLevel);
  }

  void removeHMSLogger() {
    _hmsSdkInteractor?.removeHMSLogger();
  }

  void addLogsListener(HMSLogListener listener) {
    _hmsSdkInteractor?.addLogsListener(listener);
  }

  void removeLogsListener(HMSLogListener listener) {
    _hmsSdkInteractor?.removeLogsListener(listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    _hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    _hmsSdkInteractor?.removePreviewListener(listener);
  }

  Future<HMSPeer?> getLocalPeer() async {
    return await _hmsSdkInteractor?.getLocalPeer();
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

  void changeTrackRequest(String peerId, bool mute, bool isVideoTrack) {
    _hmsSdkInteractor?.changeTrackRequest(peerId, mute, isVideoTrack);
  }

  Future<bool> endRoom(bool lock) async {
    return (await _hmsSdkInteractor?.endRoom(lock))!;
  }

  void removePeer(String peerId) {
    _hmsSdkInteractor?.removePeer(peerId);
  }

  void unMuteAll() {
    _hmsSdkInteractor?.unMuteAll();
  }

  void muteAll() {
    _hmsSdkInteractor?.muteAll();
  }

  Future<HMSException?> startRtmpOrRecording(HMSRecordingConfig hmsRecordingConfig) async{
    return await _hmsSdkInteractor!.startRtmpOrRecording(hmsRecordingConfig);
  }

  Future<HMSException?> stopRtmpAndRecording() async{
    return await _hmsSdkInteractor!.stopRtmpAndRecording();
  }

}
