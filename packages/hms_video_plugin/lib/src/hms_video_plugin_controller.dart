import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hms_video_plugin/src/enum/plugin_method.dart';
import 'package:hms_video_plugin/src/platform_service.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[HMSVideoPlugin] is the entry point for the plugin.
abstract class HMSVideoPlugin {

  static Future<void> enable({required Uint8List? image}) async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(PluginMethod.enableVirtualBackground,
          arguments: {"image": image});
    } else {
      return HMSVideoFilter.enable(image: image);
    }
  }

  static Future<void> changeVirtualBackground({required Uint8List? image}) async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(PluginMethod.changeVirtualBackground,
          arguments: {"image": image});
    } else {
      return HMSVideoFilter.changeVirtualBackground(image: image);
    }
  }

  static Future<void> disable() async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(
          PluginMethod.disableVirtualBackground);
    } else {
      return HMSVideoFilter.disable();
    }
  }

  static Future<void> enableBlur({required int blurRadius}) async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(PluginMethod.enableBlurBackground,
          arguments: {"blur_radius": blurRadius});
    } else {
      return HMSVideoFilter.enableBlur(blurRadius: blurRadius);
    }
  }

  static Future<void> disableBlur() async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(PluginMethod.disableBlurBackground);
    } else {
      return HMSVideoFilter.disableBlur();
    }
  }  
}
