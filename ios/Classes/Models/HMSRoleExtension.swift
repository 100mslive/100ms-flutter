//
//  HMSRoleExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 15/07/21.
//

import Foundation
import HMSSDK


class HMSRoleExtension{
    
    static func toDictionary(role:HMSRole)-> Dictionary<String,Any?>{
        
        let dict:[String:Any?] = [
            "name":role.name,
            "publish_settings":"role.publishSettings",
            "subscribe_settings":"role.subscribeSettings",
            "priority":role.priority,
            "general_permissions":"role.generalPermissions",
            "internal_plugins":"role.internalPlugins",
            "external_plugins":"role.externalPlugins",
        ]
        
        return dict
    }
}
