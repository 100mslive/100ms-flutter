//
//  HMSRemoteVideoTrackAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 19/12/22.
//

import Foundation
import HMSSDK

class HMSRemoteVideoTrackExtension {

    static func remoteVideoTrackActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {

        switch call.method {
        case "set_simulcast_layer":
            setSimulcastLayer(call, result, hmsSDK)
        case "get_layer":
            getLayer(call, result, hmsSDK)
        case "get_layer_definition":
            getLayerDefinition(call, result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }

    }

    static private func setSimulcastLayer(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        let arguments = call.arguments as![AnyHashable: Any]

        guard let trackIdString = arguments["track_id"] as? String,
              let trackId = HMSUtilities.getTrack(for: trackIdString, in: hmsSDK.room!),
              let layer = arguments["layer"] as? String
        else {
            result(HMSErrorExtension.getError("No track ID or HMSSimulcastLayer found in \(#function)"))
            return
        }

        if let track = trackId as? HMSRemoteVideoTrack {
            track.layer = HMSSimulcastLayerDefinitionExtension.getLayerFromString(layer: layer)
            result(nil)
        } else {
            result(HMSErrorExtension.getError("Track Id must be HMSRemoteVideoTrack Type \(#function)"))
        }
    }

    static private func getLayer(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        let arguments = call.arguments as![AnyHashable: Any]

        guard let trackIdString = arguments["track_id"] as? String,
              let trackId = HMSUtilities.getTrack(for: trackIdString, in: hmsSDK.room!)
        else {
            result(nil)
            return
        }
        if let track = trackId as? HMSRemoteVideoTrack {
            result(HMSSimulcastLayerDefinitionExtension.getStringFromLayer(layer: track.layer))
        } else {
            result(nil)
        }
    }

    static private func getLayerDefinition(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        let arguments = call.arguments as![AnyHashable: Any]

        guard let trackIdString = arguments["track_id"] as? String,
              let trackId = HMSUtilities.getTrack(for: trackIdString, in: hmsSDK.room!)
        else {
            result(nil)
            return
        }
        var dict = [[String: Any]]()
        if let track = trackId as? HMSRemoteVideoTrack {
            track.layerDefinitions?.forEach { layerDefinition in
                dict.append(HMSSimulcastLayerDefinitionExtension.toDictionary(layerDefinition))
            }
            result(dict)
        } else {
            result(nil)
        }
    }

}
