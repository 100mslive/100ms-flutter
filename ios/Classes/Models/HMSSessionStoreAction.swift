//
//  HMSSessionStoreAction.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 25/04/23.
//

import Foundation
import HMSSDK

class HMSSessionStoreAction {

    static func sessionStoreActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {

        switch call.method {
        case "get_session_metadata_for_key":
            getSessionMetadata(call, result, plugin)
            
        case "set_session_metadata_for_key":
            setSessionMetadata(call, result, plugin)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    static private func getSessionMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {
        
    }
    
    
    static private func setSessionMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {
        
    }
}
