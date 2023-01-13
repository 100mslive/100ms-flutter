//Dart imports

//Project imports
import 'dart:io';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late List<HMSMessage> messages;
  late HMSSDK hmsSDK;

  /// [appGroup] & [preferredExtension] are optional values only required for implementing Screen & Audio Share on iOS. They are not required for Android.
  /// Remove [appGroup] & [preferredExtension] if your app does not implements Screen or Audio Share on iOS.
  /// [joinWithMutedAudio] & [joinWithMutedVideo] are required to set the initial audio/video state i.e what should be camera and mic
  /// state while room is joined.By default both audio and video are kept as mute.
  HMSSDKInteractor(
      {String? appGroup,
      String? preferredExtension,
      bool joinWithMutedAudio = true,
      bool joinWithMutedVideo = true,
      bool isSoftwareDecoderDisabled = true,
      bool isAudioMixerDisabled = true}) {
    HMSLogSettings hmsLogSettings = HMSLogSettings(
        maxDirSizeInBytes: 1000000,
        isLogStorageEnabled: true,
        level: HMSLogLevel.OFF);

    HMSTrackSetting trackSetting = Utilities.getTrackSetting(
        isAudioMixerDisabled: (Platform.isIOS && isAudioMixerDisabled),
        joinWithMutedVideo: joinWithMutedVideo,
        joinWithMutedAudio: joinWithMutedAudio,
        isSoftwareDecoderDisabled: isSoftwareDecoderDisabled);
    hmsSDK = HMSSDK(
        appGroup: appGroup,
        preferredExtension: preferredExtension,
        hmsLogSettings: hmsLogSettings,
        hmsTrackSetting: trackSetting);
    build();
  }

  void build() async {
    await hmsSDK.build();
  }

  void join({required HMSConfig config}) {
    this.config = config;
    hmsSDK.join(config: this.config);
  }

  void leave({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.leave(hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSException?> switchAudio({bool isOn = false}) async {
    return await hmsSDK.switchAudio(isOn: isOn);
  }

  Future<HMSException?> switchVideo({bool isOn = false}) async {
    return await hmsSDK.switchVideo(isOn: isOn);
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
      String message, HMSActionResultListener hmsActionResultListener,
      {String type = "chat"}) {
    hmsSDK.sendBroadcastMessage(
        message: message,
        type: type,
        hmsActionResultListener: hmsActionResultListener);
  }

  void sendDirectMessage(String message, HMSPeer peerTo,
      HMSActionResultListener hmsActionResultListener,
      {String type = "chat"}) {
    hmsSDK.sendDirectMessage(
        message: message,
        peerTo: peerTo,
        type: type,
        hmsActionResultListener: hmsActionResultListener);
  }

  void sendGroupMessage(String message, List<HMSRole> hmsRolesTo,
      HMSActionResultListener hmsActionResultListener,
      {String type = "chat"}) {
    hmsSDK.sendGroupMessage(
        message: message,
        hmsRolesTo: hmsRolesTo,
        type: type,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<void> preview({required HMSConfig config}) {
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

  void stopCapturing() {
    hmsSDK.stopCapturing();
  }

  Future<HMSLocalPeer?> getLocalPeer() async {
    return await hmsSDK.getLocalPeer();
  }

  Future<bool> startCapturing() async {
    return await hmsSDK.startCapturing();
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

  void changeRoleOfPeer(
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

  void muteRoomAudioLocally() {
    hmsSDK.muteRoomAudioLocally();
  }

  void unMuteRoomAudioLocally() {
    hmsSDK.unMuteRoomAudioLocally();
  }

  void muteRoomVideoLocally() {
    hmsSDK.muteRoomVideoLocally();
  }

  void unMuteRoomVideoLocally() {
    hmsSDK.unMuteRoomVideoLocally();
  }

  void startScreenShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.startScreenShare(hmsActionResultListener: hmsActionResultListener);
  }

  void stopScreenShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.stopScreenShare(hmsActionResultListener: hmsActionResultListener);
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

  void startHLSStreaming(HMSActionResultListener hmsActionResultListener,
      {String? meetingUrl,
      required HMSHLSRecordingConfig hmshlsRecordingConfig}) {
    List<HMSHLSMeetingURLVariant>? hmsHlsMeetingUrls;
    if (meetingUrl != null) {
      hmsHlsMeetingUrls = [];
      hmsHlsMeetingUrls.add(HMSHLSMeetingURLVariant(
          meetingUrl: meetingUrl, metadata: "HLS started from Flutter"));
    }
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

  Future<List<HMSPeer>?> getPeers() async {
    return await hmsSDK.getPeers();
  }

  void addStatsListener(HMSStatsListener listener) {
    hmsSDK.addStatsListener(listener: listener);
  }

  void removeStatsListener(HMSStatsListener listener) {
    hmsSDK.removeStatsListener(listener: listener);
  }

  Future<List<HMSAudioDevice>> getAudioDevicesList() async {
    return await hmsSDK.getAudioDevicesList();
  }

  Future<HMSAudioDevice> getCurrentAudioDevice() async {
    return await hmsSDK.getCurrentAudioDevice();
  }

  void switchAudioOutput({required HMSAudioDevice audioDevice}) {
    hmsSDK.switchAudioOutput(audioDevice: audioDevice);
  }

  void startAudioShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.startAudioShare(hmsActionResultListener: hmsActionResultListener);
  }

  void stopAudioShare({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.stopAudioShare(hmsActionResultListener: hmsActionResultListener);
  }

  void setAudioMixingMode(HMSAudioMixingMode audioMixingMode) {
    hmsSDK.setAudioMixingMode(audioMixingMode: audioMixingMode);
  }

  Future<HMSTrackSetting> getTrackSettings() async {
    return await hmsSDK.getTrackSettings();
  }

  void destroy() {
    hmsSDK.destroy();
  }

  void setSessionMetadata(
      {required String? metadata,
      HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.setSessionMetadata(
        metadata: metadata, hmsActionResultListener: hmsActionResultListener);
  }

  Future<String?> getSessionMetadata() {
    return hmsSDK.getSessionMetadata();
  }

  Future<bool> enterPipMode({List<int>? aspectRatio, bool? autoEnterPip}) {
    return hmsSDK.enterPipMode(
        autoEnterPip: autoEnterPip, aspectRatio: aspectRatio);
  }

  Future<bool> isPipActive() {
    return hmsSDK.isPipActive();
  }

  Future<bool> isPipAvailable() {
    return hmsSDK.isPipAvailable();
  }

  void changeRoleOfPeersWithRoles(
      {required HMSRole toRole,
      required List<HMSRole> ofRoles,
      HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.changeRoleOfPeersWithRoles(
        toRole: toRole,
        ofRoles: ofRoles,
        hmsActionResultListener: hmsActionResultListener);
  }
}
