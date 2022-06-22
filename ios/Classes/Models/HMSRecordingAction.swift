//
//  HMSRecordingAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSRecordingAction {
    
    static func recordingActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
        case "start_rtmp_or_recording":
            startRtmpOrRecording(call, result, hmsSDK)
            
        case "stop_rtmp_and_recording":
            stopRtmpAndRecording(result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func startRtmpOrRecording(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let record = arguments["to_record"] as? Bool else {
            let error = HMSCommonAction.getError(message: "Record boolean not found", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        var meetingURL: URL?
        if let meetingURLStr = arguments["meeting_url"] as? String {
            meetingURL = URL(string: meetingURLStr)
        }
        
        var rtmpURLs: [URL]?
        if let strings = arguments["rtmp_urls"] as? [String] {
            for string in strings {
                if let url = URL(string: string) {
                    if rtmpURLs == nil {
                        rtmpURLs = [URL]()
                    }
                    rtmpURLs?.append(url)
                }
            }
        }
        
        let config = HMSRTMPConfig(meetingURL: meetingURL, rtmpURLs: rtmpURLs, record: record)
        
        hmsSDK?.startRTMPOrRecording(config: config) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    static private func stopRtmpAndRecording(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        hmsSDK?.stopRTMPAndRecording { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
}
