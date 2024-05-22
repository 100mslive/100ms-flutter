import 'package:flutter/services.dart';
import 'package:hms_video_plugin/src/enum/plugin_method.dart';

/// An implementation of [HmsVideoFilterPlatform] that uses method channels.
class PlatformService {
  static const _channel = MethodChannel('hms_video_filter');

  ///used to invoke different methods at platform side and returns something but not neccessarily
  static Future<dynamic> invokeMethod(PluginMethod method,
      {Map? arguments}) async {
    var result = await _channel.invokeMethod(
        PlatformMethodValues.getStringFromPlatformMethod(method), arguments);
    return result;
  }
}
