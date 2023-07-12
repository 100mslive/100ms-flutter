package live.hms.hmssdk_flutter

import live.hms.video.connection.degredation.QualityLimitationReasons
import live.hms.video.connection.stats.HMSLocalAudioStats
import live.hms.video.connection.stats.HMSLocalVideoStats
import live.hms.video.connection.stats.HMSRemoteAudioStats
import live.hms.video.connection.stats.HMSRemoteVideoStats
import live.hms.video.media.tracks.*
import live.hms.video.sdk.models.HMSPeer

class HMSRtcStatsExtension {

    companion object {

        fun toDictionary(hmsRemoteVideoStats: HMSRemoteVideoStats, track: HMSTrack, peer: HMSPeer): HashMap<String, Any?> {
            val args = HashMap<String, Any?>()
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track", HMSTrackExtension.toDictionary(track)!!)

            val hmsRemoteVideoStatsMap = HashMap<String, Any?>()
            hmsRemoteVideoStatsMap["bytes_received"] = hmsRemoteVideoStats.bytesReceived
            hmsRemoteVideoStatsMap["jitter"] = hmsRemoteVideoStats.jitter
            hmsRemoteVideoStatsMap["bitrate"] = hmsRemoteVideoStats.bitrate
            hmsRemoteVideoStatsMap["packets_lost"] = hmsRemoteVideoStats.packetsLost
            hmsRemoteVideoStatsMap["packets_received"] = hmsRemoteVideoStats.packetsReceived
            hmsRemoteVideoStatsMap["frame_rate"] = hmsRemoteVideoStats.frameRate
            hmsRemoteVideoStatsMap["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsRemoteVideoStats.resolution)

            args.put("remote_video_stats", hmsRemoteVideoStatsMap)
            return args
        }

        fun toDictionary(hmsRemoteAudioStats: HMSRemoteAudioStats, track: HMSTrack, peer: HMSPeer): HashMap<String, Any?> {
            val args = HashMap<String, Any?>()
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track", HMSTrackExtension.toDictionary(track)!!)

            val hmsRemoteAudioStatsMap = HashMap<String, Any?>()
            hmsRemoteAudioStatsMap["bytes_received"] = hmsRemoteAudioStats.bytesReceived
            hmsRemoteAudioStatsMap["jitter"] = hmsRemoteAudioStats.jitter
            hmsRemoteAudioStatsMap["bitrate"] = hmsRemoteAudioStats.bitrate
            hmsRemoteAudioStatsMap["packets_lost"] = hmsRemoteAudioStats.packetsLost
            hmsRemoteAudioStatsMap["packets_received"] = hmsRemoteAudioStats.packetsReceived

            args.put("remote_audio_stats", hmsRemoteAudioStatsMap)
            return args
        }

        fun toDictionary(hmsLocalAudioStats: HMSLocalAudioStats, track: HMSTrack, peer: HMSPeer): HashMap<String, Any?> {
            val args = HashMap<String, Any?>()
            args.put("peer", HMSPeerExtension.toDictionary(peer)!!)
            args.put("track", HMSTrackExtension.toDictionary(track)!!)

            val hmsLocalAudioStatsMap = HashMap<String, Any?>()
            hmsLocalAudioStatsMap["bytes_received"] = hmsLocalAudioStats.bytesSent
            hmsLocalAudioStatsMap["bitrate"] = hmsLocalAudioStats.bitrate
            hmsLocalAudioStatsMap["round_trip_time"] = hmsLocalAudioStats.roundTripTime
            args.put("local_audio_stats", hmsLocalAudioStatsMap)
            return args
        }

        fun toDictionary(hmsLocalVideoStats: List<HMSLocalVideoStats>, track: HMSTrack, peer: HMSPeer): HashMap<String, Any?> {
            val args = HashMap<String, Any?>()
            args["peer"] = HMSPeerExtension.toDictionary(peer)!!
            args["track"] = HMSTrackExtension.toDictionary(track)!!

            val hmsLocalVideoStatsMap = ArrayList<HashMap<String, Any?>>()

            hmsLocalVideoStats.forEach {
                val layerStatsMap = HashMap<String, Any?>()
                layerStatsMap["bytes_sent"] = it.bytesSent
                layerStatsMap["bitrate"] = it.bitrate
                layerStatsMap["round_trip_time"] = it.roundTripTime
                layerStatsMap["frame_rate"] = it.frameRate
                layerStatsMap["resolution"] = HMSVideoResolutionExtension.toDictionary(it.resolution)
                layerStatsMap["quality_limitation_reason"] = toDictionary(it.qualityLimitationReason)
                layerStatsMap["hms_layer"] = HMSSimulcastLayerExtension.getStringFromLayer(it.hmsLayer)
                hmsLocalVideoStatsMap.add(layerStatsMap)
            }

            args["local_video_stats"] = hmsLocalVideoStatsMap
            return args
        }

        fun toDictionary(qualityLimitationReason: QualityLimitationReasons): HashMap<String, Any?> {
            val qualityLimitationReasonMap = HashMap<String, Any?>()
            qualityLimitationReasonMap["band_width"] = qualityLimitationReason.bandWidth
            qualityLimitationReasonMap["cpu"] = qualityLimitationReason.cpu
            qualityLimitationReasonMap["none"] = qualityLimitationReason.none
            qualityLimitationReasonMap["other"] = qualityLimitationReason.other
            qualityLimitationReasonMap["quality_limitation_resolution_changes"] = qualityLimitationReason.qualityLimitationResolutionChanges
            qualityLimitationReasonMap["reason"] = qualityLimitationReason.reason.name
            return qualityLimitationReasonMap
        }
    }
}
