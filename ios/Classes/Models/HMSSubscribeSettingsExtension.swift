//
//  HMSSubscribeSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSSubscribeSettingsExtension {
    static func toDictionary(subscribeSettings:HMSSubscribeSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["subscribe_to_roles"] = subscribeSettings.subscribeToRoles
        dict["max_subs_bit_rate"] = subscribeSettings.maxSubsBitRate
        
        if let policy = subscribeSettings.subscribeDegradation {
            dict["max_display_tiles"] = HMSSubscribeDegradationPolicyExtensin.toDictionary(policy:policy)
        }
        return dict
    }
}
