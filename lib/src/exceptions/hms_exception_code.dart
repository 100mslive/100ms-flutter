class HMSExceptionCode {
  final String errorCode;

  HMSExceptionCode({required this.errorCode});

  factory HMSExceptionCode.fromMap(dynamic code) {
    return HMSExceptionCode(errorCode: code.toString());
  }
}
