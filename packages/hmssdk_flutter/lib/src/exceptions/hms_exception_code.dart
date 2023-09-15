class HMSExceptionCode {
  final int errorCode;

  HMSExceptionCode({required this.errorCode});

  factory HMSExceptionCode.fromMap(dynamic code) {
    return HMSExceptionCode(errorCode: code);
  }
}
