//
//  HMSPollQuestionExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollQuestionExtension{
    
    static func toDictionary(question: HMSPollQuestion) -> [String:Any?]{
        var map = [String: Any?]()
        
        map["answer_long_min_length"] = question.answerMinLen
        map["answer_short_min_length"] = question.answerMaxLen
        map["can_change_response"] = question
        
    }
}
