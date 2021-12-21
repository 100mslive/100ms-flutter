//
//  HMSStreamingStates.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 20/12/21.
//

import Foundation
import HMSSDK

class HMSStreamingStateExtension {
    
    static func toDictionary(rtmp: HMSRTMPStreamingState) -> Dictionary<String,Any?> {
        var dict = [String: Any]()
        
        dict["running"] = rtmp.running
        
        if let error = rtmp.error {
            dict["error"] = HMSErrorExtension.toDictionary(error)
        }
        
        return dict
    }
    
    
    static func toDictionary(server: HMSServerRecordingState) -> Dictionary<String,Any?> {
        
        var dict = [String: Any]()
        
        dict["running"] = server.running
        
        if let error = server.error {
            dict["error"] = HMSErrorExtension.toDictionary(error)
        }
        
        return dict
    }
    
    
    static func toDictionary(browser: HMSBrowserRecordingState) -> Dictionary<String,Any?> {
        
        var dict = [String: Any]()
        
        dict["running"] = browser.running
        
        if let error = browser.error {
            dict["error"] = HMSErrorExtension.toDictionary(error)
        }
        
        return dict
    }
}
