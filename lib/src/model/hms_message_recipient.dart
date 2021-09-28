import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_message_recipient_type.dart';

class HMSMessageRecipient {
  HMSPeer? recipientPeer;
  List<HMSRole>? recipientRoles;
  HMSMessageRecipientType hmsMessageRecipientType;

  HMSMessageRecipient({
    required this.recipientPeer, required this.recipientRoles, required this.hmsMessageRecipientType});

  Map<String, dynamic> toMap() {
    return {
      'recipientPeer': this.recipientPeer,
      'roles': this.recipientRoles,
      'hmsMessageRecipientType': this.hmsMessageRecipientType,
    };
  }

  factory HMSMessageRecipient.fromMap(Map map) {
    return HMSMessageRecipient(
      recipientPeer: map['recipient_peer']!=null ?  HMSPeer.fromMap(map['recipient_peer'] as Map): null,
      recipientRoles:map['recipient_roles']!=null ? getRoles(map['recipient_roles'] as List): null,
      hmsMessageRecipientType: HMSMessageRecipientValues.getHMSMessageRecipientFromName(map['recipient_type']),
    );
  }

  static List<HMSRole> getRoles(List map) {
    List<HMSRole> hmsRole = <HMSRole>[];
    if(map.length==0)return hmsRole;
    map.forEach((element) {
      hmsRole.add(HMSRole.fromMap(element));
    });
    return hmsRole;
  }
}