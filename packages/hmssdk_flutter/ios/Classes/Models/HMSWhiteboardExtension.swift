//
//  HMSWhiteboardExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 30/04/24.
//

import Foundation
import HMSSDK

class HMSWhiteboardExtension {

    static func toDictionary(hmsWhiteboard: HMSWhiteboard?, hmsSDK: HMSSDK?) -> [String: Any?]? {

        guard let whiteboard = hmsWhiteboard else {
            return nil
        }

        var args = [String: Any?]()

        args["id"] = hmsWhiteboard?.id

        if let owner = hmsWhiteboard?.owner {
            args["owner"] = HMSPeerExtension.toDictionary(owner)
        }
        args["title"] = hmsWhiteboard?.title
        args["url"] = hmsWhiteboard?.url?.absoluteString
        args["is_owner"] = hmsWhiteboard?.owner?.customerUserID == hmsSDK?.localPeer?.customerUserID
        args["state"] = getStateFromString(state: hmsWhiteboard?.state)

        return args
    }

    private static func getStateFromString(state: HMSWhiteboard.WhiteboardState?) -> String {
        switch state {
        case .started:
            return "started"
        case .stopped:
            return "stopped"
        default:
            return "stopped"
        }
    }
}
