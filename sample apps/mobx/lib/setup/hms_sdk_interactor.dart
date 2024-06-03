//Project imports

import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSSDK hmsSDK;

  HMSSDKInteractor({required HMSSDK hmssdk}) {
    _initHMSSDK(hmssdk: hmssdk);
  }

  Future<void> _initHMSSDK({required HMSSDK hmssdk}) async {
    hmsSDK = hmssdk;
  }

  Future<dynamic> getAuthTokenFromRoomCode({required String roomCode}) async {
    return await hmsSDK.getAuthTokenByRoomCode(roomCode: roomCode);
  }

  Future<void> join({required HMSConfig config}) async {
    this.config = config;
    await hmsSDK.join(config: this.config);
  }

  void leave({required HMSActionResultListener hmsActionResultListener}) async {
    hmsSDK.leave(hmsActionResultListener: hmsActionResultListener);
  }

  void destroy() {
    hmsSDK.destroy();
  }

  Future<HMSException?> toggleMicMuteStatus() async {
    return await hmsSDK.toggleMicMuteState();
  }

  Future<HMSException?> toggleCameraMuteState() async {
    return await hmsSDK.toggleCameraMuteState();
  }

  Future<void> switchCamera(
      {HMSActionResultListener? hmsActionResultListener}) async {
    return await hmsSDK.switchCamera(
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<bool> isScreenShareActive() async {
    return await hmsSDK.isScreenShareActive();
  }

  void sendBroadcastMessage(
      String message, HMSActionResultListener hmsActionResultListener) {
    hmsSDK.sendBroadcastMessage(
        message: message,
        type: "chat",
        hmsActionResultListener: hmsActionResultListener);
  }

  void sendDirectMessage(String message, HMSPeer peerTo,
      HMSActionResultListener hmsActionResultListener) async {
    hmsSDK.sendDirectMessage(
        message: message,
        peerTo: peerTo,
        type: "chat",
        hmsActionResultListener: hmsActionResultListener);
  }

  void sendGroupMessage(String message, List<HMSRole> hmsRolesTo,
      HMSActionResultListener hmsActionResultListener) async {
    hmsSDK.sendGroupMessage(
        message: message,
        hmsRolesTo: hmsRolesTo,
        type: "chat",
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<void> preview({required HMSConfig config}) async {
    this.config = config;
    return hmsSDK.preview(config: config);
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    hmsSDK.startHMSLogger(webRtclogLevel: webRtclogLevel, logLevel: logLevel);
  }

  void removeHMSLogger() {
    hmsSDK.removeHMSLogger();
  }

  void addLogsListener(HMSLogListener hmsLogListener) {
    hmsSDK.addLogListener(hmsLogListener: hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    hmsSDK.removeLogListener(hmsLogListener: hmsLogListener);
  }

  void addUpdateListener(HMSUpdateListener listener) {
    hmsSDK.addUpdateListener(listener: listener);
  }

  void removeUpdateListener(HMSUpdateListener listener) {
    hmsSDK.removeUpdateListener(listener: listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    hmsSDK.addPreviewListener(listener: listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    hmsSDK.removePreviewListener(listener: listener);
  }

  void acceptChangeRole(HMSRoleChangeRequest hmsRoleChangeRequest,
      HMSActionResultListener hmsActionResultListener) {
    hmsSDK.acceptChangeRole(
        hmsRoleChangeRequest: hmsRoleChangeRequest,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSPeer?> getLocalPeer() async {
    return await hmsSDK.getLocalPeer();
  }

  Future<HMSPeer?> getPeer({required String peerId}) async {
    List<HMSPeer>? peers = await hmsSDK.getPeers();

    return peers?.firstWhere((element) => element.peerId == peerId);
  }

  void changeTrackState(HMSTrack forRemoteTrack, bool mute,
      HMSActionResultListener hmsActionResultListener) {
    hmsSDK.changeTrackState(
        forRemoteTrack: forRemoteTrack,
        mute: mute,
        hmsActionResultListener: hmsActionResultListener);
  }

  void endRoom(bool lock, String reason,
      HMSActionResultListener hmsActionResultListener) {
    hmsSDK.endRoom(
        lock: lock,
        reason: reason,
        hmsActionResultListener: hmsActionResultListener);
  }

  void removePeer(
      HMSPeer peer, HMSActionResultListener hmsActionResultListener) {
    hmsSDK.removePeer(
        peer: peer,
        reason: "Removing Peer from Flutter",
        hmsActionResultListener: hmsActionResultListener);
  }

  void changeRole(
      {required HMSPeer forPeer,
      required HMSRole toRole,
      bool force = false,
      required HMSActionResultListener hmsActionResultListener}) {
    hmsSDK.changeRoleOfPeer(
        forPeer: forPeer,
        toRole: toRole,
        force: force,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<List<HMSRole>> getRoles() async {
    return await hmsSDK.getRoles();
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    return await hmsSDK.isAudioMute(peer: peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    return await hmsSDK.isVideoMute(peer: peer);
  }

  void muteAll() {
    hmsSDK.muteRoomAudioLocally();
  }

  void startScreenShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.startScreenShare(hmsActionResultListener: hmsActionResultListener);
  }

  void stopScreenShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.stopScreenShare(hmsActionResultListener: hmsActionResultListener);
  }

  void unMuteAll() {
    hmsSDK.unMuteRoomAudioLocally();
  }

  void startRtmpOrRecording(HMSRecordingConfig hmsRecordingConfig,
      HMSActionResultListener hmsActionResultListener) {
    hmsSDK.startRtmpOrRecording(
        hmsRecordingConfig: hmsRecordingConfig,
        hmsActionResultListener: hmsActionResultListener);
  }

  void stopRtmpAndRecording(HMSActionResultListener hmsActionResultListener) {
    hmsSDK.stopRtmpAndRecording(
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSRoom?> getRoom() async {
    return await hmsSDK.getRoom();
  }

  void changeMetadata(
      {required String metadata,
      required HMSActionResultListener hmsActionResultListener}) {
    hmsSDK.changeMetadata(
        metadata: metadata, hmsActionResultListener: hmsActionResultListener);
  }

  void changeName(
      {required String name,
      required HMSActionResultListener hmsActionResultListener}) {
    hmsSDK.changeName(
        name: name, hmsActionResultListener: hmsActionResultListener);
  }

  void changeTrackStateForRole(bool mute, HMSTrackKind? kind, String? source,
      List<HMSRole>? roles, HMSActionResultListener? hmsActionResultListener) {
    hmsSDK.changeTrackStateForRole(
        mute: mute,
        kind: kind,
        source: source,
        roles: roles,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<List<HMSPeer>?> getPeers() async {
    return await hmsSDK.getPeers();
  }
}
