package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSAudioTrackSettings
import live.hms.video.media.settings.HMSTrackSettings
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.media.settings.PhoneCallState
import live.hms.video.sdk.HMSSDK

class HMSTrackSettingsExtension {

    companion object {
        fun toDictionary(hmssdk: HMSSDK): HashMap<String, Any> {
            val map = HashMap<String, Any>()
            val hmsTrackSettings: HMSTrackSettings = hmssdk.hmsSettings

            hmsTrackSettings.audioSettings?.let { audioSettings ->
                val settings = HMSAudioTrackSettingsExtension.toDictionary(audioSettings)
                settings?.let {
                    map["audio_track_setting"] = it
                }
            }

            hmsTrackSettings.videoSettings?.let {
                val settings = HMSVideoTrackSettingsExtension.toDictionary(hmsTrackSettings.videoSettings)
                settings?.let {
                    map["video_track_setting"] = it
                }
            }

            return map
        }

        fun setTrackSettings(audio: HashMap<String, Any?>?, video: HashMap<String, Any?>?): HMSTrackSettings {
            val audioSettings = setAudioTrackSettings(audio)

            val videoSettings = setVideoTrackSettings(video)

            return HMSTrackSettings.Builder().audio(audioSettings.build()).video(videoSettings.build()).build()
        }

        private fun setAudioTrackSettings(audioMap: HashMap<String, Any?>?): HMSAudioTrackSettings.Builder {
            var settingsBuilder = HMSAudioTrackSettings.Builder()

            settingsBuilder.setUseHardwareAcousticEchoCanceler(false)
            settingsBuilder.enableEchoCancellation(true)
            settingsBuilder.enableNoiseSupression(true)
            settingsBuilder.enableAutomaticGainControl(true)
            settingsBuilder.setPhoneCallMuteState(PhoneCallState.DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING)

            audioMap?.let { audioHashMap ->

                val initialState = HMSTrackInitStateExtension.getHMSTrackInitStatefromValue(audioHashMap["track_initial_state"] as String)
                settingsBuilder = settingsBuilder.initialState(initialState)

                val useHardwareAcousticEchoCanceler =
                    audioHashMap["user_hardware_acoustic_echo_canceler"] as Boolean?
                useHardwareAcousticEchoCanceler?.let { useHardware ->
                    settingsBuilder.setUseHardwareAcousticEchoCanceler(useHardware)
                }

                val phoneCallMuteState = audioHashMap["phone_call_mute_state"] as? String
                phoneCallMuteState?.let { callMuteState ->
                    when (callMuteState) {
                        "ENABLE_MUTE_ON_PHONE_CALL_RING" -> settingsBuilder.setPhoneCallMuteState(PhoneCallState.ENABLE_MUTE_ON_PHONE_CALL_RING)
                        else -> settingsBuilder.setPhoneCallMuteState(PhoneCallState.DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING)
                    }
                }
            }

            return settingsBuilder
        }

        private fun setVideoTrackSettings(videoMap: HashMap<String, Any?>?): HMSVideoTrackSettings.Builder {
            var settingsBuilder = HMSVideoTrackSettings.Builder()

            videoMap?.let {
                settingsBuilder = settingsBuilder.disableAutoResize(it["disable_auto_resize"] as Boolean)

                settingsBuilder = settingsBuilder.forceSoftwareDecoder(it["force_software_decoder"] as Boolean)

                settingsBuilder = settingsBuilder.cameraFacing(getHMSCameraFacingFromValue(it["camera_facing"] as String?))

                settingsBuilder = settingsBuilder.initialState(HMSTrackInitStateExtension.getHMSTrackInitStatefromValue(it["track_initial_state"] as String))
            }
            return settingsBuilder
        }

        private fun getHMSCameraFacingFromValue(cameraFacing: String?): HMSVideoTrackSettings.CameraFacing {
            return when (cameraFacing) {
                "back" -> HMSVideoTrackSettings.CameraFacing.BACK
                else -> HMSVideoTrackSettings.CameraFacing.FRONT
            }
        }
    }
}
