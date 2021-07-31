class HMSMessage {
  final String sender;
  final String message;
  final String type;
  final String time;
  final String? receiver;

  HMSMessage(
      {required this.sender,
      required this.message,
      required this.type,
      required this.time,
      this.receiver});

  factory HMSMessage.fromMap(Map map) {
    print(map.toString());
    return HMSMessage(
        sender: map['sender'] as String,
        message: map['message'] as String,
        type: map['type'] as String,
        time: map['time'] as String,
        receiver: map['receiver'] as String);
  }

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'sender': sender,
      'message': message,
      'type': type,
      'time': time,
      'receiver': receiver,
    };
  }
}
