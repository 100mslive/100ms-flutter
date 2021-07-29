//
//  HMSPermission.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
//

import Foundation
import HMSSDK

class  HMSPermissionExtension {
    static func toDictionary(permission:HMSPermissions)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
        dict["ask_to_un_mute"] = permission.askToUnmute
        dict["change_role"]=permission.changeRole
        dict["end_room"]=permission.endRoom
        dict["mute_all"]=permission.muteAll
        dict["mute_selective"]=permission.muteSelective
        dict["remove_others"]=permission.removeOthers
        dict["stop_presentation"]=permission.stopPresentation
        
        return dict
    }
}
