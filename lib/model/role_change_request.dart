import 'package:hmssdk_flutter/model/hms_peer.dart';

import 'hms_role.dart';

class RoleChangeRequest {
  final HMSRole? suggestedRole;
  final HMSPeer? requestedBy;
  final String token;

  factory RoleChangeRequest.fromMap(Map<String, dynamic> map) {
    return new RoleChangeRequest(
      suggestedRole: map['suggested_role']!=null?HMSRole.fromMap(map['suggested_role']):null,
      requestedBy: map["requested_by"]!=null?HMSPeer.fromMap(map['requested_by']):null,
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
