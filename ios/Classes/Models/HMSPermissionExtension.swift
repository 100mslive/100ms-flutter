//
//  HMSPermission.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPermissionExtension {
    
    static func toDictionary(_ permission: HMSPermissions) -> [String: Any?] {
        [
            "change_role": permission.changeRole,
            "end_room": permission.endRoom,
            "mute_all": permission.muteAll,
            "un_mute": permission.unmute,
            "mute": permission.mute,
            "remove_others": permission.removeOthers,
            "stop_presentation": permission.stopPresentation
        ]
        
//        "changeRoleForce"
//        "rtmp"
//        "recording"
    }
}
