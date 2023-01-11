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

    static func toDictionary(_ localVideoStats: [HMSLocalVideoStats]) -> [[String: Any]] {

        var statsArray = [[String: Any]]()

        for stat in localVideoStats {
            var dict = [String: Any]()

            if let layerId = stat.simulcastLayerId {
                dict["hms_layer"] = HMSSimulcastLayerDefinitionExtension.getStringFromLayer(layer: HMSSimulcastLayer(rawValue: layerId as! UInt))
            }
            dict["resolution"] = HMSVideoResolutionExtension.toDictionary(stat.resolution)
            dict["frame_rate"] = stat.frameRate
            dict["quality_limitation_reason"] = getQualityLimitations(stat.qualityLimitations)
            dict["bitrate"] =  stat.bitrate
            dict["round_trip_time"] =  stat.roundTripTime
            dict["bytes_sent"] =  stat.bytesSent
            statsArray.append(dict)
        }

        return statsArray
    }

    static private func getQualityLimitations(_ limitation: HMSQualityLimitationReasons) -> [String: Any] {
        [
            "bandwidth": limitation.bandwidth,
            "cpu": limitation.cpu,
            "none": limitation.none,
            "other": limitation.other,
            "quality_limitation_resolution_changes": Double(limitation.qualityLimitationResolutionChanges),
            "reason": getStringFromLimitationReason(limitation.reason)
        ]
    }
    
    static private func getStringFromLimitationReason(_ reason: HMSQualityLimitationReason)-> String{
        switch reason {
        case .CPU:
            return "CPU"
        case .bandwidth:
            return "BANDWIDTH"
        case .none:
            return "NONE"
        case .other:
            return "OTHER"
        default:
            return "UNKNOWN"
        }
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
