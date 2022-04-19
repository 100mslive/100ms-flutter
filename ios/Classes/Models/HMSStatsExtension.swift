//
//  HMSStatsExtension.swift
//  hmssdk_flutter
//
//  Created by govind on 28/01/22.
//

import Foundation
import HMSSDK

class HMSStatsExtension {

        static func toDictionary(_ hmsLocalAudioStats: HMSLocalAudioStats) -> [String: Any] {

            var dict = [String: Any]()

            dict["round_trip_time"] =  hmsLocalAudioStats.roundTripTime
            dict["bytes_sent"] =  hmsLocalAudioStats.bytesSent
            dict["bitrate"] =  hmsLocalAudioStats.bitrate

            return dict
        }

    static func toDictionary(_ hmsLocalVideoStats: HMSLocalVideoStats) -> [String: Any] {

        var dict = [String: Any]()

        dict["round_trip_time"] =  hmsLocalVideoStats.roundTripTime
        dict["bytes_sent"] =  hmsLocalVideoStats.bytesSent
        dict["bitrate"] =  hmsLocalVideoStats.bitrate
        dict["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsLocalVideoStats.resolution)
        dict["frame_rate"] = hmsLocalVideoStats.frameRate

        return dict
    }

    static func toDictionary(_ hmsRemoteAudioStats: HMSRemoteAudioStats) -> [String: Any] {

        var dict = [String: Any]()

        dict["jitter"] =  hmsRemoteAudioStats.jitter
        dict["bytes_received"] =  hmsRemoteAudioStats.bytesReceived
        dict["bitrate"] =  hmsRemoteAudioStats.bitrate
        dict["packets_received"] =  hmsRemoteAudioStats.packetsReceived
        dict["packets_lost"] =  hmsRemoteAudioStats.packetsLost

        return dict
    }

    static func toDictionary(_ hmsRemoteVideoStats: HMSRemoteVideoStats) -> [String: Any] {

        var dict = [String: Any]()

        dict["jitter"] =  hmsRemoteVideoStats.jitter
        dict["bytes_received"] =  hmsRemoteVideoStats.bytesReceived
        dict["bitrate"] =  hmsRemoteVideoStats.bitrate
        dict["packets_received"] =  hmsRemoteVideoStats.packetsReceived
        dict["packets_lost"] =  hmsRemoteVideoStats.packetsLost
        dict["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsRemoteVideoStats.resolution)
        dict["frame_rate"] = hmsRemoteVideoStats.frameRate

        return dict
    }

    static func toDictionary(_ hmsRTCStatsReport: HMSRTCStatsReport) -> [String: Any] {

        var dict = [String: Any]()

        dict["combined"] =  HMSStatsExtension.toDictionary(hmsRTCStatsReport.combined)
        dict["audio"] =  HMSStatsExtension.toDictionary(hmsRTCStatsReport.audio)
        dict["video"] =  HMSStatsExtension.toDictionary(hmsRTCStatsReport.video)

        return dict
    }

    static func toDictionary(_ hmsRTCStats: HMSRTCStats) -> [String: Any] {

        var dict = [String: Any]()

        dict["bytes_sent"] =  hmsRTCStats.bytesSent
        dict["bytes_received"] =  hmsRTCStats.bytesReceived
        dict["bitrate_sent"] =  hmsRTCStats.bitrateSent
        dict["packets_received"] =  hmsRTCStats.packetsReceived
        dict["packets_lost"] =  hmsRTCStats.packetsLost
        dict["bitrate_received"] = hmsRTCStats.bitrateReceived
        dict["round_trip_time"] = hmsRTCStats.roundTripTime

        return dict
    }
}
