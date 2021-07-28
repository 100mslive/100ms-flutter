//
//  HMSSimulCastSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
//

import Foundation
import HMSSDK

class  HMSSimulCastSettingsExtension {
    
    static func toDictionary(simulCastSettings:HMSSimulcastSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["high"] = simulCastSettings.high
        dict["med"] = simulCastSettings.med
        dict["low"] = simulCastSettings.low
        
        return dict
    }
}
