//
//  HMSHLSVariantExtension.swift
//  hmssdk_flutter
//
//  Created by Govind Maheshwari on 19/01/22.
//

import Foundation
import HMSSDK

class HMSHLSVariantExtension{
    
    static func toDictionary(_ hmshlsVariant: HMSHLSVariant) -> [String:Any] {
        
        var dict = [String: Any]()
        
        dict["meeting_url"] = hmshlsVariant.meetingURL.absoluteString
                
        dict["metadata"] = hmshlsVariant.metadata
        
        if hmshlsVariant.startedAt != nil {
            dict["started_at"] = Int(hmshlsVariant.startedAt!.timeIntervalSince1970)
        }else{
            dict["started_at"] = -1
        }
        
        if hmshlsVariant.url.absoluteString != nil {
            dict["hls_stream_url"] = hmshlsVariant.url.absoluteString
        }else{
            dict["hls_stream_url"] = ""
        }
        
        return dict
    }
    
}
