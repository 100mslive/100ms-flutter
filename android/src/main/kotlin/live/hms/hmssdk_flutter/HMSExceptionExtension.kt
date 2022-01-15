package live.hms.hmssdk_flutter

import live.hms.video.error.HMSException
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.enums.HMSPeerUpdate

class HMSExceptionExtension {
    companion object{
        fun toDictionary(hmsException: HMSException?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if (hmsException==null)return null
            args.put("action",hmsException.action)
            args.put("code",hmsException.code)
            args.put("description",hmsException.description)
            args.put("name",hmsException.name)
            args.put("message",hmsException.message)
            args.put("isTerminal", hmsException.isTerminal)

            val errorArgs=HashMap<String,Any>()
            errorArgs.put("error",args)
            return errorArgs
        }
    }
}