class HMSErrorCode {
  final int errorCode;

  HMSErrorCode({required this.errorCode});

  factory HMSErrorCode.fromMap(Map map) {
    return HMSErrorCode(errorCode: map['error_code']);
  }
}
