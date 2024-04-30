//
//  HMSWhiteboardAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 30/04/24.
//

import Foundation
import HMSSDK

class HMSWhiteboardAction{
    
    static func whiteboardActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        switch call.method{
            "start_whiteboard":
            
            "stop_whiteboard":
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private static func startWhiteboard(_call: FlutterMethodCall, _ result: FlutterResult, _ hmsSDK: HMSSDK?){
        let arguments = call.arguments as![AnyHashable: Any]
        
        guard let title = arguments["title"] as? String else{
            HMSErrorLogger.returnArgumentsError("title can't be empty")
            return
        }
        hmsSDK?.interactivityCenter.startWhiteboard(completion: {
            
        })
        
    }
    
    private static func stopWhiteboard(_ result: FlutterResult, _ hmsSDK: HMSSDK?){
        
    }
    
    static func getWhiteboardUpdateType(updateType: HMSWhiteboardUpdateType) -> String?{
        switch updateType{
        case .started:
            return "on_whiteboard_start"
        case .stopped:
            return "on_whiteboard_stop"
        default:
            return nil
        }
    }
}
