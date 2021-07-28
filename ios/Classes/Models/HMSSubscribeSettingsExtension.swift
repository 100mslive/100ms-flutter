//
//  HMSSubscribeSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
//

import Foundation
import HMSSDK

class  HMSSubscribeSettingsExtension {
    static func toDictionary(subscribeSettings:HMSSubscribeSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["subscribe_to_roles"] = subscribeSettings.subscribeToRoles
        dict["max_subs_bit_rate"] = subscribeSettings.maxSubsBitRate
        dict["max_display_tiles"] = subscribeSettings.maxDisplayTiles
        return dict
    }
}
