package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSAudioTrackSettings

class HMSAudioTrackSettingsExtension {
    companion object {
        fun toDictionary(hmsAudioTrackSettings: HMSAudioTrackSettings?): HashMap<String, Any>? {
            val map = HashMap<String, Any>()
            map["user_hardware_acoustic_echo_canceler"] = hmsAudioTrackSettings?.useHardwareAcousticEchoCanceler!!
            map["track_initial_state"] = HMSTrackInitStateExtension.getValueFromHMSTrackInitState(hmsAudioTrackSettings.initialState)
            return map
        }
    }
}
