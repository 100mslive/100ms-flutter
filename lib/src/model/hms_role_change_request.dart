// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[HMSRoleChangeRequest] contains the info about the role suggested recieved by you
///
///you can accept the role change or you can decline it.
class HMSRoleChangeRequest {
  final HMSRole suggestedRole;
  final HMSPeer? suggestedBy;

  HMSRoleChangeRequest(
      {required this.suggestedRole, required this.suggestedBy});

  factory HMSRoleChangeRequest.fromMap(Map map) {
    HMSPeer? requestedBy;
    HMSRole suggestedRole = HMSRole.fromMap(map['suggested_role']);

    if (map['requested_by'] != null) {
      requestedBy = HMSPeer.fromMap(map['requested_by']);
    }

    return HMSRoleChangeRequest(
        suggestedRole: suggestedRole, suggestedBy: requestedBy);
  }
}
