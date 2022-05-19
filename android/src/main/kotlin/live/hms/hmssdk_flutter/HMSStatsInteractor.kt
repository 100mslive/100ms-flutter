package live.hms.hmssdk_flutter

import live.hms.video.connection.stats.*
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HMSCommonAction.Companion.getLocalPeer
import live.hms.video.sdk.models.HMSLocalPeer

class HMSStatsInteractor(val rtcSink: EventChannel.EventSink, var localPeer: HMSLocalPeer): HMSStatsObserver {

    override fun onRemoteVideoStats(
        videoStats: HMSRemoteVideoStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_remote_video_stats")
        args.put(
            "data",
            HMSRtcStatsExtension.toDictionary(
                hmsRemoteVideoStats = videoStats,
                peer = hmsPeer,
                track = hmsTrack
            )
        )

        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                rtcSink.success(args)
            }

    }

    override fun onRemoteAudioStats(
        audioStats: HMSRemoteAudioStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_remote_audio_stats")
        args.put(
            "data",
            HMSRtcStatsExtension.toDictionary(
                hmsRemoteAudioStats = audioStats,
                peer = hmsPeer,
                track = hmsTrack
            )
        )


        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                rtcSink.success(args)
            }

    }

    override fun onLocalVideoStats(
        videoStats: HMSLocalVideoStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_local_video_stats")
        args.put(
            "data",
            HMSRtcStatsExtension.toDictionary(
                hmsLocalVideoStats = videoStats,
                peer = localPeer,
                track = hmsTrack
            )
        )


        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                rtcSink.success(args)
            }

    }

    override fun onLocalAudioStats(
        audioStats: HMSLocalAudioStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_local_audio_stats")
        args.put(
            "data",
            HMSRtcStatsExtension.toDictionary(
                hmsLocalAudioStats = audioStats,
                peer = localPeer,
                track = hmsTrack
            )
        )

        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                rtcSink.success(args)
            }

    }

    override fun onRTCStats(rtcStats: HMSRTCStatsReport) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_rtc_stats")
        val dict = HashMap<String, Any?>()
        dict["bytes_sent"] = rtcStats.combined.bytesSent
        dict["bytes_received"] = rtcStats.combined.bitrateReceived
        dict["bitrate_sent"] = rtcStats.combined.bitrateSent
        dict["packets_received"] = rtcStats.combined.packetsReceived
        dict["packets_lost"] = rtcStats.combined.packetsLost
        dict["bitrate_received"] = rtcStats.combined.bitrateReceived
        dict["round_trip_time"] = rtcStats.combined.roundTripTime

        args.put("data", dict)
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                rtcSink.success(args)
            }
    }
}
