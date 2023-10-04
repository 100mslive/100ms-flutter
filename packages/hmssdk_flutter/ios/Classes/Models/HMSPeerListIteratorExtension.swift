//
//  HMSPeerListIteratorExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 04/10/23.
//

import Foundation
import HMSSDK

class HMSPeerListIteratorExtension{
    
    static func toDictionary(_ peerListIterator: HMSPeerListIterator,_ uid: String) -> [String:Any]{
        
        var dict = [
            "uid": uid,
            "limit": peerListIterator.options.limit,
            "total_count": peerListIterator.totalCount
        ] as [String : Any]
        
        
        return dict
    }
}
