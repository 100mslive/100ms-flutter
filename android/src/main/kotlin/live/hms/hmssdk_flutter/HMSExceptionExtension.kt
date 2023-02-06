package live.hms.hmssdk_flutter

import live.hms.video.error.HMSException
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSExceptionExtension {
    companion object{
        fun toDictionary(hmsException: HMSException?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if (hmsException==null)return null
            args["action"] = hmsException.action
            args["code"] = hmsException.code
            args["description"] = hmsException.description
            args["name"] = hmsException.name
            args["message"] = hmsException.message
            args["isTerminal"] = hmsException.isTerminal

            val errorArgs=HashMap<String,Any>()
            errorArgs["error"] = args
            return errorArgs
        }
    }
}