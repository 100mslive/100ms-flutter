///PlatformMethodResponse contains all the responses sent back from the platform
///
/// Check out different responses in [PlatformMethod] enum.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';

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

class HMSLogsUpdateListenerMethodResponse {
  final HMSLogsUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;
  HMSLogsUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}
