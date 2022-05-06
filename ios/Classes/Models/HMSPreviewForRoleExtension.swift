//
//  HMSPreviewForRoleExtension.swift
//  hmssdk_flutter
//
//  Created by govind on 06/05/22.
//

import Foundation
import HMSSDK

class HMSPreviewForRoleExtension {
        static func toDictionary(_ hmsTrack: [HMSTrack]?) -> [String: Any] {

            var dict = [String: Any]()
            if let hmsTrack = hmsTrack{
                for track in hmsTrack {
                    if track.kind == .audio {
                        dict["audio"] = HMSTrackExtension.toDictionary(track)
                    }else{
                        dict["video"] = HMSTrackExtension.toDictionary(track)
                    }
                }
            }
            return dict
        }
}
