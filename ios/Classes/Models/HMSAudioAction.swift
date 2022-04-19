//
//  HMSAudioAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSAudioAction{
    static func audioActions(_ call: FlutterMethodCall, result: @escaping FlutterResult,hmsSDK:HMSSDK?) {
    switch call.method {
    case "switch_audio":
        switchAudio(call, result,hmsSDK: hmsSDK)

    case "is_audio_mute":
        isAudioMute(call, result,hmsSDK: hmsSDK)

    case "mute_all":
        toggleAudioMuteAll(result, shouldMute: true,hmsSDK: hmsSDK)

    case "un_mute_all":
        toggleAudioMuteAll(result, shouldMute: false,hmsSDK: hmsSDK)

    case "set_volume":
        setVolume(call, result,hmsSDK: hmsSDK)
    default:
        result(FlutterMethodNotImplemented)
        }
    }
    
    static private func switchAudio(_ call: FlutterMethodCall, _ result: FlutterResult,hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let shouldMute = arguments["is_on"] as? Bool,
              let peer = hmsSDK?.localPeer,
              let audio = peer.audioTrack as? HMSLocalAudioTrack else {
                  result(false)
                  return
              }

        audio.setMute(shouldMute)

        result(true)
    }

    static private func isAudioMute(_ call: FlutterMethodCall, _ result: FlutterResult,hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        if let peerID = arguments["peer_id"] as? String, let peer = HMSCommonAction.getPeer(by: peerID,hmsSDK: hmsSDK) {
            if let audio = peer.audioTrack {
                result(audio.isMute())
                return
            }
        } else {
            if let peer = hmsSDK?.localPeer, let audio = peer.audioTrack {
                result(audio.isMute())
                return
            }
        }

        result(false)
    }

    static private func toggleAudioMuteAll(_ result: FlutterResult, shouldMute: Bool,hmsSDK:HMSSDK?) {

        hmsSDK?.remotePeers?.forEach { peer in
            if let audio = peer.remoteAudioTrack() {
                audio.setPlaybackAllowed(!shouldMute)
            }
            peer.auxiliaryTracks?.forEach { track in
                if let audio = track as? HMSRemoteAudioTrack {
                    audio.setPlaybackAllowed(!shouldMute)
                }
            }
        }

        result(nil)
    }

    static private func setVolume(_ call: FlutterMethodCall, _ result: FlutterResult,hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let volume = arguments["volume"] as? Double,
              let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getTrack(for: trackID, in: hmsSDK!.room!)
        else {
            let error = HMSCommonAction.getError(message: "Invalid arguments passed in \(#function)",
                                 description: "Message is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }

        if let remoteAudio = track as? HMSRemoteAudioTrack {
            remoteAudio.setVolume(volume)
            result(nil)
            return
        }

        let error = HMSCommonAction.getError(message: "Invalid arguments passed in \(#function)",
                             params: ["function": #function, "arguments": arguments])
        result(HMSErrorExtension.toDictionary(error))
    }
}
