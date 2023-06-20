package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSAudioTrackSettings
import live.hms.video.media.settings.HMSTrackSettings
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.sdk.HMSSDK

class HMSTrackSettingsExtension {

    companion object {
        fun toDictionary(hmssdk: HMSSDK): HashMap<String, Any>? {
            val map = HashMap<String, Any>()
            val hmsTrackSettings: HMSTrackSettings = hmssdk.hmsSettings

            if (hmsTrackSettings.videoSettings != null) {
                map["video_track_setting"] = HMSVideoTrackSettingsExtension.toDictionary(hmsTrackSettings.videoSettings)!!
            }

            if (hmsTrackSettings.audioSettings != null) {
                map["audio_track_setting"] = HMSAudioTrackSettingsExtension.toDictionary(hmsTrackSettings.audioSettings)!!
            }

            return map
        }

        fun setTrackSettings(hmsAudioTrackHashMap: HashMap<String, Any?>?, hmsVideoTrackHashMap: HashMap<String, Any?>?): HMSTrackSettings {
            var hmsAudioTrackSettings = HMSAudioTrackSettings.Builder()
            if (hmsAudioTrackHashMap != null) {
                val useHardwareAcousticEchoCanceler =
                    hmsAudioTrackHashMap["user_hardware_acoustic_echo_canceler"] as Boolean?

                val initialState = HMSTrackInitStateExtension.getHMSTrackInitStatefromValue(hmsAudioTrackHashMap["track_initial_state"] as String)

                /**
                 * Setting hardware acoustic echo canceler to false by default
                 * If no value is passed from flutter
                 */
                hmsAudioTrackSettings = if (useHardwareAcousticEchoCanceler != null) {
                    hmsAudioTrackSettings.setUseHardwareAcousticEchoCanceler(
                        useHardwareAcousticEchoCanceler,
                    )
                } else {
                    hmsAudioTrackSettings.setUseHardwareAcousticEchoCanceler(
                        false,
                    )
                }

                if (initialState != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.initialState(initialState)
                }
            }

            var hmsVideoTrackSettings = HMSVideoTrackSettings.Builder()
            if (hmsVideoTrackHashMap != null) {
                val cameraFacing = getHMSCameraFacingFromValue(hmsVideoTrackHashMap["camera_facing"] as String?)
                val disableAutoResize = hmsVideoTrackHashMap["disable_auto_resize"] as Boolean
                val initialState = HMSTrackInitStateExtension.getHMSTrackInitStatefromValue(hmsVideoTrackHashMap["track_initial_state"] as String)
                val forceSoftwareDecoder = hmsVideoTrackHashMap["force_software_decoder"] as Boolean

                if (cameraFacing != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.cameraFacing(cameraFacing)
                }
                if (disableAutoResize != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.disableAutoResize(disableAutoResize)
                }
                if (initialState != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.initialState(initialState)
                }
                if (forceSoftwareDecoder != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.forceSoftwareDecoder(forceSoftwareDecoder)
                }
            }

            return HMSTrackSettings.Builder().audio(hmsAudioTrackSettings.build()).video(hmsVideoTrackSettings.build()).build()
        }

        private fun getHMSCameraFacingFromValue(cameraFacing: String?): HMSVideoTrackSettings.CameraFacing {
            return when (cameraFacing) {
                "back" -> HMSVideoTrackSettings.CameraFacing.BACK
                "front" -> HMSVideoTrackSettings.CameraFacing.FRONT
                else -> HMSVideoTrackSettings.CameraFacing.FRONT
            }
        }
    }
}
