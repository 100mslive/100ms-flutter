//
//  HMSResultExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 27/03/23.
//

import Foundation

class HMSResultExtension {

    static func toDictionary(_ success: Bool, _ data: Any? = nil) -> [String: Any?] {

        /**
            We  add `data`  field in the map only when it is non null
             otherwise the application might crash.
         */
        var dict: [String: Any] = ["success": success]
        if let data = data {
            dict["data"] = data
        }
        return dict
    }
}
