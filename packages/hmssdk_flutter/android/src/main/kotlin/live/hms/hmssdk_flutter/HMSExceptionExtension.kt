package live.hms.hmssdk_flutter

import live.hms.video.error.HMSException

class HMSExceptionExtension {
    companion object {
        fun toDictionary(hmsException: HMSException?): HashMap<String, Any>? {
            val args = HashMap<String, Any>()
            if (hmsException == null)return null
            args.put("action", hmsException.action)
            args.put("code", hmsException.code)
            args.put("description", hmsException.description)
            args.put("name", hmsException.name)
            args.put("message", hmsException.message)
            args.put("isTerminal", hmsException.isTerminal)

            val errorArgs = HashMap<String, Any>()
            errorArgs.put("error", args)
            return errorArgs
        }

        fun getError(
            description: String,
            message: String = "Check logs for more info",
        ): HashMap<String, Any> {
            val args = HashMap<String, Any>()

            args["action"] = "Check logs for more info"
            args["code"] = 6004
            args["description"] = description
            args["message"] = message
            args["isTerminal"] = false

            val errorArgs = HashMap<String, Any>()
            errorArgs["error"] = args
            return errorArgs
        }
    }
}
