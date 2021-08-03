//
//  HMSRoomExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 31/07/21.
//

import Foundation
import HMSSDK

class  HMSRoomExtension {
    static func toDictionary(hmsRoom:HMSRoom)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
        var peers:[Dictionary<String, Any?>]=[]
        
        dict["id"] = hmsRoom.id
        dict["meta_data"] = hmsRoom.metaData
        dict["name"] = hmsRoom.name
    
        for peer in hmsRoom.peers{
            peers.insert(HMSPeerExtension.toDictionary(peer: peer), at: peers.count)
        }
        dict["peers"] = peers
        
        return dict
    }
    
}
