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
        
        if(peer.auxiliaryTracks != nil){
            for eachTrack:HMSTrack in peer.auxiliaryTracks!{
                    auxilaryTracks.insert(HMSTrackExtension.toDictionary(track: eachTrack),at: auxilaryTracks.count)
            }
        }
        
        
        
        let dict:[String:Any?] = [
            "peer_id":peer.peerID,
            "name":peer.name,
            "is_local":peer.isLocal,
            "role":HMSRoleExtension.toDictionary(role:peer.role!),
            "customer_description":peer.customerDescription,
            "customer_user_id":peer.customerUserID,
            "status":getValueOfHMSPeerUpdate(update:update),
            "audio_track":HMSTrackExtension.toDictionary(track:peer.audioTrack),
            "video_track":HMSTrackExtension.toDictionary(track:peer.videoTrack),
            "auxilary_tracks":auxilaryTracks
        ]
        
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
