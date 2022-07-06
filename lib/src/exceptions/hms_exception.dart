// Project imports:
import '../exceptions/hms_exception_code.dart';

class HMSException {
  final String? id;
  final HMSExceptionCode? code;
  final String message;

  String description;
  String action;
  Map? params;

  bool isTerminal = false;

  HMSException(
      {this.id,
      this.code,
      required this.message,
      required this.description,
      required this.action,
      required this.isTerminal,
      this.params});

  factory HMSException.fromMap(Map map) {
    HMSExceptionCode? code;

    if (map.containsKey('code')) {
      code = HMSExceptionCode(errorCode: map['code'].toString());
    }

    return HMSException(
        id: map["id"] ?? map['name'] ?? '',
        code: code,
        message: map['message'],
        action: map['action'] ?? '',
        description: map['info'] ?? map['description'] ?? '',
        params: map['params'],
        isTerminal: map['isTerminal'] ?? false);
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
      'isTerminal': this.params
    };
  }

  String get localizedDescription => message;

  Map get analyticsRepresentation => params ?? {};
}
