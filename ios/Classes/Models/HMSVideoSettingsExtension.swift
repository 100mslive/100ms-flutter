//
//  HMSAudioSettigs.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
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
