import 'package:hmssdk_flutter/exceptions/hms_in_sufficient_data.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_role.dart';

class HMSRoleChangeRequest {
  final HMSRole suggestedRole;
  final HMSPeer suggestedBy;

  HMSRoleChangeRequest(
      {required this.suggestedRole, required this.suggestedBy});

  factory HMSRoleChangeRequest.fromMap(Map map) {
    HMSPeer? peer;
    HMSRole role;

    if (map.containsKey('requested_by')) {
      peer = HMSPeer.fromMap(map['requested_by']);
    } else {
      throw HMSInSufficientDataException(message: 'No data found for Peer');
    }
    if (map.containsKey('suggested_role')) {
      role = HMSRole.fromMap(map['suggested_role']);
    } else {
      throw HMSInSufficientDataException(message: 'No data found for Role');
    }

    return HMSRoleChangeRequest(suggestedRole: role, suggestedBy: peer);
  }
}
