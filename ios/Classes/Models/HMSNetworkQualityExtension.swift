//
//  HMSNetworkQualityExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 29/03/22.
//

import Foundation
import HMSSDK

class HMSNetworkQualityExtension {
    static func toDictionary(_ quality: HMSNetworkQuality) -> [String: Any] {
        var dict = [String: Any]()
        dict["quality"]=quality.downlinkQuality
        return dict
    }
}

    
