///100ms HMSMessage
///
///To use, import package:`hmssdk_flutter/model/hms_message.dart`.
///
///[HMSMessage] contains the message and related properties.
///
///What's a video call without being able to send messages to each other too? 100ms supports chat for every video/audio room you create.
///You can see an example of every type of message (of the types below) being sent and displayed in the advanced sample app.
///
/// You can use chat feature using this HMSMessage object it will contains each message with other relevant information.
import 'dart:core';

class HMSMessage {
  ///[sender] id basically it is the peerId who is sending message.
  final String sender;
  ///[message] which you want to send.
  final String message;
  ///[type] of the [message]
  final String type;

  ///[time] at which [sender] sent the [message]
  final String time;

  HMSMessage({
    required this.sender,
    required this.message,
    required this.type,
    required this.time,
  });

  factory HMSMessage.fromMap(Map map) {
    print(map.toString());
    return HMSMessage(
      sender: map['sender'] as String,
      message: map['message'] as String,
      type: map['type'] as String,
      time: map['time'] as String,
    );
  }

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'sender': sender,
      'message': message,
      'type': type,
      'time': time,
    };
  }
}
