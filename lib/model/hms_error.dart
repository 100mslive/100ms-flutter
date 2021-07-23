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

  factory HMSError.fromMap(Map<String, dynamic> map) {
    return new HMSError(
      id: map['id'] as String,
      code: map['code'] as HMSErrorCode,
      message: map['message'] as String,
      info: map['info'] as String?,
      action: map['action'] as String?,
      params: map['params'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'code': this.code,
      'message': this.message,
      'info': this.info,
      'action': this.action,
      'params': this.params,
    } as Map<String, dynamic>;
  }

  String get description => message;

  String get localizedDescription => message;

  Map<String, dynamic> get analyticsRepresentation => params ?? {};
}
