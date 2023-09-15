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

        guard let store = plugin.sessionStore
        else {
            HMSErrorLogger.returnHMSException(#function, "Session Store is null", "NULL ERROR", result)
            return
        }

        guard let arguments = call.arguments as? [AnyHashable: Any],
            let key = arguments["key"] as? String
        else {
            HMSErrorLogger.returnArgumentsError("key is null")
            HMSErrorLogger.returnHMSException(#function, "Key to be fetched from Session Store is null.", "NULL ERROR", result)
            return
        }

        store.object(forKey: key) { value, error in

            if let error = error {
                HMSErrorLogger.returnHMSException(#function, "Error in fetching key: \(key) from Session Store. Error: \(error.localizedDescription)", "Key Fetching error", result)
                return
            }

            if value is String? || value is NSNull {
                result(HMSResultExtension.toDictionary(true, value))
            } else {
                HMSErrorLogger.returnHMSException(#function, "Session metadata type is not compatible, Please use String? type while setting metadata", "Type Incompatibility Error", result)
            }

        }

    }

    static private func setSessionMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ plugin: SwiftHmssdkFlutterPlugin) {

        guard let store = plugin.sessionStore
        else {
            HMSErrorLogger.logError(#function, "Session Store is null.", "NULL Error")
            result(HMSErrorExtension.getError("Session Store is null."))
            return
        }

        guard let arguments = call.arguments as? [AnyHashable: Any],
            let key = arguments["key"] as? String
        else {
            HMSErrorLogger.logError(#function, "Key for the object to be set in Session Store is null.", "NULL Error")
            result(HMSErrorExtension.getError("Key for the object to be set in Session Store is null."))
            return
        }

        let data = arguments["data"]

        store.set(data as Any, forKey: key) { _, error in

            if let error = error {
                HMSErrorLogger.logError(#function, "Error in setting data: \(data ?? "null") for key: \(key) to the Session Store. Error: \(error.localizedDescription)", "Key Error")
                result(HMSErrorExtension.getError("Error in setting data: \(data ?? "null") for key: \(key) to the Session Store. Error: \(error.localizedDescription)"))
                return
            }
            result(nil)
        }
    }
}
