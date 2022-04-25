//
//  HMSPermission.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPermissionExtension {

    static func toDictionary(_ permission: HMSPermissions) -> [String: Bool] {
        [
            "change_role": permission.changeRole ?? false,
            "end_room": permission.endRoom ?? false,
            "mute_all": permission.muteAll ?? false,
            "un_mute": permission.unmute ?? false,
            "mute": permission.mute ?? false,
            "remove_others": permission.removeOthers ?? false,
            "stop_presentation": permission.stopPresentation ?? false
        ]
    }
}
