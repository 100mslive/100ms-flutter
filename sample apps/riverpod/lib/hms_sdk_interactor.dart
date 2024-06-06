//Dart imports
import 'dart:io';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSSDK hmsSDK;

  HMSSDKInteractor({required HMSSDK hmsSDK}) {
    //To know more about HMSSDK setup and initialization checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/install-the-sdk/hmssdk
    initHMSSDK(hmssdk: hmsSDK);
  }

  void initHMSSDK({required HMSSDK hmssdk}) async {
    hmsSDK = hmssdk;
  }

  Future<dynamic> getAuthTokenFromRoomCode({required String roomCode}) async {
    return await hmsSDK.getAuthTokenByRoomCode(roomCode: roomCode);
  }

  void join({required HMSConfig config}) async {
    this.config = config;
    hmsSDK.join(config: this.config);
  }

  void leave({HMSActionResultListener? hmsActionResultListener}) async {
    hmsSDK.leave(hmsActionResultListener: hmsActionResultListener);
  }

  Future<void> switchCamera(
      {HMSActionResultListener? hmsActionResultListener}) async {
    return await hmsSDK.switchCamera(
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<bool> isScreenShareActive() async {
    if (Platform.isAndroid) {
      return await hmsSDK.isScreenShareActive();
    } else {
      return false;
    }
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

  Future<HMSLocalPeer?> getLocalPeer() async {
    return await hmsSDK.getLocalPeer();
  }

  void changeTrackState(HMSTrack forRemoteTrack, bool mute,
      HMSActionResultListener hmsActionResultListener) {
    hmsSDK.changeTrackState(
        forRemoteTrack: forRemoteTrack,
        mute: mute,
        hmsActionResultListener: hmsActionResultListener);
  }

  void toggleCameraMuteState() {
    hmsSDK.toggleCameraMuteState();
  }

  void toggleMicMuteState() {
    hmsSDK.toggleMicMuteState();
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

  void startHLSStreaming(
      String meetingUrl, HMSActionResultListener hmsActionResultListener,
      {bool singleFilePerLayer = false, bool enableVOD = false}) {
    List<HMSHLSMeetingURLVariant> hmsHlsMeetingUrls = [];

    hmsHlsMeetingUrls.add(HMSHLSMeetingURLVariant(
        meetingUrl: meetingUrl, metadata: "HLS started from Flutter"));
    HMSHLSRecordingConfig hmshlsRecordingConfig = HMSHLSRecordingConfig(
        singleFilePerLayer: singleFilePerLayer, videoOnDemand: enableVOD);
    HMSHLSConfig hmshlsConfig = HMSHLSConfig(
        meetingURLVariant: hmsHlsMeetingUrls,
        hmsHLSRecordingConfig: hmshlsRecordingConfig);

    hmsSDK.startHlsStreaming(
        hmshlsConfig: hmshlsConfig,
        hmsActionResultListener: hmsActionResultListener);
  }

  void stopHLSStreaming(
      {required HMSActionResultListener hmsActionResultListener}) {
    hmsSDK.stopHlsStreaming(hmsActionResultListener: hmsActionResultListener);
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

  void addStatsListener(HMSStatsListener listener) {
    hmsSDK.addStatsListener(listener: listener);
  }

  void removeStatsListener(HMSStatsListener listener) {
    hmsSDK.removeStatsListener(listener: listener);
  }
}
