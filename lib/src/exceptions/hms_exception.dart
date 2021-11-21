import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import '../exceptions/hms_exception_code.dart';

class HMSException {
  // String description;
  // String message;
  // int code;
  // String action;
  // String name;

  // HMSException(
  //     this.description, this.message, this.code, this.action, this.name);

  // factory HMSException.fromMap(Map map) {
  //   map = map["error"];
  //   return HMSException(
  //     map['description'],
  //     map['message'],
  //     map['code'],
  //     map['action'],
  //     map['name'],
  //   );
  // }

  // @override
  // String toString() {
  //   return 'HMSException{description: $description, message: $message, code: $code, action: $action, name: $name}';
  // }

  final String? id;
  final HMSExceptionCode? code;
  final String message;

  ///description is info in android
  String description;
  String action;
  Map? params;

  HMSException({
    this.id,
    this.code,
    required this.message,
    required this.description,
    required this.action,
    required this.params,
  });

  factory HMSException.fromMap(Map map) {
    HMSExceptionCode? code;

    if (map.containsKey('code')) {
      code = HMSExceptionCode(errorCode: map['code'].toString());
    }

    return HMSException(
      id: map["id"] ?? map['name'] ?? '',
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
