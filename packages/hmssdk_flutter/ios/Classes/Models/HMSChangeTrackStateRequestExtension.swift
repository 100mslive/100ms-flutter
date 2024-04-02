//
//  HMSChangeTrackStateRequestExtension.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 06/01/22.
//

import Foundation
import HMSSDK

class HMSChangeTrackStateRequestExtension {

    static func toDictionary(_ request: HMSChangeTrackStateRequest) -> [String: Any] {

        var dict = [String: Any]()

        dict["mute"] = request.mute

        dict["track"] = HMSTrackExtension.toDictionary(request.track)

        if let peer = request.requestedBy {
            dict["requested_by"] = HMSPeerExtension.toDictionary(peer)
        }

        return dict
    }
}
