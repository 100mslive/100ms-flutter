import 'package:hmssdk_flutter/src/model/hms_hls_variant.dart';

class HMSHLSStreamingState{
  final bool running;
  final List<HMSHLSVariant?> variants;
  HMSHLSStreamingState({required this.running,required this.variants});

  factory HMSHLSStreamingState.fromMap(Map map) {
    List<HMSHLSVariant?> variants = [];
    print("${map} ");
    if (map.containsKey('variants') && map['variants'] is List) {
      for (var each in (map['variants'] as List)) {
        try {

          HMSHLSVariant? variant = each["variant"]!= null? HMSHLSVariant.fromMap(each["variant"] as Map):null;

          variants.add(variant);
        } catch (e) {
          print(e);
        }
      }
    }
    print("${variants.length} MAPOFHMSHLSStreaming ");

    return HMSHLSStreamingState(
      running: map['running'],
      variants: variants,
    );
  }
}