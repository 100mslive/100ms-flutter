//
//  HMSTrackExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 16/07/21.
//

import Foundation
import HMSSDK
class  HMSTrackExtension{
    
    static func toDictionary(track:HMSTrack?)->Dictionary<String,Any?>{
        
        var dict:[String:Any?]=[:]
        
        if let tempTrack = track{
            dict=[
                "track_id":tempTrack.trackId,
                "track_kind":getKindInString(kind:tempTrack.kind),
                "track_source":getSourceInString(source:tempTrack.source),
                "track_description":tempTrack.trackDescription]
        }
        return dict
    }
    static func getKindInString(kind:HMSTrackKind?)->String{
        switch kind {
        case .audio:
            return "kHMSTrackKindAudio"
        case .video:
            return "kHMSTrackKindVideo"
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
    
    static func getSourceInString(source:HMSTrackSource?)->String{
        switch source {
        case .regular:
            return "kHMSTrackSourceRegular"
        case .screen:
            return "kHMSTrackSourceScreen"
        case .plugin:
            return "kHMSTrackSourcePlugin"
        case .none:
            return ""
        @unknown default:
            return ""
        }
    }
}
