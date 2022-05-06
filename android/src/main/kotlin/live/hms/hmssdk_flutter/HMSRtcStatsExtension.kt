package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.connection.stats.HMSLocalAudioStats
import live.hms.video.connection.stats.HMSLocalVideoStats
import live.hms.video.connection.stats.HMSRemoteAudioStats
import live.hms.video.connection.stats.HMSRemoteVideoStats
import live.hms.video.media.settings.HMSVideoResolution
import live.hms.video.media.tracks.*
import live.hms.video.sdk.models.HMSPeer

class HMSRtcStatsExtension {

    companion object{

        fun toDictionary(hmsRemoteVideoStats: HMSRemoteVideoStats, track : HMSTrack?, peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || hmsRemoteVideoStats==null || track==null)return null
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track",HMSTrackExtension.toDictionary(track)!!)
            
            val hmsRemoteVideoStatsMap = HashMap<String,Any?>()
            if(hmsRemoteVideoStats==null) return null
            hmsRemoteVideoStatsMap["bytes_received"] = hmsRemoteVideoStats.bytesReceived
            hmsRemoteVideoStatsMap["jitter"] = hmsRemoteVideoStats.jitter
            hmsRemoteVideoStatsMap["bitrate"]  = hmsRemoteVideoStats.bitrate
            hmsRemoteVideoStatsMap["packets_lost"]  = hmsRemoteVideoStats.packetsLost
            hmsRemoteVideoStatsMap["packets_received"] = hmsRemoteVideoStats.packetsReceived
            hmsRemoteVideoStatsMap["frame_rate"] = hmsRemoteVideoStats.frameRate
            hmsRemoteVideoStatsMap["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsRemoteVideoStats.resolution)

            args.put("remote_video_stats",hmsRemoteVideoStatsMap)
            return args;
        }

        fun toDictionary(hmsRemoteAudioStats: HMSRemoteAudioStats, track : HMSTrack?, peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || hmsRemoteAudioStats==null || track==null)return null
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track",HMSTrackExtension.toDictionary(track)!!)
            

            val hmsRemoteAudioStatsMap = HashMap<String,Any?>()
            if(hmsRemoteAudioStats==null) return null
            hmsRemoteAudioStatsMap["bytes_received"] = hmsRemoteAudioStats.bytesReceived
            hmsRemoteAudioStatsMap["jitter"] = hmsRemoteAudioStats.jitter
            hmsRemoteAudioStatsMap["bitrate"]  = hmsRemoteAudioStats.bitrate
            hmsRemoteAudioStatsMap["packets_lost"]  = hmsRemoteAudioStats.packetsLost
            hmsRemoteAudioStatsMap["packets_received"] = hmsRemoteAudioStats.packetsReceived

            args.put("remote_audio_stats",hmsRemoteAudioStatsMap)
            return args;
        }

        fun toDictionary(hmsLocalAudioStats: HMSLocalAudioStats, track : HMSTrack?, peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || hmsLocalAudioStats==null || track==null)return null
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track",HMSTrackExtension.toDictionary(track)!!)
            

            val hmsLocalAudioStatsMap = HashMap<String,Any?>()
            if(hmsLocalAudioStats==null) return null
            hmsLocalAudioStatsMap["bytes_received"] = hmsLocalAudioStats.bytesSent
            hmsLocalAudioStatsMap["bitrate"]  = hmsLocalAudioStats.bitrate
            hmsLocalAudioStatsMap["round_trip_time"] = hmsLocalAudioStats.roundTripTime
            args.put("local_audio_stats",hmsLocalAudioStatsMap)
            return args;
        }

        fun toDictionary(hmsLocalVideoStats: HMSLocalVideoStats, track : HMSTrack?, peer: HMSPeer?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()
            if(peer==null || hmsLocalVideoStats==null || track==null)return null
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track",HMSTrackExtension.toDictionary(track)!!)
            

            val hmsLocaVideoStatsMap = HashMap<String,Any?>()
            if(hmsLocalVideoStats==null) return null
            hmsLocaVideoStatsMap["bytes_received"] = hmsLocalVideoStats.bytesSent
            hmsLocaVideoStatsMap["bitrate"]  = hmsLocalVideoStats.bitrate
            hmsLocaVideoStatsMap["round_trip_time"] = hmsLocalVideoStats.roundTripTime
            hmsLocaVideoStatsMap["frame_rate"] = hmsLocalVideoStats.frameRate
            hmsLocaVideoStatsMap["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsLocalVideoStats.resolution)
            args.put("local_video_stats",hmsLocaVideoStatsMap)
            return args;
        }

    }
}