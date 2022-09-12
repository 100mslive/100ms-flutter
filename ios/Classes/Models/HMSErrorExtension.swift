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

}
