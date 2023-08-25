//
//  HMSAudioAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSAudioAction {
    static func audioActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {
        switch call.method {
        case "switch_audio":
            switchAudio(call, result, hmsSDK)

        case "is_audio_mute":
            isAudioMute(call, result, hmsSDK)

        case "mute_room_audio_locally":
            toggleAudioMuteAll(result, hmsSDK, shouldMute: true)

        case "un_mute_room_audio_locally":
            toggleAudioMuteAll(result, hmsSDK, shouldMute: false)

        case "set_volume":
            setVolume(call, result, hmsSDK)

        case "toggle_mic_mute_state":
            toggleMicMuteState(result, hmsSDK, swiftHmssdkFlutterPlugin)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func switchAudio(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
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

    static private func toggleMicMuteState(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {

            guard let peer = hmsSDK?.localPeer,
              let audio = peer.audioTrack as? HMSLocalAudioTrack else {
                if swiftHmssdkFlutterPlugin.previewForRoleAudioTrack != nil {
                    let audioTrack = swiftHmssdkFlutterPlugin.previewForRoleAudioTrack!
                    audioTrack.setMute(!(audioTrack.isMute()))
                    result(true)
                    return
                }
            result(false)
            return
        }

        audio.setMute(!(audio.isMute()))

        result(true)
    }

    static private func isAudioMute(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        if let peerID = arguments["peer_id"] as? String, let peer = HMSCommonAction.getPeer(by: peerID, hmsSDK: hmsSDK) {
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

    static private func toggleAudioMuteAll(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, shouldMute: Bool) {

        let room = hmsSDK?.room
        if room != nil {
            let audioTracks = HMSUtilities.getAllAudioTracks(in: room!) as [HMSAudioTrack]?

            audioTracks?.forEach { track in
                if track is HMSRemoteAudioTrack {
                    (track as! HMSRemoteAudioTrack).setPlaybackAllowed(!shouldMute)
                }
            }
        }
        result(nil)
    }

    static private func setVolume(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let volume = arguments["volume"] as? Double,
              let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getTrack(for: trackID, in: hmsSDK!.room!)
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }

        if let remoteAudio = track as? HMSRemoteAudioTrack {
            remoteAudio.setVolume(volume)
            result(nil)
            return
        }
        result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
    }
}
