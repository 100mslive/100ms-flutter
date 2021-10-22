//
//  HMSSpeakerExtension.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 21/10/21.
//

import Foundation
import HMSSDK

class HMSSpeakerExtension {
    static func toDictionary(_ speaker: HMSSpeaker) -> [String: Any] {
        let dict = [
            "peer": HMSPeerExtension.toDictionary(peer: speaker.peer),
            "track": HMSTrackExtension.toDictionary(track: speaker.track),
            "audioLevel": speaker.level
        ] as [String: Any]
        
        return dict
    }
}
