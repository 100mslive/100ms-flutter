import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSMeeting _meeting;

  HMSSDKInteractor() {
    _meeting = HMSMeeting();
    _meeting.build();
  }

  Future<void> joinMeeting({required HMSConfig config}) async {
    this.config = config;
    await _meeting.joinMeeting(config: this.config);
  }

  void leaveMeeting(
      {required HMSActionResultListener hmsActionResultListener}) async {
    _meeting.leaveMeeting(hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSException?> switchAudio({bool isOn = false}) async {
    return await _meeting.switchAudio(isOn: isOn);
  }

  Future<HMSException?> switchVideo({bool isOn = false}) async {
    return await _meeting.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await _meeting.switchCamera();
  }

  Future<bool> isScreenShareActive() async {
    return await _meeting.isScreenShareActive();
  }

  void sendBroadcastMessage(String message) {
    _meeting.sendBroadcastMessage(message: message, type: "chat");
  }

  void sendDirectMessage(String message, HMSPeer peer) async {
    _meeting.sendDirectMessage(
      message: message,
      peer: peer,
      type: "chat",
    );
  }

  void sendGroupMessage(String message, String roleName) async {
    _meeting.sendGroupMessage(
      message: message,
      roleName: roleName,
      type: "chat",
    );
  }

  Future<void> previewVideo({required HMSConfig config}) async {
    this.config = config;
    return _meeting.previewVideo(config: config);
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    _meeting.startHMSLogger(webRtclogLevel: webRtclogLevel, logLevel: logLevel);
  }

  void removeHMSLogger() {
    _meeting.removeHMSLogger();
  }

  void addLogsListener(HMSLogListener hmsLogListener) {
    _meeting.addLogListener(hmsLogListener: hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    _meeting.removeLogListener(hmsLogListener: hmsLogListener);
  }

  void addMeetingListener(HMSUpdateListener listener) {
    _meeting.addMeetingListener(listener: listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
    _meeting.removeMeetingListener(listener: listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    _meeting.addPreviewListener(listener: listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    _meeting.removePreviewListener(listener: listener);
  }

  void acceptRoleChangeRequest(
      HMSActionResultListener hmsActionResultListener) {
    _meeting.acceptRoleChangeRequest(
        hmsActionResultListener: hmsActionResultListener);
  }

  void stopCapturing() {
    _meeting.stopCapturing();
  }

  Future<HMSPeer?> getLocalPeer() async {
    return await _meeting.getLocalPeer();
  }

  Future<bool> startCapturing() async {
    return await _meeting.startCapturing();
  }

  Future<HMSPeer?> getPeer({required String peerId}) async {
    List<HMSPeer>? peers = await _meeting.getPeers();

    return peers?.firstWhere((element) => element.peerId == peerId);
  }

  void changeTrackRequest(HMSPeer peer, bool mute, bool isVideoTrack,
      HMSActionResultListener hmsActionResultListener) {
    _meeting.changeTrackRequest(
        peer: peer,
        mute: mute,
        isVideoTrack: isVideoTrack,
        hmsActionResultListener: hmsActionResultListener);
  }

  // TODO: implement accept change Track request

  void endRoom(bool lock, String reason,
      HMSActionResultListener hmsActionResultListener) {
    _meeting.endRoom(
        lock: lock,
        reason: reason,
        hmsActionResultListener: hmsActionResultListener);
  }

  void removePeer(
      HMSPeer peer, HMSActionResultListener hmsActionResultListener) {
    _meeting.removePeer(
        peer: peer,
        reason: "Removing Peer from Flutter",
        hmsActionResultListener: hmsActionResultListener);
  }

  void changeRole(
      {required HMSPeer peer,
      required String roleName,
      bool forceChange = false,
      required HMSActionResultListener hmsActionResultListener}) {
    _meeting.changeRole(
        peer: peer,
        roleName: roleName,
        forceChange: forceChange,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<List<HMSRole>> getRoles() async {
    return await _meeting.getRoles();
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    return await _meeting.isAudioMute(peer: peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    // TODO: add permission checks in exmaple app UI
    return await _meeting.isVideoMute(peer: peer);
  }

  void muteAll() {
    // TODO: add permission checks in exmaple app UI
    _meeting.muteAll();
  }

  void startScreenShare() {
    _meeting.startScreenShare();
  }

  void stopScreenShare() {
    _meeting.stopScreenShare();
  }

  void unMuteAll() {
    // TODO: add permission checks in exmaple app UI
    _meeting.unMuteAll();
  }

  void setPlayBackAllowed(bool allow) {
    // TODO: add permission checks in exmaple app UI
    _meeting.setPlayBackAllowed(allow: allow);
  }

  void startRtmpOrRecording(HMSRecordingConfig hmsRecordingConfig,
      HMSActionResultListener hmsActionResultListener) {
    _meeting.startRtmpOrRecording(
        hmsRecordingConfig: hmsRecordingConfig,
        hmsActionResultListener: hmsActionResultListener);
  }

  void stopRtmpAndRecording(HMSActionResultListener hmsActionResultListener) {
    _meeting.stopRtmpAndRecording(
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSRoom?> getRoom() async {
    return await _meeting.getRoom();
  }

  void raiseHand(
      {required String metadata,
      required HMSActionResultListener hmsActionResultListener}) {
    _meeting.raiseHand(
        metadata: metadata, hmsActionResultListener: hmsActionResultListener);
  }
}
