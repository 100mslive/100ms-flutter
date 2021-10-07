//
//  HMSTrackExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSTrackExtension {
    
    static func toDictionary(track: HMSTrack) -> [String: Any] {
        
        let dict = [
            "track_id": track.trackId,
            "track_kind": getKindInString(kind:track.kind),
            "track_source": track.source.uppercased(),
            "track_description": track.trackDescription,
            "track_mute" : track.isMute()
        ] as [String: Any]
        
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
    
    static func getTrackUpdateInString(trackUpdate: HMSTrackUpdate) -> String {
        
        switch trackUpdate {    
        case .trackAdded :return "trackAdded"
        case .trackDegraded: return "trackDegraded"
        case .trackDescriptionChanged: return "trackDescriptionChanged"
        case .trackMuted: return "trackMuted"
        case .trackRemoved: return "trackRemoved"
        case .trackRestored: return "trackRestored"
        case .trackUnmuted: return "trackUnmuted"
        default:
            return ""
        }
    }
}
