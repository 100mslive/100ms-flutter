//
//  HMSSubscribeSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSSubscribeSettingsExtension {

    static func toDictionary(_ settings: HMSSubscribeSettings) -> [String: Any] {

        var dict = ["max_subs_bit_rate": settings.maxSubsBitRate] as [String: Any]

        if let roles = settings.subscribeToRoles {
            dict["subscribe_to_roles"] = roles
        }

        if let policy = settings.subscribeDegradation {
            dict["max_display_tiles"] = HMSSubscribeDegradationPolicyExtension.toDictionary(policy)
        }

        return dict
    }
}
