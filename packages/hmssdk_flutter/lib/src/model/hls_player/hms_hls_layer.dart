import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSHLSLayer {
  HMSResolution? resolution;
  int? bitrate;

  HMSHLSLayer({this.resolution, this.bitrate});

  factory HMSHLSLayer.fromMap(Map<dynamic, dynamic> map) {
    return HMSHLSLayer(
        resolution: map['resolution'] != null
            ? HMSResolution.fromMap(map['resolution'])
            : null,
        bitrate: map['bitrate']);
  }

  Map<String, dynamic> toMap() {
    return {'resolution': this.resolution?.toMap(), 'bitrate': this.bitrate};
  }
}
