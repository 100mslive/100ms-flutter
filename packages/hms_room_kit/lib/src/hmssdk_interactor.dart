//Dart imports
import 'dart:io';

///Package imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

//Project imports
import 'package:hms_room_kit/src/common/utility_functions.dart';

///[HMSSDKInteractor] is the class which is used to interact with the SDK
///It contains all the methods that are required to interact with the SDK
///It takes the following parameters:
///[iOSScreenshareConfig] - This is optional values only required for implementing Screen Share on iOS. They are not required for Android.
///Remove [iOSScreenshareConfig] if your app does not implements Screen Share on iOS.
///
///[joinWithMutedAudio] & [joinWithMutedVideo] are required to set the initial audio/video state i.e what should be camera and mic
///state while room is joined. By default both audio and video are kept as unmute.
///
///[isSoftwareDecoderDisabled] - This is used to disable the software decode. By default it's true.
///[isAudioMixerDisabled] - This is used to disable the audio mixer for iOS. By default it's true.
///[audioMode] - This is used to set the audio mode. By default it's VOICE.
///[isPrebuilt] - This is used to set the prebuilt mode. By default it's false.
///[isNoiseCancellationEnabled] - This is used to set the noise cancellation status in a call. Default value is false
class HMSSDKInteractor {
  /// [hmsSDK] is the instance of the HMSSDK class which is used to interact with the SDK.
  late HMSSDK hmsSDK;

  /// [iOSScreenshareConfig] is optional values only required for implementing Screen Share on iOS. They are not required for Android.
  /// Remove [iOSScreenshareConfig] if your app does not implements Screen Share on iOS.
  /// [joinWithMutedAudio] & [joinWithMutedVideo] are required to set the initial audio/video state i.e what should be camera and mic
  /// state while room is joined. By default both audio and video are kept as unmute.
  /// [isNoiseCancellationEnabled] - By default it's false and is used to enable noise cancellation in the call
  HMSSDKInteractor(
      {HMSIOSScreenshareConfig? iOSScreenshareConfig,
      bool joinWithMutedAudio = false,
      bool joinWithMutedVideo = false,
      bool isSoftwareDecoderDisabled = true,
      bool isAudioMixerDisabled = true,
      HMSAudioMode audioMode = HMSAudioMode.VOICE,
      bool isPrebuilt = false,
      bool isNoiseCancellationEnabled = false,
      bool isAutomaticGainControlEnabled = false,
      bool isNoiseSuppressionEnabled = false}) {
    HMSLogSettings hmsLogSettings = HMSLogSettings(
        maxDirSizeInBytes: 1000000,
        isLogStorageEnabled: true,
        level: HMSLogLevel.OFF);

    HMSTrackSetting trackSetting = Utilities.getTrackSetting(
        isAudioMixerDisabled: (Platform.isIOS && isAudioMixerDisabled),
        joinWithMutedVideo: joinWithMutedVideo,
        joinWithMutedAudio: joinWithMutedAudio,
        isSoftwareDecoderDisabled: isSoftwareDecoderDisabled,
        audioMode: audioMode,
        isNoiseCancellationEnabled: isNoiseCancellationEnabled,
        isAutomaticGainControlEnabled: isAutomaticGainControlEnabled,
        isNoiseSuppressionEnabled: isNoiseSuppressionEnabled);

    hmsSDK = HMSSDK(
        iOSScreenshareConfig: iOSScreenshareConfig,
        hmsLogSettings: hmsLogSettings,
        hmsTrackSetting: trackSetting,
        isPrebuilt: isPrebuilt);
  }

  Future<void> build() async {
    await hmsSDK.build();
  }

  void join({required HMSConfig config}) {
    hmsSDK.join(config: config);
  }

  void leave({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.leave(hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSException?> toggleMicMuteState() async {
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

  Future<HMSException?> startHLSStreaming(
      HMSActionResultListener hmsActionResultListener,
      {String? meetingUrl,
      required HMSHLSRecordingConfig hmshlsRecordingConfig}) async {
    List<HMSHLSMeetingURLVariant>? hmsHlsMeetingUrls;
    if (meetingUrl != null) {
      hmsHlsMeetingUrls = [];
      hmsHlsMeetingUrls.add(HMSHLSMeetingURLVariant(
          meetingUrl: meetingUrl, metadata: "HLS started from Flutter"));
    }
    HMSHLSConfig hmshlsConfig = HMSHLSConfig(
        meetingURLVariant: hmsHlsMeetingUrls,
        hmsHLSRecordingConfig: hmshlsRecordingConfig);

    return await hmsSDK.startHlsStreaming(
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

  void changeRoleOfPeersWithRoles(
      {required HMSRole toRole,
      required List<HMSRole> ofRoles,
      HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.changeRoleOfPeersWithRoles(
        toRole: toRole,
        ofRoles: ofRoles,
        hmsActionResultListener: hmsActionResultListener);
  }

  Future<HMSLogList?> getAllogs() async {
    return await hmsSDK.getAllLogs();
  }

  Future<dynamic> getAuthTokenByRoomCode(
      {required String roomCode, String? userId, String? endPoint}) async {
    return await hmsSDK.getAuthTokenByRoomCode(
        roomCode: roomCode, userId: userId, endPoint: endPoint);
  }

  void switchAudioOutputUsingiOSUI() {
    return hmsSDK.switchAudioOutputUsingiOSUI();
  }

  void sendHLSTimedMetadata(List<HMSHLSTimedMetadata> metadata,
      HMSActionResultListener? hmsActionResultListener) {
    hmsSDK.sendHLSTimedMetadata(
        metadata: metadata, hmsActionResultListener: hmsActionResultListener);
  }

  void toggleAlwaysScreenOn() {
    hmsSDK.toggleAlwaysScreenOn();
  }

  dynamic getRoomLayout({required String authToken, String? endPoint}) async {
    return await hmsSDK.getRoomLayout(authToken: authToken, endPoint: endPoint);
  }

  Future<dynamic> previewForRole({required String role}) async {
    return await hmsSDK.previewForRole(role: role);
  }

  Future<dynamic> cancelPreview() async {
    return await hmsSDK.cancelPreview();
  }

  Future<dynamic> getPeerListIterator(
      {PeerListIteratorOptions? peerListIteratorOptions}) async {
    return await hmsSDK.getPeerListIterator(
        peerListIteratorOptions: peerListIteratorOptions);
  }

  void lowerLocalPeerHand({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.lowerLocalPeerHand(hmsActionResultListener: hmsActionResultListener);
  }

  void raiseLocalPeerHand({HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.raiseLocalPeerHand(hmsActionResultListener: hmsActionResultListener);
  }

  void lowerRemotePeerHand(
      {required HMSPeer forPeer,
      HMSActionResultListener? hmsActionResultListener}) {
    hmsSDK.lowerRemotePeerHand(
        forPeer: forPeer, hmsActionResultListener: hmsActionResultListener);
  }

  void quickStartPoll({required HMSPollBuilder pollBuilder}) {
    HMSPollInteractivityCenter.quickStartPoll(
      pollBuilder: pollBuilder,
    );
  }

  Future<dynamic> addSingleChoicePollResponse(
      {required HMSPoll poll,
      required HMSPollQuestion question,
      required HMSPollQuestionOption pollQuestionOption,
      HMSPeer? peer,
      Duration? timeTakenToAnswer}) {
    return HMSPollInteractivityCenter.addSingleChoicePollResponse(
        hmsPoll: poll,
        pollQuestion: question,
        optionSelected: pollQuestionOption,
        peer: peer,
        timeTakenToAnswer: timeTakenToAnswer);
  }

  Future<dynamic> addMultiChoicePollResponse(
      {required HMSPoll poll,
      required HMSPollQuestion question,
      required List<HMSPollQuestionOption> pollQuestionOption,
      HMSPeer? peer,
      Duration? timeTakenToAnswer}) {
    return HMSPollInteractivityCenter.addMultiChoicePollResponse(
        hmsPoll: poll,
        pollQuestion: question,
        optionsSelected: pollQuestionOption,
        peer: peer,
        timeTakenToAnswer: timeTakenToAnswer);
  }

  Future<dynamic> stopPoll({required HMSPoll poll}) {
    return HMSPollInteractivityCenter.stopPoll(poll: poll);
  }

  Future<dynamic> fetchLeaderboard(
      {required HMSPoll poll,
      required int count,
      required int startIndex,
      required bool includeCurrentPeer}) {
    return HMSPollInteractivityCenter.fetchLeaderboard(
        poll: poll,
        count: count,
        startIndex: startIndex,
        includeCurrentPeer: includeCurrentPeer);
  }

  Future<dynamic> fetchPollList({required HMSPollState hmsPollState}) {
    return HMSPollInteractivityCenter.fetchPollList(hmsPollState: hmsPollState);
  }

  Future<dynamic> fetchPollQuestions({required HMSPoll hmsPoll}) {
    return HMSPollInteractivityCenter.fetchPollQuestions(hmsPoll: hmsPoll);
  }

  Future<dynamic> getPollResults({required HMSPoll hmsPoll}) {
    return HMSPollInteractivityCenter.getPollResults(hmsPoll: hmsPoll);
  }

  void enableNoiseCancellation() {
    HMSNoiseCancellationController.enable();
  }

  void disableNoiseCancellation() {
    HMSNoiseCancellationController.disable();
  }

  Future<bool> isNoiseCancellationAvailable() {
    return HMSNoiseCancellationController.isAvailable();
  }

  Future<bool> isNoiseCancellationEnabled() {
    return HMSNoiseCancellationController.isEnabled();
  }
}
