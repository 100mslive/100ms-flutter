//
//  HMSMessageAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSMessageAction {
    static func messageActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK:HMSSDK?) {
        switch call.method {
        case "send_broadcast_message":
            sendBroadcastMessage(call, result, hmsSDK)
            
        case "send_direct_message":
            sendDirectMessage(call, result, hmsSDK)
            
        case "send_group_message":
            sendGroupMessage(call, result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func sendBroadcastMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String
        else {
            let error = HMSCommonAction.getError(message: "No message found in \(#function)",
                                                 description: "Message is nil",
                                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendBroadcastMessage(type: type, message: message) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    static private func sendDirectMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String,
              let peerID = arguments["peer_id"] as? String,
              let peer = HMSCommonAction.getPeer(by: peerID,hmsSDK: hmsSDK)
        else {
            let error = HMSCommonAction.getError(message: "Invalid arguments passed in \(#function)",
                                                 description: "Message is nil",
                                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendDirectMessage(type: type, message: message, peer: peer) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    static private func sendGroupMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String,
              let rolesList = arguments["roles"] as? [String],
              let roles: [HMSRole] = (hmsSDK?.roles.filter { rolesList.contains($0.name) })
        else {
            let error = HMSCommonAction.getError(message: "Invalid arguments passed in \(#function)",
                                                 description: "Message is nil",
                                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendGroupMessage(type: type, message: message, roles: roles) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
}
