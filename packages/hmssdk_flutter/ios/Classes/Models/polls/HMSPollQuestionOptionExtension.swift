//
//  HMSPollQuestionOptionExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollQuestionOptionExtension {

    static func toDictionary(pollOptions: HMSPollQuestionOption) -> [String: Any] {

        var map = [String: Any]()

        map["index"] = pollOptions.index
        map["text"] = pollOptions.text
        map["vote_count"] = pollOptions.voteCount
        map["weight"] = pollOptions.weight

        return map
    }
}
