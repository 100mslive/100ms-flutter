//
//  HMSWhiteboardAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 30/04/24.
//

import Foundation
import HMSSDK

class HMSWhiteboardAction {

    static func whiteboardActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
            case "start_whiteboard":
                startWhiteboard(call, result, hmsSDK)

            case "stop_whiteboard":
                stopWhiteboard(result, hmsSDK)

            default:
                result(FlutterMethodNotImplemented)
        }
    }

    private static func startWhiteboard(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as![AnyHashable: Any]

        /*
         title is not used as of now
         */
        guard let title = arguments["title"] as? String else {
            HMSErrorLogger.returnArgumentsError("title can't be empty")
            return
        }
        hmsSDK?.interactivityCenter.startWhiteboard {
            _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }

    }

    private static func stopWhiteboard(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        hmsSDK?.interactivityCenter.stopWhiteboard {
            _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    static func getWhiteboardUpdateType(updateType: HMSWhiteboardUpdateType) -> String? {
        switch updateType {
        case .started:
            return "on_whiteboard_start"
        case .stopped:
            return "on_whiteboard_stop"
        default:
            return nil
        }
    }
}
