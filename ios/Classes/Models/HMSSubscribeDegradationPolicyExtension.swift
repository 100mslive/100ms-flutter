//
//  HMSSubscribeDegradationPolicyExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSSubscribeDegradationPolicyExtensin{
    static func toDictionary(policy:HMSSubscribeDegradationPolicy) -> Dictionary<String,Any?>{
        var dict:Dictionary<String,Any?>=[:]
            dict["packet_loss_threshold"]=policy.packetLossThreshold
            dict["degrade_grace_period_seconds"]=policy.degradeGracePeriodSeconds
            dict["recover_grace_period_seconds"]=policy.recoverGracePeriodSeconds
        
        return dict
    }
}
