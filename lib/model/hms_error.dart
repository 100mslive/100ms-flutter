import 'package:hmssdk_flutter/model/hms_error_code.dart';

class HMSError {
  final String id;
  final HMSErrorCode code;
  final String message;
  String? info;
  String? action;

  // Map<String, dynamic>? params;
  Map? params;

  HMSError(
      {required this.id,
      required this.code,
      required this.message,
      this.info,
      this.action,
      this.params});

  factory HMSError.fromMap(Map map) {
    return HMSError(
        id: map['id'],
        code: HMSErrorCode.fromMap(map['code']),
        message: map['message'],
        action: map['action'],
        info: map['info'],
        params: map['params']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'code': code.errorCode,
      'message': this.message,
      'info': this.info,
      'action': this.action,
      'params': this.params,
    };
  }

  String get description => message;

  String get localizedDescription => message;

  Map get analyticsRepresentation => params ?? {};
}
