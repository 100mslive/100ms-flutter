// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSRemotelVideoTrack
///
///[HMSRemoteVideoTrack] contains the remote peer video track information.
class HMSRemoteVideoTrack extends HMSVideoTrack {
  bool isPlaybackAllowed;
  HMSRemoteVideoTrack({
    required bool isDegraded,
    required HMSTrackKind kind,
    required String source,
    required String trackId,
    required String trackDescription,
    required bool isMute,
    required this.isPlaybackAllowed,
  }) : super(
          isDegraded: isDegraded,
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  factory HMSRemoteVideoTrack.fromMap({required Map map}) {
    HMSRemoteVideoTrack track = HMSRemoteVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: (map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        isDegraded: map['is_degraded'],
        isPlaybackAllowed: map['is_playback_allowed']);
    return track;
  }

  Future<HMSException?> setPlaybackAllowed(bool isPlaybackAllowed) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.setPlaybackAllowedForTrack,
        arguments: {
          "is_playback_allowed": isPlaybackAllowed,
          "track_id": trackId,
          "track_kind": HMSTrackKindValue.getValueFromHMSTrackKind(
              HMSTrackKind.kHMSTrackKindVideo)
        });

    if (result == null) {
      this.isPlaybackAllowed = isPlaybackAllowed;
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }

  Future<HMSException?> setSimulcastLayer(HMSSimulcastLayer layer) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.setSimulcastLayer,
        arguments: {
          "track_id": trackId,
          "layer": HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(layer)
        });
    if (result == null) {
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }

  Future<HMSSimulcastLayer> getLayer() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.getLayer, arguments: {
      "track_id": trackId,
    });
    return HMSSimulcastLayerValue.getHMSSimulcastLayerFromName(result);
  }

  Future<List<HMSSimulcastLayerDefinition>> getLayerDefinition() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.getLayerDefinition,
        arguments: {
          "track_id": trackId,
        });
    List<HMSSimulcastLayerDefinition> layers = [];
    for (Map map in result) {
      layers.add(HMSSimulcastLayerDefinition.fromMap(map));
    }
    return layers;
  }
}
