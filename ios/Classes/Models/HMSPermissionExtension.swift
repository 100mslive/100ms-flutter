//
//  HMSPermission.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPermissionExtension {
    static func toDictionary(permission:HMSPermissions)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
//        dict["ask_to_un_mute"] = permission.askToUnmute
        dict["change_role"]=permission.changeRole
        dict["end_room"]=permission.endRoom
        dict["mute_all"]=permission.muteAll
//        dict["mute_selective"]=permission.muteSelective
        dict["remove_others"]=permission.removeOthers
        dict["stop_presentation"]=permission.stopPresentation
        
        return dict
    }
}
