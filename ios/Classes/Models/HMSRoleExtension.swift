//
//  HMSRoleExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSRoleExtension {

    static func toDictionary(_ role: HMSRole) -> [String: Any] {
        [
            "name": role.name,
            "publish_settings": HMSPublishSettingsExtension.toDictionary(role.publishSettings),
            "subscribe_settings": HMSSubscribeSettingsExtension.toDictionary(role.subscribeSettings),
            "priority": role.priority,
            "permissions": HMSPermissionExtension.toDictionary(role.permissions)
        ]
    }
}
