//
//  HMSStreamingStates.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 20/12/21.
//

import Foundation
import HMSSDK

class HMSStreamingStateExtension {

    static func toDictionary(rtmp: HMSRTMPStreamingState) -> [String: Any] {
        var dict = [String: Any]()

        dict["running"] = rtmp.running

        if let error = rtmp.error {
            dict.merge(HMSErrorExtension.toDictionary(error)) { (_, new) in new }
        }

        return dict
    }

    static func toDictionary(server: HMSServerRecordingState) -> [String: Any] {

        var dict = [String: Any]()

        dict["running"] = server.running

        if let error = server.error {
            dict.merge(HMSErrorExtension.toDictionary(error)) { (_, new) in new }
        }

        return dict
    }

    static func toDictionary(browser: HMSBrowserRecordingState) -> [String: Any] {

        var dict = [String: Any]()

        dict["running"] = browser.running

        if let error = browser.error {
            dict.merge(HMSErrorExtension.toDictionary(error)) { (_, new) in new }
        }

        return dict
    }

    static func toDictionary(hlsVariant: HMSHLSStreamingState) -> [String: Any] {
        var dict = [String: Any]()

        dict["running"] = hlsVariant.running
        var args = [Any]()
        hlsVariant.variants.forEach { variant in
            args.append(HMSHLSVariantExtension.toDictionary(variant))
        }
        dict["variants"]=args

        return dict
    }
}
