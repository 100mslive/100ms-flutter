//
//  HMSResultExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 27/03/23.
//

import Foundation

class HMSResultExtension {

    static func toDictionary(_ success: Bool, _ data: Any?) -> [String: Any?] {
        let dict = [
            "success": success,
            "data": data
        ]
        return dict
    }

}
