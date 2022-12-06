//
//  HMSPublishSettingsExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPublishSettingsExtension {

    static func toDictionary(_ publishSettings: HMSPublishSettings) -> [String: Any] {

        var dict = [String: Any]()

        dict["audio"] = HMSPublishSettingsExtension.toDictionary(audio: publishSettings.audio)
        dict["video"] = HMSPublishSettingsExtension.toDictionary(video: publishSettings.video)
        dict["screen"] = HMSPublishSettingsExtension.toDictionary(video: publishSettings.screen)

        if let allowed = publishSettings.allowed {
            dict["allowed"] = allowed
        }
            
        if let simulcast =  publishSettings.simulcast {
            dict["simulcast"] = HMSSimulcastSettingsExtension.toDictionary(simulcast)
        }

        return dict
    }

    static func toDictionary(audio settings: HMSAudioSettings) -> [String: Any] {
        [
            "bit_rate": settings.bitRate,
            "codec": settings.codec
        ]
    }

    static func toDictionary(video settings: HMSVideoSettings) -> [String: Any] {
        [
            "bit_rate": settings.bitRate ?? 0,
            "codec": settings.codec,
            "frame_rate": settings.frameRate,
            "width": settings.width,
            "height": settings.height
        ]
    }
}
