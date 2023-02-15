//
//  HMSErrorLogger.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 06/02/23.
//

import Foundation

class HMSErrorLogger {

    static func logError(_ methodName: String, _ error: String, _ errorType: String) {
        print("FL_HMSSDK Error \(errorType): { method -> \(methodName), error -> \(error) }")
    }

    static func returnError(errorMessage: String) {
        print("FL_HMSSDK Args Error \(errorMessage)")
    }
}
