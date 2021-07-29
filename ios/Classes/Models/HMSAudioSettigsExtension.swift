//
//  HMSAudioSettigs.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
//

import Foundation
import HMSSDK

class  HMSAudioSettingExtension {
    static func toDictionary(audioSettings:HMSAudioSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["bit_rate"]=audioSettings.bitRate
        dict["codec"] = audioSettings.codec
        
        return dict
    }
    
}

