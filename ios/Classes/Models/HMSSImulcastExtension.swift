//
//  HMSSImulcastExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 28/07/21.
//

import Foundation
import HMSSDK

class  HMSSimulcastSettingsPolicyExtension{
    static func toDictionary(simulcastlayerSettingPolicy:HMSSimulcastSettingsPolicy)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        var layers:[Dictionary<String, Any?>]=[]

        dict["height"] = simulcastlayerSettingPolicy.height
        dict["width"] = simulcastlayerSettingPolicy.width

        if let layerArray = simulcastlayerSettingPolicy.layers{
            for eachLayer:HMSSimulcastLayerSettingsPolicy in layerArray{
                layers.insert(HMSSimulcastLayerSettingsPolicyExtension.toDictionary(simulcastlayerSettingPolicy: eachLayer), at:layers.count)
            }
        }
        dict["layers"] = layers
        return dict
    }
}
