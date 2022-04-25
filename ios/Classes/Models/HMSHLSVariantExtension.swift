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

        if let metadata = hmshlsVariant.metadata  as? String {
            dict["metadata"] = metadata
        }

        if let _ =  hmshlsVariant.startedAt {
            dict["started_at"] = Int(hmshlsVariant.startedAt!.timeIntervalSince1970)
        }

        if let streamUrl =  hmshlsVariant.url.absoluteString as? String {
            dict["hls_stream_url"] = streamUrl
        }

        return dict
    }

}
