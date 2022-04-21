// Project imports
import 'package:hmssdk_flutter/src/model/hms_hls_variant.dart';

///100ms HMSHLSStreamingState
///
///[HMSHLSStreamingState] contains the running status of HMS HLS Streaming and list of [HMSHLSVariant]
class HMSHLSStreamingState {
  final bool running;
  final List<HMSHLSVariant?> variants;
  HMSHLSStreamingState({required this.running, required this.variants});

  factory HMSHLSStreamingState.fromMap(Map map) {
    List<HMSHLSVariant?> variants = [];
    if (map.containsKey('variants') && map['variants'] is List) {
      for (var each in (map["variants"] as List)) {
        try {
          HMSHLSVariant? variant =
              each != null ? HMSHLSVariant.fromMap(each as Map) : null;

          variants.add(variant);
        } catch (e) {
          print(e);
        }
      }
    }

    return HMSHLSStreamingState(
      running: map['running'],
      variants: variants,
    );
  }
}
