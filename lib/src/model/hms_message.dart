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

// Dart imports:
import 'dart:core';

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

class HMSMessage {
  ///[sender] id basically it is the peerId who is sending message.
  final HMSPeer? sender;

  ///[message] which you want to send.
  final String message;

  ///[type] of the [message]
  final String type;

  ///[time] at which [sender] sent the [message]
  final DateTime time;

  HMSMessageRecipient? hmsMessageRecipient;
  HMSMessage(
      {required this.sender,
      required this.message,
      required this.type,
      required this.time,
      this.hmsMessageRecipient});

  factory HMSMessage.fromMap(Map map) {
    Map messageMap = map;
    HMSPeer sender = HMSPeer.fromMap(messageMap['sender']);
    HMSMessageRecipient recipient =
        HMSMessageRecipient.fromMap(messageMap['hms_message_recipient']);
    return HMSMessage(
        sender: sender,
        message: messageMap['message'] as String,
        type: messageMap['type'] as String,
        time: HMSDateExtension().convertDate(messageMap['time']),
        hmsMessageRecipient: recipient);
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
