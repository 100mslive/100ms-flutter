package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.media.codec.HMSAudioCodec
import live.hms.video.sdk.models.role.AudioParams

class AudioParamsExtension {
    companion object {
        fun toDictionary(audioParams: AudioParams): HashMap<String, Any>? {
            val args = HashMap<String, Any>()
            if (audioParams == null || audioParams.codec == null)return null
            args.put("bit_rate", audioParams.bitRate)
            args.put("codec", getValueOfHMSAudioCodec(audioParams.codec))
            return args
        }

        fun getValueOfHMSAudioCodec(codec: HMSAudioCodec): String {
            return when (codec) {
                HMSAudioCodec.OPUS ->
                    "opus"
                else ->
                    "defaultCodec"
            }
        }

        fun getValueOfHMSAudioCodecFromString(codec: String?): HMSAudioCodec? {
            return when (codec) {
                "opus" ->
                    HMSAudioCodec.OPUS
                else ->
                    null
            }
        }
    }
}
