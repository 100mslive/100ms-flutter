//
//  HMSPeerExtension.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 11/07/21.
//

import Foundation
import HMSSDK

class  HMSPeerExtension{
   static func toDictionary (peer:HMSPeer)-> Dictionary<String,Any?>{
        let dict:[String:Any?] = [
            "peer_id":peer.peerID,
            "name":peer.name,
            "is_local":peer.isLocal,
            "role":peer.role,
            "customer_description":peer.customerDescription,
            "customer_user_id":peer.customerUserID
        ]
        
        return dict
    }
}
