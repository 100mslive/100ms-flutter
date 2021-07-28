import 'dart:collection';
class HMSMessage {
  final String sender;
  final String message;
  final String type;
  final String time;

  HMSMessage(
      {required this.sender,
      required this.message,
      required this.type,
      required this.time});

  factory HMSMessage.fromMap(Map map) {
    print(map.toString());
    return HMSMessage(
        sender: map['sender'] as String,
        message: map['message'] as String,
        type: map['type'] as String,
        time: map['time'] as String);
  }

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'sender': sender,
      'message': message,
      'type': type,
      'time': time
    };
  }
}
