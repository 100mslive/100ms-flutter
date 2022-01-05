//
//  HMSSubscribeSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSSubscribeSettingsExtension {
    
    static func toDictionary(_ settings: HMSSubscribeSettings) -> [String: Any?] {
        [
            "subscribe_to_roles": settings.subscribeToRoles,
            "max_subs_bit_rate": settings.maxSubsBitRate,
            "max_display_tiles": HMSSubscribeDegradationPolicyExtension.toDictionary(settings.subscribeDegradation)
        ]
    }
}
