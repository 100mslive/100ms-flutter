//
//  HMSRoleExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK


class HMSRoleExtension{
    
    static func toDictionary(role:HMSRole)-> Dictionary<String,Any?>{
        
        let dict:[String:Any?] = [
            "name":role.name,
            "publish_settings":HMSPublishSettingExtension.toDictionary(publishSettings:role.publishSettings),
            "subscribe_settings":HMSSubscribeSettingsExtension.toDictionary(subscribeSettings:role.subscribeSettings),
            "priority":role.priority,
            "permissions":HMSPermissionExtension.toDictionary(permission:role.permissions),
            "general_permissions":role.generalPermissions,
            "internal_plugins":role.internalPlugins,
            "external_plugins":role.externalPlugins,
        ]
        
        return dict
    }
    
    
}


