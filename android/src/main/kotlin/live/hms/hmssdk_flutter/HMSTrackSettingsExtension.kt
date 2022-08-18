package live.hms.hmssdk_flutter

import live.hms.hmssdk_flutter.hms_role_components.AudioParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.VideoParamsExtension
import live.hms.video.media.codec.HMSAudioCodec
import live.hms.video.media.codec.HMSVideoCodec
import live.hms.video.media.settings.HMSAudioTrackSettings
import live.hms.video.media.settings.HMSTrackSettings
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.sdk.HMSSDK

class HMSTrackSettingsExtension {

    companion object{
        fun toDictionary(hmssdk: HMSSDK):HashMap<String,Any>?{

            val map = HashMap<String,Any>();
            val hmsTrackSettings:HMSTrackSettings = hmssdk.hmsSettings;

            if(hmsTrackSettings.videoSettings != null){
                map["video_track_setting"] = HMSVideoTrackSettingsExtension.toDictionary(hmsTrackSettings.videoSettings)!!
            }

            if(hmsTrackSettings.audioSettings != null){
                map["audio_track_setting"] = HMSAudioTrackSettingsExtension.toDictionary(hmsTrackSettings.audioSettings)!!
            }

            return map
        }

        fun setTrackSettings(hmsAudioTrackHashMap:HashMap<String, Any?>?,hmsVideoTrackHashMap: HashMap<String,Any?>?):HMSTrackSettings{

            var hmsAudioTrackSettings = HMSAudioTrackSettings.Builder()
            if (hmsAudioTrackHashMap != null) {
                val maxBitRate = hmsAudioTrackHashMap["bit_rate"] as Int?
                val volume = hmsAudioTrackHashMap["volume"] as Double?
                val useHardwareAcousticEchoCanceler =
                    hmsAudioTrackHashMap["user_hardware_acoustic_echo_canceler"] as Boolean?
                val audioCodec =
                    AudioParamsExtension.getValueOfHMSAudioCodecFromString(hmsAudioTrackHashMap["audio_codec"] as String?) as HMSAudioCodec?

                if (maxBitRate != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.maxBitrate(maxBitRate)
                }

                if (volume != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.volume(volume)
                }

                if (useHardwareAcousticEchoCanceler != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.setUseHardwareAcousticEchoCanceler(
                        useHardwareAcousticEchoCanceler
                    )
                }

                if (audioCodec != null) {
                    hmsAudioTrackSettings = hmsAudioTrackSettings.codec(audioCodec)
                }
            }


            var hmsVideoTrackSettings = HMSVideoTrackSettings.Builder()
            if (hmsVideoTrackHashMap != null) {
                val maxBitRate = hmsVideoTrackHashMap["max_bit_rate"] as Int?
                val maxFrameRate = hmsVideoTrackHashMap["max_frame_rate"] as Int?
                val videoCodec =
                    VideoParamsExtension.getValueOfHMSAudioCodecFromString(hmsVideoTrackHashMap["video_codec"] as String?) as HMSVideoCodec?


                if (maxBitRate != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.maxBitrate(maxBitRate)
                }

                if (maxFrameRate != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.maxFrameRate(maxFrameRate)
                }
                if (videoCodec != null) {
                    hmsVideoTrackSettings = hmsVideoTrackSettings.codec(videoCodec)
                }
            }

            return HMSTrackSettings.Builder().audio(hmsAudioTrackSettings.build()).video(hmsVideoTrackSettings.build()).build()
        }
    }
}