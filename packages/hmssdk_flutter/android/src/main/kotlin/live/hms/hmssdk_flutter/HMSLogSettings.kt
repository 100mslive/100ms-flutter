package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSLogSettings
import live.hms.video.utils.HMSLogger

class HMSLogSettings {

    companion object {

        fun setLogSettings(maxDirSizeInBytes: Double, logStorageEnabled: Boolean, logLevel: String): HMSLogSettings {
            return HMSLogSettings(maxDirSizeInBytes = maxDirSizeInBytes.toLong(), isLogStorageEnabled = logStorageEnabled, level = getLogLevel(logLevel))
        }

        private fun getLogLevel(logLevel: String?): HMSLogger.LogLevel {
            return when (logLevel) {
                "error" -> HMSLogger.LogLevel.ERROR
                "off" -> HMSLogger.LogLevel.OFF
                "verbose" -> HMSLogger.LogLevel.VERBOSE
                "warn" -> HMSLogger.LogLevel.WARN
                else -> HMSLogger.LogLevel.OFF
            }
        }
    }
}
