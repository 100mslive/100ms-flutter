class HMSErrorCode {
  final String errorCode;

  HMSErrorCode({required this.errorCode});

  factory HMSErrorCode.fromMap(dynamic code) {
    return HMSErrorCode(errorCode: code.toString());
  }
}
