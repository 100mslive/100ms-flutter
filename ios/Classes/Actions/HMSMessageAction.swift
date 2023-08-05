//
//  HMSMessageAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSMessageAction {
    static func messageActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
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
            result(HMSErrorExtension.getError("No message found in \(#function)"))
            return
        }

        let type = arguments["type"] as? String ?? "chat"

        hmsSDK?.sendBroadcastMessage(type: type, message: message) {data, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                guard let data
                else {
                    result(nil)
                    return
                }
                var dict = [String: Any]()
                dict["message"] = HMSMessageExtension.toDictionary(data)
                result(dict)
            }
        }
    }

    static private func sendDirectMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let message = arguments["message"] as? String,
              let peerID = arguments["peer_id"] as? String,
              let peer = HMSCommonAction.getPeer(by: peerID, hmsSDK: hmsSDK)
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }

        let type = arguments["type"] as? String ?? "chat"

        hmsSDK?.sendDirectMessage(type: type, message: message, peer: peer) { data, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                guard let data
                else {
                    result(nil)
                    return
                }
                var dict = [String: Any]()
                dict["message"] = HMSMessageExtension.toDictionary(data)
                result(dict)
            }
        }
    }

    static private func sendGroupMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let message = arguments["message"] as? String,
              let rolesList = arguments["roles"] as? [String],
              let roles: [HMSRole] = (hmsSDK?.roles.filter { rolesList.contains($0.name) })
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }

        let type = arguments["type"] as? String ?? "chat"

        hmsSDK?.sendGroupMessage(type: type, message: message, roles: roles) { data, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                guard let data
                else {
                    result(nil)
                    return
                }
                var dict = [String: Any]()
                dict["message"] = HMSMessageExtension.toDictionary(data)
                result(dict)
            }
        }
    }
}
