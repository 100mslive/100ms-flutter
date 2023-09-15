package live.hms.hmssdk_flutter.hls_player

import live.hms.stats.model.PlayerStatsModel

class HMSPlayerStatsExtension {
    companion object {
        fun toDictionary(hmsPlayerStatsModel: PlayerStatsModel): Map<String, Any?> {
            val args = HashMap<String, Any?>()

            args["bandwidth_estimate"] = hmsPlayerStatsModel.bandwidth.bandWidthEstimate
            args["total_bytes_loaded"] = hmsPlayerStatsModel.bandwidth.totalBytesLoaded
            args["buffered_duration"] = hmsPlayerStatsModel.bufferedDuration
            args["distance_from_live"] = hmsPlayerStatsModel.distanceFromLive
            args["dropped_frame_count"] = hmsPlayerStatsModel.frameInfo.droppedFrameCount
            args["video_height"] = hmsPlayerStatsModel.videoInfo.videoHeight
            args["video_width"] = hmsPlayerStatsModel.videoInfo.videoWidth
            args["average_bitrate"] = hmsPlayerStatsModel.videoInfo.averageBitrate
            return args
        }
    }
}
