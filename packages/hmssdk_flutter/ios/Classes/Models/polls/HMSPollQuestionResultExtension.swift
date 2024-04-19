//
//  HMSPollQuestionResultExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollQuestionResultExtension {

    static func toDictionary(pollQuestionResult: HMSPollQuestionResult) -> [String: Any] {

        var map = [String: Any]()

        map["attempted_times"] = pollQuestionResult.totalVotes
        map["correct"] = pollQuestionResult.correctVotes
        map["options"] = pollQuestionResult.optionVoteCounts
        map["question_type"] = pollQuestionResult.type
        map["skipped"] = pollQuestionResult.skippedVotes

        return map
    }
}
