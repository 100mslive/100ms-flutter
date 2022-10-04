package live.hms.hmssdk_flutter

import live.hms.hmssdk_flutter.hms_role_components.AudioParamsExtension
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
            map["codec"]=AudioParamsExtension.getValueOfHMSAudioCodec(hmsAudioTrackSettings.codec)
            map["user_hardware_acoustic_echo_canceler"] = hmsAudioTrackSettings.useHardwareAcousticEchoCanceler
            map["hms_audio_track_init_state"] = HMSTrackInitStateExtension.getValueFromHMSTrackInitState(hmsAudioTrackSettings.initialState)
            return  map
        }
    }
}