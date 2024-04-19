//
//  HMSPollResponsePeerInfoExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 20/02/24.
//

import Foundation
import HMSSDK

class HMSPollResponsePeerInfoExtension {

    static func toDictionary(hmsPollResponsePeerInfo: HMSPollResponsePeerInfo?) -> [String: Any?]? {

        if let hmsPollResponsePeerInfo {

            var map = [String: Any?]()

            map["hash"] = hmsPollResponsePeerInfo.userHash
            map["peer_id"] = hmsPollResponsePeerInfo.peerID
            map["user_id"] = hmsPollResponsePeerInfo.customerUserID
            map["username"] = hmsPollResponsePeerInfo.userName

            return map
        } else {
            return nil
        }

    }

}
