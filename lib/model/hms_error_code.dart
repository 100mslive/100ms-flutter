class HMSErrorCode {
  final String errorCode;

  HMSErrorCode({required this.errorCode});

  factory HMSErrorCode.fromMap(String code) {
    return HMSErrorCode(errorCode: code);
  }
}
