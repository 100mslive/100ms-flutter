//
//  HLSStatsHandler.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

/**
  This class handles the HLS Player stats
 */
class HMSHLSStatsHandler {

    static var statsMonitor: HMSHLSStatsMonitor?
    static private var statsTimer: Timer?

    /**
        Adds an HLS stats listener to the specified HLS player.
         We send the HLS Stats to flutter layer in every 2 seconds using the statsTimer we declared above

        @param hlsPlayer The HMSHLSPlayer instance to attach the stats listener to.
        @param hmssdkFlutterPlugin The SwiftHmssdkFlutterPlugin instance for sending the stats data.
    */
    static func addHLSStatsListener(_ hlsPlayer: HMSHLSPlayer?, _ hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?) {

        guard let hlsPlayer else {
            HMSErrorLogger.logError(#function, "hlsPlayer is null", "NULL_ERROR")
            return
        }

        statsMonitor = HMSHLSStatsMonitor(player: hlsPlayer._nativePlayer)

        /**
            Here we set the time interval at which the stats needs to be sent to flutter layer
            Currently we have set it to 2 seconds.
         */
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

    /**
        Removes the HLS stats listener and stops the stats timer.
        Here we invalidate the statsTimer 
    */
    static func removeHLSStatsListener() {
        statsTimer?.invalidate()
    }
}
