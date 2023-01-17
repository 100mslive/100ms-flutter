//
//  HMSErrorExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSErrorExtension {

    static func toDictionary(_ error: Error) -> [String: Any] {
        guard let error = error as? HMSError else { return [:] }
        var dict = [String: Any]()

        dict["code"] = error.code.rawValue

        dict["isTerminal"] = error.isTerminal

        dict["canRetry"] = error.canRetry

        dict["description"] = error.localizedDescription

        return ["error": dict]
    }

    static func getError(_ description: String) -> [String: Any] {
        var dict = [String: Any]()

        dict["code"] = 6004

        dict["isTerminal"] = false

        dict["canRetry"] = false

        dict["description"] = description

        return ["error": dict]
    }
    
}
