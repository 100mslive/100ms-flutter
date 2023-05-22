package live.hms.hmssdk_flutter.hls_player

import androidx.media3.exoplayer.analytics.AnalyticsListener
import live.hms.stats.model.PlayerStatsModel

class HMSPlayerStatsExtension {

    companion object{
        fun toDictionary(hmsPlayerStatsModel: PlayerStatsModel):Map<String,Any?>{
            val args = HashMap<String, Any?>()

            args["bandwidth"] = Bandwidth.toDictionary(hmsPlayerStatsModel.bandwidth)
            args["buffered_duration"] = hmsPlayerStatsModel.bufferedDuration
            args["distance_from_live"] = hmsPlayerStatsModel.distanceFromLive
            args["frame_info"] = FrameInfo.toDictionary(hmsPlayerStatsModel.frameInfo)
            args["video_info"] = VideoInfo.toDictionary(hmsPlayerStatsModel.videoInfo)
            return args
        }
    }

    internal class Bandwidth{
        companion object{
            fun toDictionary(bandwidth: PlayerStatsModel.Bandwidth):Map<String,Any?>{
                val args = HashMap<String, Any?>()

                args["bandwidth_estimate"] = bandwidth.bandWidthEstimate
                args["total_bytes_loaded"] = bandwidth.totalBytesLoaded

                return args
            }
        }
    }

    internal class FrameInfo{
        companion object{
            fun toDictionary(frameInfo: PlayerStatsModel.FrameInfo):Map<String,Any?>{
                val args = HashMap<String, Any?>()

                args["dropped_frame_count"] = frameInfo.droppedFrameCount
                args["total_frame_count"] = frameInfo.totalFrameCount

                return args
            }
        }
    }

    internal class VideoInfo{
        companion object{
            fun toDictionary(videoInfo: PlayerStatsModel.VideoInfo):Map<String,Any?>{
                val args = HashMap<String, Any?>()

                args["average_bitrate"] = videoInfo.averageBitrate
                args["frame_rate"] = videoInfo.frameRate
                args["video_height"] = videoInfo.videoHeight
                args["video_width"] = videoInfo.videoWidth

                return args
            }
        }
    }

}