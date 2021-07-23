import 'package:hmssdk_flutter/model/hms_peer.dart';

class RoleChangeRequest {
  final String suggestedRole;
  final HMSPeer requestedBy;
  final String token;

  factory RoleChangeRequest.fromMap(Map<String, dynamic> map) {
    return new RoleChangeRequest(
      suggestedRole: map['suggestedRole'] as String,
      requestedBy: map['requestedBy'] as HMSPeer,
      token: map['token'] as String,
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'suggestedRole': this.suggestedRole,
      'requestedBy': this.requestedBy,
      'token': this.token,
    };
  }

  RoleChangeRequest({required this.suggestedRole,required this.requestedBy,required this.token});
}
