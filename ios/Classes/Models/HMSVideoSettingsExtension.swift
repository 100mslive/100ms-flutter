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
        dict["codec"] = getValueOfHMSVideoCodec(codec:videoSettings.codec)
        dict["frame_rate"] = videoSettings.frameRate
        dict["width"] = videoSettings.width
        dict["height"] = videoSettings.height
        
        return dict
    }
    
    static func getValueOfHMSVideoCodec (codec:HMSVideoCodec)->String{
        switch codec {
        case .h264:
            return "h264"
        case .vp8:
            return "vp8"
        case .vp9:
            return "vp9"
        case .h265:
            return "h265"
        @unknown default:
            return "defaultCodec"
        }
    }
}
