//
//  HLSStatsHandler.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSStatsHandler {

    static var statsMonitor: HMSHLSStatsMonitor?
    static private var statsTimer: Timer?

    static func addHLSStatsListener(_ hlsPlayer: HMSHLSPlayer?, _ hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?) {

        guard let hlsPlayer else {
            HMSErrorLogger.logError(#function, "hlsPlayer is null", "NULL_ERROR")
            return
        }

        statsMonitor = HMSHLSStatsMonitor(player: hlsPlayer._nativePlayer)

        statsTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in

            guard let statsMonitor else {
                return
            }

            let data = [
                "event_name": "on_hls_event_update",
                "data": HMSHLSPlayerStatsExtension.toDictionary(statsMonitor)
            ] as [String: Any?]

            guard let hmssdkFlutterPlugin else {
                HMSErrorLogger.logError(#function, "hmssdkFlutterPlugin is null", "NULL_ERROR")
                return
            }
            hmssdkFlutterPlugin.hlsPlayerSink?(data)

        }
    }

    static func removeHLSStatsListener() {
        statsTimer?.invalidate()
    }
}
