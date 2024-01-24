//
//  HMSPollAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 19/01/24.
//

import Foundation
import HMSSDK

class HMSPollAction{
    
    static func pollActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        switch call.method{
        case "quick_start_poll":
            quickStartPoll(call, result, hmsSDK)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func quickStartPoll(_ call: FlutterMethodCall,_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        
        let arguments = call.arguments as? [AnyHashable: Any]
        
        guard let pollBuilderMap = arguments?["poll_builder"] as? [String:Any?] else{
            result(HMSErrorExtension.getError("No pollBuilder found in \(#function)"))
            return
        }
        
        if let hmsSDK{
            guard let pollBuilder = HMSPollBuilderExtension.toHMSPollBuilder(pollBuilderMap, hmsSDK)
            else{
                HMSErrorLogger.returnArgumentsError("pollBuilder parsing failed")
                return
            }
            
            hmsSDK.interactivityCenter.quickStartPoll(with: (pollBuilder), completion: {_ , error in
                if let error = error {
                    result(HMSErrorExtension.toDictionary(error))
                } else {
                    result(nil)
                }})
        } else{
            result(HMSErrorExtension.getError("hmsSDK is nil in \(#function)"))
            return
        }
        
    }
}
