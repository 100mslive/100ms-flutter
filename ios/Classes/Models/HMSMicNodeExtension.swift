//
//  HMSMicNodeExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 10/08/22.
//

import Foundation
import HMSSDK
class HMSMicNodeExtension {
    static func setVolume(_ call: [AnyHashable: Any],_ playerNode:HMSMicNode){
        playerNode.volume = call["volume"] as! Float
    }
}
