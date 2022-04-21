// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSMessageRecipient
///
///[HMSMessageRecipient] contains the value of recipient Peer[HMSPeer],list of recipient Roles[HMSRole] and Message Recipient Type[HMSMessageRecipientType].
class HMSMessageRecipient {
  HMSPeer? recipientPeer;
  List<HMSRole>? recipientRoles;
  HMSMessageRecipientType hmsMessageRecipientType;

  HMSMessageRecipient(
      {required this.recipientPeer,
      required this.recipientRoles,
      required this.hmsMessageRecipientType});

  Map<String, dynamic> toMap() {
    return {
      'recipientPeer': this.recipientPeer,
      'roles': this.recipientRoles,
      'hmsMessageRecipientType': this.hmsMessageRecipientType,
    };
  }

  factory HMSMessageRecipient.fromMap(Map map) {
    HMSPeer? peer;
    if (map['recipient_peer'] != null) {
      peer = HMSPeer.fromMap(map['recipient_peer']);
    }

    List<HMSRole>? roles;
    if (map['recipient_roles'] != null) {
      roles = getRoles(map['recipient_roles']);
    }

    return HMSMessageRecipient(
      recipientPeer: peer,
      recipientRoles: roles,
      hmsMessageRecipientType:
          HMSMessageRecipientValues.getHMSMessageRecipientFromName(
              map['recipient_type']),
    );
  }

  static List<HMSRole> getRoles(List list) {
    List<HMSRole> hmsRole = <HMSRole>[];
    if (list.length == 0) return hmsRole;
    list.forEach((element) {
      hmsRole.add(HMSRole.fromMap(element));
    });
    return hmsRole;
  }
}
