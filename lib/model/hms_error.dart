
import 'package:hmssdk_flutter/model/hms_error_code.dart';

///HMSError will contain the error and related description which you get when onError is called
class HMSError {
  ///id is name in android
  final String? id;
  final HMSErrorCode? code;
  final String message;

  ///description is info in android
  String description;
  String action;
  Map? params;

  HMSError({
    this.id,
    this.code,
    required this.message,
    required this.description,
    required this.action,
    required this.params,
  });

  factory HMSError.fromMap(Map map) {
    HMSErrorCode? code;

    if (map.containsKey('code')) {
      code = HMSErrorCode(errorCode: map['code'].toString());
    }

    return HMSError(
      id: map["id"]??map['name'] ?? '',
      code: code,
      message: map['message'],
      action: map['action'],
      description: map['info'] ?? map['description'] ?? '',
      params: map['params'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.id,
      'code': code?.errorCode ?? '',
      'message': this.message,
      'info': this.description,
      'description': this.description,
      'action': this.action,
      'params': this.params,
    };
  }

  String get localizedDescription => message;

  Map get analyticsRepresentation => params ?? {};
}
