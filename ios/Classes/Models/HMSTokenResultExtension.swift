//
//  HMSTokenResultExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 27/03/23.
//

import Foundation

class HMSTokenResultExtension{
    
    static func toDictionary(_ hmsTokenResult: String?)  -> [String: String?] {
        var dict = [String: String?]()

        dict["auth_token"] = hmsTokenResult
        dict["expires_at"] =  nil

        return dict
    }
}
