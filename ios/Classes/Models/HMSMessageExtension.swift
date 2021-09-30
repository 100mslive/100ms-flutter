//
//  HMSMessageExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSMessageExtension{
    static func toDictionary(message : HMSMessage) -> Dictionary<String,Any?>{
        var dict:[String:Any?]=[:]
        
        dict["message"] = message.message
//        dict["receiver"] = message.receiver
        dict["sender"] = message.sender
        dict["time"] = message.time
        dict["type"] = message.type
        
        return dict
    }
}
