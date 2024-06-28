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
            "browser_recording": permission.browserRecording ?? false,
            "change_role": permission.changeRole ?? false,
            "end_room": permission.endRoom ?? false,
            "hls_streaming": permission.hlsStreaming ?? false,
            "mute": permission.mute ?? false,
            "remove_others": permission.removeOthers ?? false,
            "rtmp_streaming": permission.rtmpStreaming ?? false,
            "un_mute": permission.unmute ?? false,
            "poll_read": permission.pollRead ?? false,
            "poll_write": permission.pollWrite ?? false,
            "whiteboard_permission": getMapFromHMSWhiteboardPermission(hmsWhiteboardPermission: permission.whiteboard),
            "transcription_permission": getMapFromHMSTranscriptionPermissionList(hmsTranscriptionPermissions: permission.transcriptions)
        ]
    }

    private static func getMapFromHMSWhiteboardPermission(hmsWhiteboardPermission: HMSWhiteboardPermissions?) -> [String: Any?]? {

        guard let hmsWhiteboardPermission = hmsWhiteboardPermission
        else {
            return nil
        }

        var permission = [String: Any?]()

        permission["admin"] = hmsWhiteboardPermission.admin
        permission["write"] = hmsWhiteboardPermission.write
        permission["read"] = hmsWhiteboardPermission.read

        return permission
    }
    
    private static func getMapFromHMSTranscriptionPermissionList(hmsTranscriptionPermissions: [HMSTranscriptionPermissions]?) -> [[String:Any?]]?{
        
        
        guard let hmsTranscriptionPermissions = hmsTranscriptionPermissions
        else{
            return nil
        }
        
        var transcriptionPermissions = [[String:Any?]]()
        
        hmsTranscriptionPermissions.forEach{
            var permission = [String:Any?]()
            
            permission["mode"] = $0.mode
            permission["admin"] = $0.admin
            transcriptionPermissions.append(permission)
        }
        
        return transcriptionPermissions
    }
    

}
