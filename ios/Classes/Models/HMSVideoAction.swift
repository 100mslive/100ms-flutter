//
//  HMSVideoAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSVideoAction{
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
            
        case "set_playback_allowed":
            setPlaybackAllowed(call, result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func startCapturing(_ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }
        
        track.startCapturing()
        
        result(true)
    }
    
    static private func stopCapturing(_ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }
        
        track.stopCapturing()
        
        result(true)
    }
    
    static private func switchCamera(_ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        guard let peer = hmsSDK?.localPeer,
              let videoTrack = peer.videoTrack as? HMSLocalVideoTrack
        else {
            let error = HMSCommonAction.getError(message: "Local Peer not found", params: ["function": #function])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        videoTrack.switchCamera()
        
        result(nil)
    }
    
    static private func switchVideo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        
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
    
    static private func isVideoMute(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        if let peerID = arguments["peer_id"] as? String, let peer = HMSCommonAction.getPeer(by: peerID,hmsSDK: hmsSDK) {
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
    
    static private func setPlaybackAllowed(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        let allowed = arguments["allowed"] as! Bool
        
        if let localPeer = hmsSDK?.localPeer {
            if let video = localPeer.videoTrack as? HMSLocalVideoTrack {
                video.setMute(!allowed)
            }
        }
        
        if let remotePeers = hmsSDK?.remotePeers {
            remotePeers.forEach { peer in
                if let video = peer.remoteVideoTrack() {
                    video.setPlaybackAllowed(allowed)
                }
                peer.auxiliaryTracks?.forEach { track in
                    if let video = track as? HMSRemoteVideoTrack {
                        video.setPlaybackAllowed(allowed)
                    }
                }
            }
        }
        
        result(nil)
    }
}
