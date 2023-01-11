//
//  HMSSimulcastLayerDefinitionExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 06/12/22.
//

import Foundation
import HMSSDK

class HMSSimulcastLayerDefinitionExtension {
    static func toDictionary(_ layerDefinition: HMSSimulcastLayerDefinition) -> [String: Any] {
        let dict = [
            "hms_simulcast_layer": getStringFromLayer(layer: layerDefinition.layer),
            "hms_resolution": HMSVideoResolutionExtension.toDictionary(layerDefinition.resolution)
        ] as [String: Any]

        return dict
    }
    static func getStringFromLayer(layer: HMSSimulcastLayer?) -> String {
        switch layer {
            case .high:
                return "high"
            case .mid:
                return "mid"
            case .low:
                return "low"
            default:
                return ""
            }
    }

    static func getLayerFromString(layer: String) -> HMSSimulcastLayer {
        switch layer {
        case "high":
            return .high
        case "mid":
            return .mid
        case "low":
            return .low
        default:
            return .mid
        }
    }
}
