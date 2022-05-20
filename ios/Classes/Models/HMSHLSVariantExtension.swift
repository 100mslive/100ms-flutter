//
//  HMSHLSVariantExtension.swift
//  hmssdk_flutter
//
//  Created by Govind Maheshwari on 19/01/22.
//

import Foundation
import HMSSDK

class HMSHLSVariantExtension {

    static func toDictionary(_ hmshlsVariant: HMSHLSVariant) -> [String: Any] {

        var dict = [String: Any]()

        dict["meeting_url"] = hmshlsVariant.meetingURL.absoluteString

        dict["metadata"] = hmshlsVariant.metadata
        
        dict["hls_stream_url"] = hmshlsVariant.url.absoluteString
        
        if let date = hmshlsVariant.startedAt {
            dict["started_at"] = Int(date.timeIntervalSince1970)
        }

        return dict
    }

}
