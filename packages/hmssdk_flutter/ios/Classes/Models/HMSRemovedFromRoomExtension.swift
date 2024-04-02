//
//  HMSRemovedFromRoomExtension.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 06/01/22.
//

import Foundation
import HMSSDK

class HMSRemovedFromRoomExtension {

    static func toDictionary(_ notification: HMSRemovedFromRoomNotification) -> [String: Any] {

        var dict = [String: Any]()

        dict["reason"] = notification.reason

        dict["room_was_ended"] = notification.roomEnded

        if let peer = notification.requestedBy {
            dict["peer_who_removed"] = HMSPeerExtension.toDictionary(peer)
        }

        return dict
    }
}
