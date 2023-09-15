//
//  HMSVideoAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSVideoAction {
    static func videoActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {
        switch call.method {
        case "switch_video":
            switchVideo(call, result, hmsSDK)

        case "switch_camera":
            switchCamera(result, hmsSDK, swiftHmssdkFlutterPlugin)

        case "is_video_mute":
            isVideoMute(call, result, hmsSDK)

        case "mute_room_video_locally":
            toggleVideoMuteAll(true, result, hmsSDK)

        case "un_mute_room_video_locally":
            toggleVideoMuteAll(false, result, hmsSDK)

        case "toggle_camera_mute_state":
            toggleCameraMuteState(result, hmsSDK, swiftHmssdkFlutterPlugin)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func switchCamera(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {
        guard let peer = hmsSDK?.localPeer,
              let videoTrack = peer.videoTrack as? HMSLocalVideoTrack
        else {
            if swiftHmssdkFlutterPlugin.previewForRoleVideoTrack != nil {
                let videoTrack = swiftHmssdkFlutterPlugin.previewForRoleVideoTrack!
                videoTrack.switchCamera()
                result(nil)
                return
            }
            result(HMSErrorExtension.getError("Local Peer not found in \(#function)"))
            return
        }

        videoTrack.switchCamera()

        result(nil)
    }

    static private func switchVideo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let shouldMute = arguments["is_on"] as? Bool,
              let peer = hmsSDK?.localPeer,
              let video = peer.videoTrack as? HMSLocalVideoTrack else {
            result(false)
            return
        }

        video.setMute(shouldMute)

        result(true)
    }

    static private func toggleCameraMuteState(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {

            guard let peer = hmsSDK?.localPeer,
              let video = peer.videoTrack as? HMSLocalVideoTrack else {
                if swiftHmssdkFlutterPlugin.previewForRoleVideoTrack != nil {
                    let videoTrack = swiftHmssdkFlutterPlugin.previewForRoleVideoTrack!
                    videoTrack.setMute(!(videoTrack.isMute()))
                    result(true)
                    return
                }
            result(false)
            return
        }

        video.setMute(!(video.isMute()))

        result(true)
    }

    static private func isVideoMute(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]

        if let peerID = arguments["peer_id"] as? String, let peer = HMSCommonAction.getPeer(by: peerID, hmsSDK: hmsSDK) {
            if let video = peer.videoTrack {
                result(video.isMute())
                return
            }
        } else {
            if let peer = hmsSDK?.localPeer, let video = peer.videoTrack {
                result(video.isMute())
                return
            }
        }

        result(false)
    }

    static private func toggleVideoMuteAll(_ shouldMute: Bool, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        if let localPeer = hmsSDK?.localPeer {
            if let video = localPeer.videoTrack as? HMSLocalVideoTrack {
                video.setMute(shouldMute)
            }
        }

        let room = hmsSDK?.room
        if room != nil {
            let videoTracks = HMSUtilities.getAllVideoTracks(in: room!) as [HMSVideoTrack]?
            videoTracks?.forEach { track in
                if track is HMSRemoteVideoTrack {
                    (track as! HMSRemoteVideoTrack).setPlaybackAllowed(!shouldMute)
                }
            }
        }
        result(nil)
    }
}
