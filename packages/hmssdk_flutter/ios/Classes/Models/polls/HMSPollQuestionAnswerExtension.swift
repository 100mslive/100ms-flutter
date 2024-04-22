//
//  HMSPollQuestionAnswerExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollQuestionAnswerExtension {

    static func toDictionary(answer: HMSPollQuestionAnswer) -> [String: Any] {

        var map = [String: Any]()

        map["hidden"] = answer.hidden
        map["option"] = answer.option
        map["options"] = answer.options

        return map
    }
}
