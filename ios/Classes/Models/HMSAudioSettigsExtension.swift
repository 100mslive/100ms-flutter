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
        dict["codec"] = getValueOfHMSAudioCodec(codec:audioSettings.codec)
        
        return dict
    }
    
    static func getValueOfHMSAudioCodec (codec:HMSAudioCodec)->String{
        switch codec {
        case .opus:
            return "opus"
        @unknown default:
            return "defaultCodec"
        }
    }
}

