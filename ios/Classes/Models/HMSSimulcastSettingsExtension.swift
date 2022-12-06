//
//  HMSSimulcastSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 06/12/22.
//

import Foundation
import HMSSDK

class HMSSimulcastSettingsExtension {
    static func toDictionary(_ simulcast: HMSSimulcastSettings) -> [String:Any] {
        var dict = [String:Any]()
        
        if let video = simulcast.video {
            dict["video"] = HMSSimulcastSettingsPolicyExtension.toDictionary(video)
        }
        
        if let screen = simulcast.screen {
            dict["screen"] = HMSSimulcastSettingsPolicyExtension.toDictionary(screen)
        }
        
        return dict
    }
}
