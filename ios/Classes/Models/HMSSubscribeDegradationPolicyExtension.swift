//
//  HMSSubscribeDegradationPolicyExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSSubscribeDegradationPolicyExtension {
    
    static func toDictionary(_ policy: HMSSubscribeDegradationPolicy?) -> [String: Any?]? {
        [
            "packet_loss_threshold": policy?.packetLossThreshold,
            "degrade_grace_period_seconds": policy?.degradeGracePeriodSeconds,
            "recover_grace_period_seconds": policy?.recoverGracePeriodSeconds
        ]
    }
}
