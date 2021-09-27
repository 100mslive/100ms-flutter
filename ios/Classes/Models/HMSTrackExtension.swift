//
//  HMSTrackExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK
class  HMSTrackExtension{
    
    static func toDictionary(track:HMSTrack?)->Dictionary<String,Any?>{
        
        var dict:[String:Any?]=[:]
        
        if let tempTrack = track{
            dict = [
                "track_id": tempTrack.trackId,
                "track_kind": getKindInString(kind:tempTrack.kind),
                "track_source": getSourceInString(source:tempTrack.source),
                "track_description": tempTrack.trackDescription,
                "track_mute" : tempTrack.isMute()
                ]
        }
        return dict
    }
    static func getKindInString(kind: HMSTrackKind) -> String {
        switch kind {
        case .audio:
            return "kHMSTrackKindAudio"
        case .video:
            return "kHMSTrackKindVideo"
        @unknown default:
            return ""
        }
    }
    
    static func getSourceInString(source: HMSTrackSource) -> String {
        switch source {
        case .regular:
            return "kHMSTrackSourceRegular"
        case .screen:
            return "kHMSTrackSourceScreen"
        case .plugin:
            return "kHMSTrackSourcePlugin"
        @unknown default:
            return ""
        }
    }
                
    static func getTrackUpdateInString(trackUpdate:HMSTrackUpdate?)->String{
        switch trackUpdate {
    
        case .trackAdded :return "trackAdded"
        case.trackDegraded: return "trackDegraded"
        case .trackDescriptionChanged: return "trackDescriptionChanged"
        case .trackMuted: return "trackMuted"
        case .trackRemoved: return "trackRemoved"
        case .trackRestored: return "trackRestored"
        case .trackUnmuted: return "trackUnmuted"
        
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
}
