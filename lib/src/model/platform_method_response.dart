// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';
import 'package:hmssdk_flutter/src/enum/hms_network_update_listener_method.dart';
import 'package:hmssdk_flutter/src/enum/hms_stats_listener_method.dart';

///PlatformMethodResponse contains all the responses sent back from the platform
///
/// Check out different responses in [PlatformMethod] enum.
class PlatformMethodResponse {
  final PlatformMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  PlatformMethodResponse(
      {required this.method, required this.data, required this.response});
}

///HMSUpdateListenerMethodResponse contains all the responses sent back from the Meeting Room
///
/// Check out different responses in [HMSUpdateListenerMethod] enum.
class HMSUpdateListenerMethodResponse {
  final HMSUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  HMSUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}

///HMSPreviewUpdateListenerMethodResponse contains all the responses sent back from the preview.
///
/// Check out different responses in [HMSPreviewUpdateListenerMethod] enum.
class HMSPreviewUpdateListenerMethodResponse {
  final HMSPreviewUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  HMSPreviewUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}

///HMSLogsUpdateListenerMethodResponse contains all the responses sent back from the Log.
///
/// Check out different responses in [HMSLogsUpdateListenerMethod] enum.
class HMSLogsUpdateListenerMethodResponse {
  final HMSLogsUpdateListenerMethod method;
  final List<dynamic> data;
  final dynamic response;
  HMSLogsUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}

///HMSNetworkUpdateListenerMethodResponse contains all the responses sent back from the Network.
///
/// Check out different responses in [HMSNetworkUpdateListenerMethod] enum.
class HMSNetworkUpdateListenerMethodResponse {
  final HMSNetworkUpdateListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;
  HMSNetworkUpdateListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}

class HMSStatsListenerMethodResponse {
  final HMSStatsListenerMethod method;
  final Map<String, dynamic> data;
  final dynamic response;
  HMSStatsListenerMethodResponse(
      {required this.method, required this.data, required this.response});
}
