//
//  HMSMessageExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSMessageExtension{
    static func toDictionary(message: HMSMessage) -> Dictionary<String,Any?>{
        var dict:[String:Any?]=[:]
        
        dict["message"] = message.message
        if let sender = message.sender {
            dict["sender"] = HMSPeerExtension.toDictionary(peer:sender)
        }
        dict["time"] = "\(message.time)"
        dict["type"] = message.type
        
        dict["hms_message_recipient"] = HMSMessageRecipientExtension.toDictionary(receipient: message.recipient)
        
        return ["message": dict]
    }
}
