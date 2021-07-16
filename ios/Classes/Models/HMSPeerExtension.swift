//
//  HMSPeerExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 11/07/21.
//

import Foundation
import HMSSDK

class  HMSPeerExtension{
    static func toDictionary (peer:HMSPeer,update:HMSPeerUpdate)-> Dictionary<String,Any?>{
   
        var auxilaryTracks:[Dictionary<String, Any?>]=[]
      
        //TODO:: remove !
       

        
        var dict:[String:Any?] = [
            "peer_id":peer.peerID,
            "name":peer.name,
            "is_local":peer.isLocal,
            "customer_description":peer.customerDescription,
            "customer_user_id":peer.customerUserID,
            "status":getValueOfHMSPeerUpdate(update:update),
            "auxilary_tracks":auxilaryTracks
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
        
      
        return dict
    }
  
    
    
    static func getValueOfHMSPeerUpdate (update:HMSPeerUpdate)->String{
        switch update {
        case .peerJoined:
            return "peerJoined"
        case .peerLeft:
            return "peerLeft"
        case .peerKnocked:
            return "peerKnocked"
        case .audioToggled:
            return "audioToggled"
        case .videoToggled:
            return "videoToggled"
        case .roleUpdated:
            return "roleUpdated"
        case .defaultUpdate:
            return "defaultUpdate"
        @unknown default:
            return "defaultUpdate"
        }
    }
}
