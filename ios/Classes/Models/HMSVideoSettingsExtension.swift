//
//  HMSAudioSettigs.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSVideoSettingExtension {
    static func toDictionary(videoSettings:HMSVideoSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        dict["bit_rate"]=videoSettings.bitRate
        dict["codec"] = videoSettings.codec
        dict["frame_rate"] = videoSettings.frameRate
        dict["width"] = videoSettings.width
        dict["height"] = videoSettings.height
        
        return dict
    }
    
}
