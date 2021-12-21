//
//  HMSPublishSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPublishSettingsExtension {
    
    static func toDictionary(publishSettings:HMSPublishSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
        dict["audio"] = HMSPublishSettingsExtension.toDictionary(audio: publishSettings.audio)
        dict["video"] = HMSPublishSettingsExtension.toDictionary(video: publishSettings.video)
        dict["screen"] = HMSPublishSettingsExtension.toDictionary(video: publishSettings.screen)
        

        if let videoSimulcastLayer:HMSSimulcastSettingsPolicy =  publishSettings.videoSimulcastLayers{
            dict["video_simul_cast"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcastlayerSettingPolicy: videoSimulcastLayer)
        }
        
        if let screenSimulcastLayer:HMSSimulcastSettingsPolicy =  publishSettings.videoSimulcastLayers{
            dict["screen_simul_cast"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcastlayerSettingPolicy: screenSimulcastLayer)
        }
        return dict
    }
    
    
    static func toDictionary(audio settings: HMSAudioSettings) -> Dictionary<String,Any?> {
    
        var dict = [String: Any]()
        
        dict["bit_rate"] = settings.bitRate
        
        dict["codec"] = settings.codec
        
        return dict
    }
    
    
    static func toDictionary(video settings:HMSVideoSettings) -> Dictionary<String,Any?> {
        
        var dict = [String: Any]()
        
        dict["bit_rate"] = settings.bitRate
        dict["codec"] = settings.codec
        dict["frame_rate"] = settings.frameRate
        dict["width"] = settings.width
        dict["height"] = settings.height
        
        return dict
    }
}
