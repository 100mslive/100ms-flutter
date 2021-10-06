//
//  HMSMessageRecipientExtension.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 30/09/21.
//

import Foundation
import HMSSDK

class HMSMessageRecipientExtension {
    static func toDictionary(receipient: HMSMessageRecipient) -> [String: Any] {
        var dict = [String: Any]()
        
        if let peer = receipient.peerRecipient {
            dict["recipient_peer"] = HMSPeerExtension.toDictionary(peer: peer)
        }
        
        if let roles = receipient.rolesRecipient {
            var roleExtension = [Any]()
            for role in roles {
                roleExtension.append(HMSRoleExtension.toDictionary(role: role))
            }
            dict["recipient_roles"] = roleExtension
        }
        
        dict["recipient_type"] = getString(from: receipient.type)
        
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
