//
//  HMSPollQuestionExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollQuestionExtension {

    static func toDictionary(question: HMSPollQuestion) -> [String: Any?] {
        var map = [String: Any?]()

        map["question_id"] = question.index
        map["can_skip"] = question.skippable

        if let answer = question.answer {
            map["correct_answer"] = HMSPollQuestionAnswerExtension.toDictionary(answer: answer)
        }

        map["duration"] = question.duration

        let myResponses = question.myResponses.map { (HMSPollAnswerExtension.toDictionary(answer: $0)) }
        map["my_responses"] = myResponses

        let options = question.options?.map { (HMSPollQuestionOptionExtension.toDictionary(pollOptions: $0)) }
        map["options"] = options

        map["text"] = question.text
        map["type"] = getPollQuestionType(pollQuestionType: question.type)
        map["voted"] = question.voted
        map["weight"] = question.weight
        map["can_change_response"] = question.once
        return map

    }

    static func getPollQuestionType(pollQuestionType: HMSPollQuestionType) -> String? {
        switch pollQuestionType {
            case .longAnswer:
                return "long_answer"
            case .multipleChoice:
                return "multi_choice"
            case .shortAnswer:
                return "short_answer"
            case .singleChoice:
                return "single_choice"
            default:
                return nil
        }
    }
}
