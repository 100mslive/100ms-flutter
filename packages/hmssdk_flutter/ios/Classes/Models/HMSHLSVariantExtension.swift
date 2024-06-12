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

        if let url = hmshlsVariant.url {
            dict["hls_stream_url"] = url.absoluteString
        } else {
            dict["hls_stream_url"]  = nil
        }

        if let startedAt = hmshlsVariant.startedAt {
            dict["started_at"] =  Int(startedAt.timeIntervalSince1970 * 1000)
        }

        if let playlistType = hmshlsVariant.playlistType {
            dict["playlist_type"] = getStringFromHMSHLSPlaylistType(playlistType: playlistType)
        }

        return dict
    }

    private static func getStringFromHMSHLSPlaylistType(playlistType: HMSHLSPlaylistType) -> String {
        switch playlistType {
            case .dvr:
                return "dvr"
            case .noDVR:
                return "noDvr"
            default:
                return "noDvr"
        }
    }

}
