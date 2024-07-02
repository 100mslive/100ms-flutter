//
//  HMSHLSCueExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSCueExtension {

    static func toDictionary(_ hmsHlsCue: HMSHLSCue) -> [String: Any?] {

        var dict = [String: Any?]()

        dict["id"] = hmsHlsCue.id
        dict["start_date"] = (hmsHlsCue.startDate.timeIntervalSince1970 * 1000)
        if let endDate = hmsHlsCue.endDate {
            dict["end_date"] = (endDate.timeIntervalSince1970 * 1000)
        }
        dict["payload"] = hmsHlsCue.payload

        return dict
    }
}
