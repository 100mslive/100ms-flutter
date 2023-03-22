//
//  HMSMessageRecipientExtension.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 30/09/21.
//

import Foundation
import HMSSDK

class HMSMessageRecipientExtension {

    static func toDictionary(_ receipient: HMSMessageRecipient) -> [String: Any] {

        var dict = [String: Any]()

        dict["recipient_type"] = getString(from: receipient.type)

        if let peer = receipient.peerRecipient {
            dict["recipient_peer"] = HMSPeerExtension.toDictionary(peer)
        }

        if let roles = receipient.rolesRecipient {
            var roleExtension = [Any]()
            roles.forEach { roleExtension.append(HMSRoleExtension.toDictionary($0)) }
            dict["recipient_roles"] = roleExtension
        }

        return dict
    }

    static func getString(from type: HMSMessageRecipientType) -> String {
        switch type {
        case .broadcast:
            return "broadCast"
        case .peer:
            return "peer"
        case .roles:
            return "roles"
        default:
            return "defaultRecipient"
        }
    }
}
