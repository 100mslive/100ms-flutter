//
//  HMSRoomExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSRoomExtension {
    static func toDictionary(_ room: HMSRoom) -> Dictionary<String,Any?> {
        var dict:Dictionary<String, Any?> = [:]
        
        var peers:[Dictionary<String, Any?>]=[]
        
        if let roomID = room.roomID {
            dict["id"] = roomID
        }
        
        if let data = room.metaData {
            dict["meta_data"] = data
        }
        
        if let name = room.name {
            dict["name"] = name
        }
    
        for peer in room.peers {
            peers.append(HMSPeerExtension.toDictionary(peer: peer))
        }
        dict["peers"] = peers
        
        dict["rtmp_streaming_state"] = HMSStreamingStateExtension.toDictionary(rtmp: room.rtmpStreamingState)

        dict["browser_recording_state"] = HMSStreamingStateExtension.toDictionary(browser: room.browserRecordingState)

        dict["server_recording_state"] = HMSStreamingStateExtension.toDictionary(server: room.serverRecordingState)
        
        return dict
    }
}
