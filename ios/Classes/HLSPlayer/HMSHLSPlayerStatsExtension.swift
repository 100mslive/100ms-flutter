//
//  HLSPlayerStatsExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSPlayerStatsExtension {
    static func toDictionary(_ hlsStats: HMSHLSStatsMonitor) -> [String: Any?] {
        var args = [String: Any?]()
        
        args["bandwidth_estimate"] = hlsStats.estimatedBandwidth
        args["total_bytes_loaded"] = hlsStats.bytesDownloaded
        args["buffered_duration"] = hlsStats.bufferedDuration
        args["distance_from_live"] = hlsStats.distanceFromLiveEdge
        args["dropped_frame_count"] = hlsStats.droppedFrames
        args["video_height"] = hlsStats.videoSize.height
        args["video_width"] = hlsStats.videoSize.width
        args["average_bitrate"] = hlsStats.bitrate
        
        return args
    }
}
