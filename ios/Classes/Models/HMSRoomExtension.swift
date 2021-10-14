//
//  HMSRoomExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSRoomExtension {
    static func toDictionary(hmsRoom:HMSRoom)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
        var peers:[Dictionary<String, Any?>]=[]
        
        dict["id"] = hmsRoom.roomID
        dict["meta_data"] = hmsRoom.metaData
        dict["name"] = hmsRoom.name
    
        for peer in hmsRoom.peers {
            peers.append(HMSPeerExtension.toDictionary(peer: peer))
        }
        dict["peers"] = peers
        
        return dict
    }
    
}
