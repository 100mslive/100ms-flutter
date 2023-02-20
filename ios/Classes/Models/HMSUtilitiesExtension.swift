//
//  HMSUtilitiesExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 20/02/23.
//

import Foundation


class HMSUtilitiesExtension {
    static func toLocalDate(_ date: Date) -> String {
        let localISOFormatter = ISO8601DateFormatter()
        localISOFormatter.timeZone = TimeZone.current
        return "\(localISOFormatter.string(from: date).replacingOccurrences(of: "T", with: " "))"
    }
}
