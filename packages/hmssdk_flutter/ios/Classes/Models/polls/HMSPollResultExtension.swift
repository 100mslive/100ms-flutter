//
//  HMSPollResultDisplayExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollResultExtension {

    static func toDictionary(pollResult: HMSPollResult) -> [String: Any] {

        var map = [String: Any]()

        var questions = pollResult.questions.map {( HMSPollQuestionResultExtension.toDictionary(pollQuestionResult: $0))}
        map["questions"] = questions

        map["total_distinct_users"] = pollResult.maxUserCount
        map["total_responses"] = pollResult.totalResponse
        map["voting_users"] = pollResult.userCount

        return map
    }
}
