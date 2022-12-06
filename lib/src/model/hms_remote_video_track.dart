// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSRemotelVideoTrack
///
///[HMSRemoteVideoTrack] contains the remote peer video track information.
class HMSRemoteVideoTrack extends HMSVideoTrack {
  bool isPlaybackAllowed;
  List<HMSSimulcastLayerDefinition>? layerDefinitions;
  HMSSimulcastLayer layer;
  HMSRemoteVideoTrack(
      {required bool isDegraded,
      required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      required this.isPlaybackAllowed,
      required this.layer,
      this.layerDefinitions})
      : super(
          isDegraded: isDegraded,
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  factory HMSRemoteVideoTrack.fromMap({required Map map}) {
    List<HMSSimulcastLayerDefinition> layerDefinitions = [];

    for (Map layer in map["layer_definitions"]) {
      layerDefinitions.add(HMSSimulcastLayerDefinition.fromMap(layer));
    }

    HMSRemoteVideoTrack track = HMSRemoteVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: (map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        isDegraded: map['is_degraded'],
        isPlaybackAllowed: map['is_playback_allowed'],
        layer:
            HMSSimulcastLayerValue.getHMSSimulcastLayerFromName(map['layer']),
        layerDefinitions: layerDefinitions);
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
}
