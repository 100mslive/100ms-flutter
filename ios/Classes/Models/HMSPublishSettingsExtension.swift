//
//  HMSPublishSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 27/07/21.
//

import Foundation
import HMSSDK

class  HMSPublishSettingExtension {
    
    static func toDictionary(publishSettings:HMSPublishSettings)-> Dictionary<String,Any?>{
        var dict:Dictionary<String, Any?> = [:]
        
        dict["audio"] = HMSAudioSettingsExtension.toDictionary(audioSettings:publishSettings.audio)
        dict["video"] = HMSVideoSettingExtension.toDictionary(videoSettings:publishSettings.video)
        dict["screen"] = HMSVideoSettingExtension.toDictionary(videoSettings:publishSettings.screen)
        

        if let videoSimulcastLayer:HMSSimulcastSettingsPolicy =  publishSettings.videoSimulcastLayers{
            dict["video_simul_cast"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcastlayerSettingPolicy: videoSimulcastLayer)
        }
        
        if let screenSimulcastLayer:HMSSimulcastSettingsPolicy =  publishSettings.videoSimulcastLayers{
            dict["screen_simul_cast"] = HMSSimulcastSettingsPolicyExtension.toDictionary(simulcastlayerSettingPolicy: screenSimulcastLayer)
        }
        return dict
    }
}
