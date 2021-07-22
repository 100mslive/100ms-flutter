class HMSMessage {
  final String sender;
  final String receiver;
  final String message;
  final String type;
  final String time;

  HMSMessage(
      {required this.sender,
      required this.receiver,
      required this.message,
      required this.type,
      required this.time});

  factory HMSMessage.fromMap(Map<String, dynamic> map) {
    return HMSMessage(
        sender: map['sender'],
        receiver: map['receiver'],
        message: map['message'],
        type: map['type'],
        time: map['time']);
  }

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'type': type,
      'time': time
    };
  }
}
