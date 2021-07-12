import 'package:hmssdk_flutter/common/platform_methods.dart';

class PlatformMethodResponse {
  final PlatformMethod method;
  final Map<String, dynamic> data;
  final dynamic response;

  PlatformMethodResponse(
      {required this.method, required this.data, required this.response});
}
