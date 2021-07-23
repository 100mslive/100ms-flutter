import 'package:hmssdk_flutter/model/hms_error_code.dart';

class HMSError {
  final String id;
  final HMSErrorCode code;
  final String message;
  String? info;
  String? action;
  Map<String, dynamic>? params;

  HMSError(
      {required this.id,
      required this.code,
      required this.message,
      this.info,
      this.action,
      this.params});

  String get description => message;

  String get localizedDescription => message;

  Map<String, dynamic> get analyticsRepresentation => params ?? {};
}
