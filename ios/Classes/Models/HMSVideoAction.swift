//
//  HMSVideoAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSVideoAction {
    static func videoActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
        case "switch_video":
            switchVideo(call, result, hmsSDK)

        case "switch_camera":
            switchCamera(result, hmsSDK)

        case "start_capturing":
            startCapturing(result, hmsSDK)

        case "stop_capturing":
            stopCapturing(result, hmsSDK)

        case "is_video_mute":
            isVideoMute(call, result, hmsSDK)

        case "mute_room_video_locally":
            toggleVideoMuteAll(true,result,hmsSDK)
        
        case "un_mute_room_video_locally":
            toggleVideoMuteAll(false,result,hmsSDK)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func startCapturing(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }

        track.startCapturing()

        result(true)
    }

    static private func stopCapturing(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }

        track.stopCapturing()

        result(true)
    }

    static private func switchCamera(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let videoTrack = peer.videoTrack as? HMSLocalVideoTrack
        else {
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
        if(room != nil){
            let videoTracks = HMSUtilities.getAllVideoTracks(in: room!) as [HMSVideoTrack]?
            videoTracks?.forEach{track in
                if(track is HMSRemoteVideoTrack){
                    (track as! HMSRemoteVideoTrack).setPlaybackAllowed(!shouldMute)
                }
            }
        }
        result(nil)
    }
}
