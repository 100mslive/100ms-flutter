//
//  HMSPeerExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPeerExtension{
    static func toDictionary (peer:HMSPeer)-> Dictionary<String,Any?>{
   
        var auxilaryTracks:[Dictionary<String, Any?>]=[]
              
        var dict:[String:Any?] = [
            "peer_id":peer.peerID,
            "name":peer.name,
            "is_local":peer.isLocal,
            "customer_description":peer.customerDescription ?? "",
            "customer_user_id":peer.customerUserID ?? "",
        ]
        
        if let role = peer.role{
            dict["role"]=HMSRoleExtension.toDictionary(role:role)
        }
        if let audioTrack = peer.audioTrack{
            dict["audio_track"]=HMSTrackExtension.toDictionary(track:audioTrack)
        }
        
        if let videoTrack = peer.videoTrack{
            dict["video_track"]=HMSTrackExtension.toDictionary(track:videoTrack)
        }
        
        if let tracks = peer.auxiliaryTracks {
            for eachTrack:HMSTrack in tracks{
                    auxilaryTracks.insert(HMSTrackExtension.toDictionary(track: eachTrack),at: auxilaryTracks.count)
            }
        }
        
        dict["auxilary_tracks"] = auxilaryTracks
        
      
        return dict
    }
  
    
    
    static func getValueOfHMSPeerUpdate (update:HMSPeerUpdate)->String{
        switch update {
        case .peerJoined:
            return "peerJoined"
        case .peerLeft:
            return "peerLeft"
        case .roleUpdated:
            return "roleUpdated"
        case .defaultUpdate:
            return "defaultUpdate"
        @unknown default:
            return "defaultUpdate"
        }
    }
}
