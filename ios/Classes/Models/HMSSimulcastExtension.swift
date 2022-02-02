//
//  HMSSimulcastExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSSimulcastSettingsPolicyExtension {

    static func toDictionary(_ policy: HMSSimulcastSettingsPolicy) -> [String: Any] {

        var dict = [String: Any]()

        if let width = policy.width {
            dict["width"] = width
        }
        if let height = policy.height {
            dict["height"] = height
        }

        if let layersPolicy = policy.layers {
            var layers = [[String: Any]]()
            layersPolicy.forEach { layers.append(HMSSimulcastLayerSettingsPolicyExtension.toDictionary($0)) }
            dict["layers"] = layers
        }

        return dict
    }
}
