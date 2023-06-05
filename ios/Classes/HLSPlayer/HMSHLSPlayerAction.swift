//
//  HMSHLSPlayerAction.swift
//  DKImagePickerController
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSSDK

class HMSHLSPlayerAction {

    static let HLS_PLAYER_METHOD = "HLS_PLAYER"
    static let METHOD_CALL = "method_name"

    static func hlsPlayerAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "start_hls_player":
            start(result)

        case "stop_hls_player":
            stop(result)

        case "pause_hls_player":
            pause(result)

        case "resume_hls_player":
            resume(result)

        case "seek_to_live_position":
            seekToLivePosition(result)

        case "seek_forward":
            seekForward(call, result)

        case "seek_backward":
            seekBackward(call, result)

        case "set_hls_player_volume":
            setVolume(call, result)

        case "add_hls_stats_listener":
            addHLSStatsListener(result)

        case "remove_hls_stats_listener":
            removeHLSStatsListener(result)

        default:
            result(FlutterMethodNotImplemented)
        }

    }

    static private func start(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "start_hls_player"])
        result(nil)
    }

    static private func stop(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "stop_hls_player"])
        result(nil)
    }

    static private func pause(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "pause_hls_player"])
        result(nil)
    }

    static private func resume(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "resume_hls_player"])
        result(nil)
    }

    static private func seekToLivePosition(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "seek_to_live_position"])
        result(nil)
    }

    static private func addHLSStatsListener(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "add_hls_stats_listener"])
        result(nil)
    }

    static private func removeHLSStatsListener(_ result: @escaping FlutterResult) {
        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "remove_hls_stats_listener"])
        result(nil)
    }

    static private func seekForward(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let seconds = call.arguments as? Int else {
            HMSErrorLogger.logError(#function, "seconds parameter is null", "NULL_ERROR")
            result(nil)
            return
        }

        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "seek_forward", "seconds": seconds])
        result(nil)
    }

    static private func seekBackward(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let seconds = call.arguments as? Int else {
            HMSErrorLogger.logError(#function, "seconds parameter is null", "NULL_ERROR")
            result(nil)
            return
        }

        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "seek_backward", "seconds": seconds])
        result(nil)
    }

    static private func setVolume(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let volume = call.arguments as? Int else {
            HMSErrorLogger.logError(#function, "volume parameter is null", "NULL_ERROR")
            result(nil)
            return
        }

        NotificationCenter.default.post(name: NSNotification.Name(HLS_PLAYER_METHOD), object: nil, userInfo: [METHOD_CALL: "set_hls_player_volume", "volume": volume])
        result(nil)
    }
}
