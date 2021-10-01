//
//  HMSSimulCastSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSSimulcastLayerSettingsPolicyExtension {
    
    static func toDictionary(simulcastlayerSettingPolicy:HMSSimulcastLayerSettingsPolicy)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["rid"]=simulcastlayerSettingPolicy.rid
        dict["max_bitrate"]=simulcastlayerSettingPolicy.maxBitrate
        dict["max_frame_rate"]=simulcastlayerSettingPolicy.maxFramerate
        dict["scale_resolution_down_by"]=simulcastlayerSettingPolicy.scaleResolutionDownBy
        return dict
    }
}
