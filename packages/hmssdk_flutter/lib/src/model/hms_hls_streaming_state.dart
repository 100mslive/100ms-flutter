// Project imports
import 'package:hmssdk_flutter/src/model/hms_hls_variant.dart';
import 'package:hmssdk_flutter/src/enum/hms_streaming_state.dart';

///100ms HMSHLSStreamingState
///
///[HMSHLSStreamingState] contains the running status of HMS HLS Streaming and list of [HMSHLSVariant]
class HMSHLSStreamingState {
  final bool running;
  final List<HMSHLSVariant?> variants;
  HMSStreamingState state;
  HMSHLSStreamingState(
      {required this.running, required this.variants, required this.state});

  factory HMSHLSStreamingState.fromMap(Map map) {
    List<HMSHLSVariant?> variants = [];
    if (map.containsKey('variants') && map['variants'] is List) {
      for (var each in (map["variants"] as List)) {
        try {
          HMSHLSVariant? variant =
              each != null ? HMSHLSVariant.fromMap(each as Map) : null;

          variants.add(variant);
        } catch (e) {
          print("HMSHLSStreamingState map: $map error: $e");
        }
      }
    }

    HMSStreamingState state = HMSStreamingStateValues.getStreamingStateFromName(
        map['state'] ?? 'NONE');

    return HMSHLSStreamingState(
      running: map['running'],
      variants: variants,
      state: state,
    );
  }
}
