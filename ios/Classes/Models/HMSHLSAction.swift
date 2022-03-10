//
//  HMSHLSAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSHLSAction {
    static func hlsActions(_ call: FlutterMethodCall, result: @escaping FlutterResult, hmsSDK:HMSSDK?) {
    switch call.method {
    case "hls_start_streaming":
        startHlsStreaming(call, result,hmsSDK: hmsSDK)

    case "hls_stop_streaming":
        stopHlsStreaming(call, result,hmsSDK: hmsSDK)
    default:
        result(FlutterMethodNotImplemented)
        }
    }
    
    static private func startHlsStreaming(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, hmsSDK:HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        guard let meetingUrlVariantsList = arguments["meeting_url_variants"] as? [[String: String]]
        else {
            let error = HMSCommonAction.getError(message: "Wrong Paramenter found in \(#function)",
                                 description: "Paramenter is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        var meetingUrlVariant = [HMSHLSMeetingURLVariant]()
        meetingUrlVariantsList.forEach { meetingUrlVariant.append(HMSHLSMeetingURLVariant(meetingURL: URL(string: $0["meeting_url"]!)!, metadata: $0["meta_data"] ?? "")) }

        let hlsConfig = HMSHLSConfig(variants: meetingUrlVariant)
        hmsSDK?.startHLSStreaming(config: hlsConfig) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    static private func stopHlsStreaming(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, hmsSDK:HMSSDK?) {
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
