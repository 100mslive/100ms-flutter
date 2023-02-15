//
//  HMSAudioFilePlayerNode.swift
//  hmssdk_flutter
//
//  Created by Govind on 09/08/22.
//

import Foundation
import HMSSDK

class HMSAudioFilePlayerNodeExtension {

    static func play(_ call: [AnyHashable: Any], _ playerNode: HMSAudioFilePlayerNode, _ result: @escaping FlutterResult) {
        do {
            if let fileUrlString = call["file_url"] as? String {
                try playerNode.play(fileUrl: URL(string: fileUrlString)!, loops: call["loops"] as? Bool ?? false, interrupts: call["interrupts"] as? Bool ?? false)
            } else {
                HMSErrorLogger.logError(#function, "fileUrlString is nil", "Null Error")
            }
        } catch {
            result(HMSErrorExtension.toDictionary(error))
        }
    }

    static func pause( _ playerNode: HMSAudioFilePlayerNode) {
        playerNode.pause()
    }

    static func resume( _ playerNode: HMSAudioFilePlayerNode, _ result: @escaping FlutterResult) {
        do {
            try playerNode.resume()
        } catch {
            result(HMSErrorExtension.toDictionary(error))
        }
    }

    static func stop( _ playerNode: HMSAudioFilePlayerNode) {
        playerNode.stop()
    }

    static func setVolume(_ call: [AnyHashable: Any], _ playerNode: HMSAudioFilePlayerNode) {
        if let volume = call["volume"] as? Double {
            playerNode.volume = Float(volume)
        } else {
            HMSErrorLogger.logError(#function, "Volume is nil", "Null Error")
        }
    }

    static func isPlaying(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["is_playing"] = playerNode.isPlaying
        result(dict)
    }

    static func currentDuration(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["current_duration"] = playerNode.currentTime
        result(dict)
    }

    static func duration(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["duration"] = playerNode.duration
        result(dict)
    }
}
