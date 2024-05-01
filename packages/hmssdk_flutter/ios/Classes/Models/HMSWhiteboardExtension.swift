//
//  HMSWhiteboardExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 30/04/24.
//

import Foundation
import HMSSDK

class HMSWhiteboardExtension{
    
    static func toDictionary(hmsWhiteboard: HMSWhiteboard?) -> [String: Any?]?{
            
        guard let whiteboard = hmsWhiteboard else{
            return nil
        }
        
        var args = [String: Any?]()
        
        args["id"] = hmsWhiteboard?.id
        args["owner"] = HMSPeerExtension.toDictionary(hmsWhiteboard?.owner)
        args["title"] = hmsWhiteboard?.title
        args["url"] = hmsWhiteboard?.url?.absoluteString
        
        return args
    }
}
