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
        [
            "peer": HMSPeerExtension.toDictionary(speaker.peer),
            "track": HMSTrackExtension.toDictionary(speaker.track),
            "audioLevel": speaker.level
        ]
    }
}
