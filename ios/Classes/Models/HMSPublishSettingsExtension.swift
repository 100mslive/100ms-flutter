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
        
        dict["audio"] = HMSAudioSettingExtension.toDictionary(audioSettings:publishSettings.audio)
        dict["video"] = HMSVideoSettingExtension.toDictionary(videoSettings:publishSettings.video)
        dict["screen"] = HMSVideoSettingExtension.toDictionary(videoSettings:publishSettings.screen)
        
        if let audioSimulCast =  publishSettings.audioSimulcast{
            dict["audio_simul_cast"] = HMSSimulCastSettingsExtension.toDictionary(simulCastSettings:audioSimulCast)
        }
       
        if let videoSimulcast =  publishSettings.videoSimulcast{
            dict["video_simul_cast"] = HMSSimulCastSettingsExtension.toDictionary(simulCastSettings: videoSimulcast)
        }
        if let screenSimulcast =  publishSettings.audioSimulcast{
            dict["screen_simul_cast"] = HMSSimulCastSettingsExtension.toDictionary(simulCastSettings:screenSimulcast)
        }
        return dict
    }
}
