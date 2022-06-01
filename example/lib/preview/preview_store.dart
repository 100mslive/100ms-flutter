//Package imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';

class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {
  late HMSSDKInteractor hmsSDKInteractor;

  PreviewStore() {
    hmsSDKInteractor = HMSSDKInteractor();
  }

  List<HMSVideoTrack> localTracks = [];

  HMSPeer? peer;

  HMSException? error;

  bool isHLSLink = false;
  HMSRoom? room;

  bool isVideoOn = true;

  bool isAudioOn = true;

  bool isRecordingStarted = false;

  List<HMSPeer> peers = [];

  int? networkQuality;

  @override
  void onError({required HMSException error}) {
    updateError(error);
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    this.room = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        peer = each;
        if (each.role.name.indexOf("hls-") == 0) {
          isHLSLink = true;
          notifyListeners();
        }
        break;
      }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
      }
    }
    this.localTracks = videoTracks;
    notifyListeners();
  }

  Future<bool> startPreview(
      {required String user, required String roomId}) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomId);

    if (token == null) return false;
    if (token[0] == null) return false;
    FirebaseCrashlytics.instance.setUserIdentifier(token[0]!);
    HMSConfig config = HMSConfig(
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init",
        captureNetworkQualityInPreview: true);
    hmsSDKInteractor.addPreviewListener(this);
    hmsSDKInteractor.preview(config: config);
    return true;
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        peers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        peers.remove(peer);
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        if (peer.isLocal) {
          networkQuality = peer.networkQuality?.quality;
          notifyListeners();
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        int index = peers.indexOf(peer);
        if (index != -1) peers[index] = peer;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        isRecordingStarted = room.hmsBrowserRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.serverRecordingStateUpdated:
        isRecordingStarted = room.hmsServerRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        isRecordingStarted = room.hmsRtmpStreamingState?.running ?? false;
        break;
      case HMSRoomUpdate.hlsStreamingStateUpdated:
        isRecordingStarted = room.hmshlsStreamingState?.running ?? false;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void removePreviewListener() {
    hmsSDKInteractor.removePreviewListener(this);
  }

  void stopCapturing() {
    hmsSDKInteractor.stopCapturing();
  }

  void startCapturing() {
    hmsSDKInteractor.startCapturing();
  }

  void switchVideo({bool isOn = false}) {
    hmsSDKInteractor.switchVideo(isOn: isOn);
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  void switchAudio({bool isOn = false}) {
    hmsSDKInteractor.switchAudio(isOn: isOn);
    isAudioOn = !isAudioOn;
    notifyListeners();
  }

  void addLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.addLogsListener(hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.removeLogsListener(hmsLogListener);
  }

  @override
  void onLogMessage({required hmsLogList}) {
    FirebaseCrashlytics.instance.log(hmsLogList.toString());
  }

  void updateError(HMSException error) {
    this.error = error;
  }
}
