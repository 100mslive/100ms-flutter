library;

///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_video_plugin/src/enum/plugin_method.dart';
import 'package:hms_video_plugin/src/platform_service.dart';

///[HMSVideoPlugin] is the entry point for the plugin.
abstract class HMSVideoPlugin {
  static Future<HMSException?> enable({required Uint8List? image}) async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PluginMethod.enableVirtualBackground,
          arguments: {"image": image});
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
    } else {
      return HMSVideoFilter.enable(image: image);
    }
  }

  static Future<void> changeVirtualBackground(
      {required Uint8List? image}) async {
    if (Platform.isAndroid) {
      return PlatformService.invokeMethod(PluginMethod.changeVirtualBackground,
          arguments: {"image": image});
    } else {
      return HMSVideoFilter.changeVirtualBackground(image: image);
    }
  }

  static Future<bool> isSupported() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PluginMethod.isVirtualBackgroundSupported);
      if (result["success"]) {
        return result["data"];
      } else {
        return false;
      }
    } else {
      return HMSVideoFilter.isSupported();
    }
  }

  static Future<HMSException?> disable() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PluginMethod.disableVirtualBackground);
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
    } else {
      return HMSVideoFilter.disable();
    }
  }

  static Future<HMSException?> enableBlur({required int blurRadius}) async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PluginMethod.enableBlurBackground,
          arguments: {"blur_radius": blurRadius});
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
    } else {
      return HMSVideoFilter.enableBlur(blurRadius: blurRadius);
    }
  }

  static Future<HMSException?> disableBlur() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PluginMethod.disableBlurBackground);
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
    } else {
      return HMSVideoFilter.disableBlur();
    }
  }
}
