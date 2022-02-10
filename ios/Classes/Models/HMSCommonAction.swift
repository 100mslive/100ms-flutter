//
//  HMSCommonAction.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSCommonAction {
    static internal func getPeer(by peerID: String,hmsSDK:HMSSDK?) -> HMSPeer? {
        hmsSDK?.room?.peers.first { $0.peerID == peerID }
    }
    
    static func getError(message: String, description: String? = nil, params: [String: Any]) -> HMSError {
        HMSError(id: "NONE",
                 code: .genericErrorJsonParsingFailed,
                 message: message,
                 info: description,
                 params: params)
    }
    
    static func getRole(by name: String,hmsSDK:HMSSDK?) -> HMSRole? {
        hmsSDK?.roles.first { $0.name == name }
    }
}
