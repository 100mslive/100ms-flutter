//
//  HMSSimulCastSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSSimulcastLayerSettingsPolicyExtension {
    
    static func toDictionary(_ policy: HMSSimulcastLayerSettingsPolicy) -> [String: Any?] {
        [
            "rid": policy.rid,
            "max_bitrate": policy.maxBitrate,
            "max_frame_rate": policy.maxFramerate,
            "scale_resolution_down_by": policy.scaleResolutionDownBy
        ]
    }
}
