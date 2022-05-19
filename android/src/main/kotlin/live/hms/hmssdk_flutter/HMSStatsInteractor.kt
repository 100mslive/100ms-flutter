package live.hms.hmssdk_flutter

import live.hms.video.connection.stats.*
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.models.HMSPeer
import io.flutter.plugin.common.EventChannel

class HMSStatsInteractor(var rtcSink: EventChannel.EventSink?): HMSStatsObserver {



    override fun onLocalAudioStats(
        audioStats: HMSLocalAudioStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {
        TODO("Not yet implemented")
    }

    override fun onLocalVideoStats(
        videoStats: HMSLocalVideoStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {
        TODO("Not yet implemented")
    }

    override fun onRTCStats(rtcStats: HMSRTCStatsReport) {
        TODO("Not yet implemented")
    }

    override fun onRemoteAudioStats(
        audioStats: HMSRemoteAudioStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {
        TODO("Not yet implemented")
    }

    override fun onRemoteVideoStats(
        videoStats: HMSRemoteVideoStats,
        hmsTrack: HMSTrack?,
        hmsPeer: HMSPeer?
    ) {
        TODO("Not yet implemented")
    }
}