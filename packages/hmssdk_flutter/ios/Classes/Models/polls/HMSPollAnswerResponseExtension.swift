//
//  HMSPollAnswerResponseExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 31/01/24.
//

import Foundation
import HMSSDK

class HMSPollAnswerResponseExtension {

    static func toDictionary(pollAnswerResponse: HMSPollQuestionResponseResult) -> [String: Any?] {

        var map = [String: Any?]()

        map["question_index"] = pollAnswerResponse.question
        if let error = pollAnswerResponse.error {
            map["error"] = HMSErrorExtension.toDictionary(error)
        }
        map["correct"] = pollAnswerResponse.correct

        return map

    }

}
