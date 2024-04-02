package live.hms.hmssdk_flutter.hms_role_components

import live.hms.hmssdk_flutter.HMSSimulcastSettingsExtension
import live.hms.video.sdk.models.role.PublishParams

class PublishParamsExtension {
    companion object {
        fun toDictionary(publishParams: PublishParams?): HashMap<String, Any?>? {
            val args = HashMap<String, Any?>()
            if (publishParams == null)return null

            publishParams.allowed?.let {
                args["allowed"] = publishParams.allowed
            }

            publishParams.audio?.let {
                args.put("audio", AudioParamsExtension.toDictionary(publishParams.audio!!))
            }

            publishParams.video?.let {
                args.put("video", VideoParamsExtension.toDictionary(publishParams.video!!))
            }

            publishParams.screen?.let {
                args.put("screen", VideoParamsExtension.toDictionary(publishParams?.screen!!))
            }

            publishParams.simulcast?.let {
                args.put("simulcast", HMSSimulcastSettingsExtension.toDictionary(publishParams?.simulcast!!))
            }

            return args
        }
    }
}
