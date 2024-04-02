//
//  HMSHLSPlaybackStateExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSPlaybackStateExtension {
    static func toDictionary(_ hmsHlsPlaybackState: HMSHLSPlaybackState) -> [String: String] {
        var args = [String: String]()
        switch hmsHlsPlaybackState {
        case .playing:
            args["playback_state"] = "playing"
        case .stopped:
            args["playback_state"] = "stopped"
        case .paused:
            args["playback_state"] = "paused"
        case .buffering:
            args["playback_state"] = "buffering"
        case .failed:
            args["playback_state"] = "failed"
        default:
            args["playback_state"] = "unknown"
        }
        return args
    }
}
