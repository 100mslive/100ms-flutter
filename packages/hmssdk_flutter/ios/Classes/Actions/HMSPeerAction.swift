//
//  HMSPeerAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 27/09/23.
//

import Foundation
import HMSSDK

class HMSPeerAction {

    static func peerActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
        case "change_metadata":
            changeMetadata(call, result, hmsSDK)

        case "change_name":
            changeName(call, result, hmsSDK)

        case "lower_remote_peer_hand":
            lowerRemotePeerHand(call, result, hmsSDK)

        case "raise_local_peer_hand":
            raiseLocalPeerHand(result, hmsSDK)

        case "lower_local_peer_hand":
            lowerLocalPeerHand(result, hmsSDK)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func changeName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as![AnyHashable: Any]

        guard let name = arguments["name"] as? String else {
            result(HMSErrorExtension.getError("No name found in \(#function)"))
            return
        }

        hmsSDK?.change(name: name) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }

        }
    }

    static private func changeMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let metadata = arguments["metadata"] as? String else {
            result(HMSErrorExtension.getError("No metadata found in \(#function)"))
            return
        }

        hmsSDK?.change(metadata: metadata) {_, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
                return
            } else {
                result(nil)
            }
        }
    }

    static private func lowerLocalPeerHand(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        hmsSDK?.lowerLocalPeerHand {
            _, error in if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    static private func raiseLocalPeerHand(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        hmsSDK?.raiseLocalPeerHand {
            _, error in if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    static private func lowerRemotePeerHand(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK? ) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let peerId = arguments?["peer_id"] as? String,
              let forPeer = HMSCommonAction.getPeer(by: peerId, hmsSDK: hmsSDK)
        else {
            HMSErrorLogger.returnArgumentsError("forPeer is null")
            return
        }

        hmsSDK?.lowerRemotePeerHand(forPeer) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
}
