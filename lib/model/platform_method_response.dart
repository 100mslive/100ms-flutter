import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_preview_update_listener_method.dart';
import 'package:hmssdk_flutter/enum/hms_update_listener_method.dart';

class PlatformMethodResponse {
  final PlatformMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  PlatformMethodResponse(
      {required this.method, required this.data, required this.response});
}

class HMSUpdateListenerMethodResponse {
  final HMSUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  HMSUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}

class HMSPreviewUpdateListenerMethodResponse {
  final HMSPreviewUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  HMSPreviewUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}
