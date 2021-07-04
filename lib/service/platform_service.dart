import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';

class PlatformService {
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');

  static Future<dynamic> invokeMethod(PlatformMethods method,
      {Map? arguments}) async {
    var result = await _channel.invokeMethod(
        PlatformMethodValues.getName(method), arguments);
    print(result);
  }
}
