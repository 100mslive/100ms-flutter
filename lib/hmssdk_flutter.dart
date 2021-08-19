import 'dart:async';

import 'package:flutter/services.dart';

//HmssdkFlutter connects to ios and android by using channels.
class HmssdkFlutter {
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
