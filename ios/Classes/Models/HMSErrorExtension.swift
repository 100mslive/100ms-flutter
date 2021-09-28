//
//  HMSErrorExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSErrorExtension{
    static func toDictionary(error:HMSError)-> Dictionary<String,Any?>{
        
        var dict:Dictionary<String, Any?> = [:]
        dict["id"] = error.id
        dict["message"] = error.message
        dict["code"] = getValueOfHMSErrorCode(errorCode:error.code)
 
        if let info = error.info{
            dict["info"] = info
        }
        
        if let action = error.action{
            dict["action"] = action
        }
        	
        if let params = error.params{
            dict["params"] = params
        }
        
        return dict
        
    }
    static func getValueOfHMSErrorCode (errorCode:HMSErrorCode)->String{
       return "\(errorCode)"
    }
    
}
