//
//  HMSMessageExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSMessageExtension {

    static func toDictionary(_ message: HMSMessage) -> [String: Any] {

        var dict = [String: Any]()

        dict["message"] = message.message

        dict["type"] = message.type

        dict["time"] = "\(message.time)"

        dict["hms_message_recipient"] = HMSMessageRecipientExtension.toDictionary(message.recipient)

        if let sender = message.sender {
            dict["sender"] = HMSPeerExtension.toDictionary(sender)
        }

        return dict
    }
}
