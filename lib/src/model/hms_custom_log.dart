///100ms HMSCustomLog
///
///[HMSCustomLog] contains tag and message.
class HMSCustomLog {
  String tag;
  String message;

  HMSCustomLog({
    required this.tag,
    required this.message,
  });

  factory HMSCustomLog.fromMap(Map map) {
    map = map["log"];
    return HMSCustomLog(tag: map["tag"], message: map["message"]);
  }

  Map<String, dynamic> toMap() => {
        'tag': tag,
        'message': message,
      };

  @override
  String toString() {
    return 'HMSCustomLog{tag: $tag, message: $message}';
  }
}
