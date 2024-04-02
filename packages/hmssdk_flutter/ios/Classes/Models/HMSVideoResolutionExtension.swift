//
//  HMSVideoResolutionExtension.swift
//  hmssdk_flutter
//
//  Created by govind on 29/01/22.
//

import Foundation
import HMSSDK

class HMSVideoResolutionExtension {

        static func toDictionary(_ hmsVideoResolution: HMSVideoResolution) -> [String: Any] {

            var dict = [String: Any]()

            dict["height"] =  hmsVideoResolution.height
            dict["width"] =  hmsVideoResolution.width

            return dict
        }
}
