package live.hms.hmssdk_flutter.hls_player

import live.hms.hls_player.HmsHlsPlaybackState

class HMSHLSPlaybackStateExtension {
    companion object {
        fun toDictionary(hmsHlsPlaybackState: HmsHlsPlaybackState): HashMap<String, String> {
            val args = HashMap<String, String>()
            args["playback_state"] = when (hmsHlsPlaybackState) {
                HmsHlsPlaybackState.playing -> "playing"
                HmsHlsPlaybackState.stopped -> "stopped"
                HmsHlsPlaybackState.paused -> "paused"
                HmsHlsPlaybackState.buffering -> "buffering"
                HmsHlsPlaybackState.failed -> "failed"
                else -> "unknown"
            }
            return args
        }
    }
}
