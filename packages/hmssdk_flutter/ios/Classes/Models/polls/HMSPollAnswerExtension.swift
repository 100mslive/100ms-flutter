//
//  HMSPollAnswerExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollAnswerExtension {

    static func toDictionary(answer: HMSPollQuestionResponse) -> [String: Any] {

        var map = [String: Any]()

        map["answer"] = answer.text
        map["duration"] = answer.duration
        map["question_id"] = answer.questionID
        map["question_type"] = HMSPollQuestionExtension.getPollQuestionType(pollQuestionType: answer.type)
        map["selected_option"] = answer.option
        map["selected_options"] = answer.options
        map["skipped"] = answer.skipped
        map["update"] = answer.update

        return map
    }
}
