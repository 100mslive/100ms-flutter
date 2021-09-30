//
//  HMSAudioSettigs.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSAudioSettingsExtension {
    static func toDictionary(audioSettings:HMSAudioSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["bit_rate"]=audioSettings.bitRate
        dict["codec"] = audioSettings.codec
        
        return dict
    }
    
}

