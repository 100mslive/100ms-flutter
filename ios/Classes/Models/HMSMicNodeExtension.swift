//
//  HMSMicNodeExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 10/08/22.
//

import Foundation
import HMSSDK
class HMSMicNodeExtension {
    static func setVolume(_ call: [AnyHashable: Any], _ playerNode: HMSMicNode) {
        if let volume = call["volume"] as? Float {
            playerNode.volume = volume
        }
        else{
            HMSErrorLogger.logError(#function,"Volume is nil","Null Error")
        }
    }
}
