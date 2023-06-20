package live.hms.hmssdk_flutter

import live.hms.video.utils.HMSLogger

class HMSLogsExtension {
    companion object {
        fun toDictionary(
            level: HMSLogger.LogLevel,
            tag: String,
            message: String,
            isWebRtCLog: Boolean,
        ): HashMap<String, Any> {
            val map = HashMap<String, Any>()
            map["level"] = getValueOfHMSLog(level)!!
            map["tag"] = tag
            map["message"] = message
            map["is_web_rtc_log"] = isWebRtCLog

            return map
        }

        fun getValueOfHMSLog(level: HMSLogger.LogLevel?): String? {
            if (level == null)return null

            return when (level) {
                HMSLogger.LogLevel.DEBUG -> "debug"
                HMSLogger.LogLevel.ERROR -> "error"
                HMSLogger.LogLevel.INFO -> "info"
                HMSLogger.LogLevel.OFF -> "off"
                HMSLogger.LogLevel.VERBOSE -> "verbose"
                HMSLogger.LogLevel.WARN -> "warn"
                else -> "defaultUpdate"
            }
        }
    }
}
