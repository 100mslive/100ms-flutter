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
                guard let fileURL = call["file_url"] as? String else{
                    HMSErrorLogger.returnArgumentsError(errorMessage: "Invalid file")
                    HMSErrorLogger.returnHMSException(#function,"Error in playing the file", "File Error",result)
                    return
                }
                guard let url = URL(string: fileURL) else{
                    HMSErrorLogger.returnArgumentsError(errorMessage: "File URL is invalid")
                    HMSErrorLogger.returnHMSException(#function,"Error in playing the file", "File Error",result)
                    return
                }
        do{
            try
                playerNode.play(fileUrl: url, loops: call["loops"] as? Bool ?? false, interrupts: call["interrupts"] as? Bool ?? false)
            result(HMSResultExtension.toDictionary(true,nil))
        } catch {
            result(HMSResultExtension.toDictionary(false,HMSErrorExtension.toDictionary(error)))
        }
    }

    static func pause( _ playerNode: HMSAudioFilePlayerNode,_ result: @escaping FlutterResult) {
        playerNode.pause()
        result(HMSResultExtension.toDictionary(true,nil))
    }

    static func resume( _ playerNode: HMSAudioFilePlayerNode, _ result: @escaping FlutterResult) {
        do {
            try playerNode.resume()
            result(HMSResultExtension.toDictionary(true,nil))
        } catch {
            result(HMSResultExtension.toDictionary(false,HMSErrorExtension.toDictionary(error)))
        }
    }

    static func stop( _ playerNode: HMSAudioFilePlayerNode,_ result: @escaping FlutterResult) {
        playerNode.stop()
        result(HMSResultExtension.toDictionary(true,nil))
    }

    static func setVolume(_ call: [AnyHashable: Any], _ playerNode: HMSAudioFilePlayerNode,_ result: @escaping FlutterResult) {
        playerNode.volume = Float(call["volume"] as! Double)
        result(HMSResultExtension.toDictionary(true,nil))
    }

    static func isPlaying(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["is_playing"] = playerNode.isPlaying
        result(HMSResultExtension.toDictionary(true,dict))
    }

    static func currentDuration(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["current_duration"] = playerNode.currentTime
        result(HMSResultExtension.toDictionary(true,dict))
    }

    static func duration(_ playerNode: HMSAudioFilePlayerNode, _ result: FlutterResult) {
        var dict = [String: Any]()
        dict["duration"] = playerNode.duration
        result(HMSResultExtension.toDictionary(true,dict))
    }
}
