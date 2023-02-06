package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSAudioTrackSettings
import live.hms.video.media.settings.HMSTrackSettings
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.sdk.HMSSDK

class HMSTrackSettingsExtension {

    companion object{
        fun toDictionary(hmssdk: HMSSDK):HashMap<String,Any>{

            val map = HashMap<String,Any>();
            val hmsTrackSettings:HMSTrackSettings = hmssdk.hmsSettings;

            if(hmsTrackSettings.videoSettings != null){
                map["video_track_setting"] = HMSVideoTrackSettingsExtension.toDictionary(hmsTrackSettings.videoSettings)!!
            }

            if(hmsTrackSettings.audioSettings != null){
                map["audio_track_setting"] = HMSAudioTrackSettingsExtension.toDictionary(hmsTrackSettings.audioSettings)
            }

            return map
        }

        fun setTrackSettings(hmsAudioTrackHashMap:HashMap<String, Any?>?,hmsVideoTrackHashMap: HashMap<String,Any?>?):HMSTrackSettings{

            var hmsAudioTrackSettings = HMSAudioTrackSettings.Builder()
            if (hmsAudioTrackHashMap != null) {
                val useHardwareAcousticEchoCanceler =
                    hmsAudioTrackHashMap["user_hardware_acoustic_echo_canceler"] as Boolean?

                val initialState = HMSTrackInitStateExtension.getHMSTrackInitStateFromValue(hmsAudioTrackHashMap["track_initial_state"] as String)

                if (useHardwareAcousticEchoCanceler != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.setUseHardwareAcousticEchoCanceler(
                        useHardwareAcousticEchoCanceler
                    )
                }

                hmsAudioTrackSettings = hmsAudioTrackSettings.initialState(initialState)
            }

            var hmsVideoTrackSettings = HMSVideoTrackSettings.Builder()
            if (hmsVideoTrackHashMap != null) {

                val cameraFacing =  getHMSCameraFacingFromValue(hmsVideoTrackHashMap["camera_facing"] as String?)

                val disableAutoResize = (hmsVideoTrackHashMap["disable_auto_resize"]?:false) as Boolean
                val initialState = HMSTrackInitStateExtension.getHMSTrackInitStateFromValue(hmsVideoTrackHashMap["track_initial_state"] as String)
                val forceSoftwareDecoder = (hmsVideoTrackHashMap["force_software_decoder"]?:false) as Boolean

                hmsVideoTrackSettings = hmsVideoTrackSettings.cameraFacing(cameraFacing)
                hmsVideoTrackSettings = hmsVideoTrackSettings.disableAutoResize(disableAutoResize)
                hmsVideoTrackSettings = hmsVideoTrackSettings.initialState(initialState)
                hmsVideoTrackSettings = hmsVideoTrackSettings.forceSoftwareDecoder(forceSoftwareDecoder)
            }

            return HMSTrackSettings.Builder().audio(hmsAudioTrackSettings.build()).video(hmsVideoTrackSettings.build()).build()
        }

        private fun getHMSCameraFacingFromValue(cameraFacing:String?):HMSVideoTrackSettings.CameraFacing{
            return when(cameraFacing){
                "back" -> HMSVideoTrackSettings.CameraFacing.BACK
                "front" -> HMSVideoTrackSettings.CameraFacing.FRONT
                else -> HMSVideoTrackSettings.CameraFacing.FRONT
            }
        }
    }
}