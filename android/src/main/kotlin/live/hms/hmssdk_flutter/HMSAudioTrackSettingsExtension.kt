package live.hms.hmssdk_flutter

import live.hms.video.media.tracks.HMSTrack
import live.hms.video.media.tracks.HMSAudioTrack
import live.hms.video.utils.HMSLogger
import live.hms.video.media.settings.HMSAudioTrackSettings

class HMSAudioTrackSettingsExtension {
    companion object{
        fun toDictionary(hmsAudioTrackSettings: HMSAudioTrackSettings?):HashMap<String,Any>? {
            val map = HashMap<String,Any>()
            map["max_bit_rate"] = hmsAudioTrackSettings?.maxBitrate!!
            // map["track_description"] = hmsAudioTrackSettings?.track_description ?: ""
            map["volume"] = hmsAudioTrackSettings.volume
            // TODO: add audio codec
            return  map
        }
    }
}