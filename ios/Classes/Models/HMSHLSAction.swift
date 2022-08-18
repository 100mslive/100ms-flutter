//
//  HMSHLSAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSHLSAction {
    static func hlsActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        switch call.method {
        case "hls_start_streaming":
            startHlsStreaming(call, result, hmsSDK)
            
        case "hls_stop_streaming":
            stopHlsStreaming(call, result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func startHlsStreaming(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        let meetingUrlVariantsList = arguments["meeting_url_variants"] as? [[String: String]]? ?? nil
        let recordingConfig = arguments["recording_config"] as? [String:Bool]? ?? nil
       
        var meetingUrlVariant: [HMSHLSMeetingURLVariant]? = nil
        var hmsHLSRecordingConfig: HMSHLSRecordingConfig? = nil
        
        if meetingUrlVariantsList != nil
        {
            meetingUrlVariant = [HMSHLSMeetingURLVariant]()
            meetingUrlVariantsList!.forEach { meetingUrlVariant!.append(HMSHLSMeetingURLVariant(meetingURL: URL(string: $0["meeting_url"]!)!, metadata: $0["meta_data"] ?? "")) }
        }
        
        if recordingConfig != nil
        {
            hmsHLSRecordingConfig = HMSHLSRecordingConfig(singleFilePerLayer: recordingConfig!["single_file_per_layer"]!, enableVOD: recordingConfig!["video_on_demand"]!)
        }
        
        var hlsConfig:HMSHLSConfig? = nil
        if(meetingUrlVariant != nil || hmsHLSRecordingConfig != nil){
            hlsConfig = HMSHLSConfig(variants: meetingUrlVariant,recording: hmsHLSRecordingConfig)
        }
        hmsSDK?.startHLSStreaming(config: hlsConfig) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    static private func stopHlsStreaming(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as? [AnyHashable: Any]
        let config = getHLSConfig(from: arguments)
        hmsSDK?.stopHLSStreaming(config: config) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    static private func getHLSConfig(from arguments: [AnyHashable: Any]?) -> HMSHLSConfig? {
        guard let meetingUrlVariantsList = arguments?["meeting_url_variants"] as? [[String: String]] else {
            return nil
        }
        var meetingUrlVariant = [HMSHLSMeetingURLVariant]()
        meetingUrlVariantsList.forEach { meetingUrlVariant.append(HMSHLSMeetingURLVariant(meetingURL: URL(string: $0["meeting_url"]!)!, metadata: $0["meta_data"] ?? "")) }
        
        return HMSHLSConfig(variants: meetingUrlVariant)
    }
}
