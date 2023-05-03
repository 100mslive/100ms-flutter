package live.hms.hmssdk_flutter

import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.utils.HMSLogger
class HMSErrorLogger {

    companion object {

        private const val TAG = "FL_HMSSDK Error"

        /**
         * This method is used to log error without returning from the function
         * If you need to send the exception and error to flutter channel
         * then consider using [returnHMSException] method
         */
        fun logError(methodName: String, error: String, errorType: String) {
            HMSLogger.e(TAG, "$errorType: { method -> $methodName, error -> $error }")
        }

        /**
         * This method is used to log of arguments passed from flutter channel is null
         * This does not stop the function execution. Function still executes normally just
         * the variable becomes null and can be handled later
         */
        fun returnArgumentsError(errorMessage: String): Unit? {
            HMSLogger.e("FL_HMSSDK Args Error", errorMessage)
            return null
        }

        /**
         * This method is used to fire [HMSException] from native to flutter, here we
         * log the exception and then send the result to flutter with [success] as [false] and [data]
         * as [HMSException] map
         */
        fun returnHMSException(methodName: String, error: String, errorType: String, result: Result) {
            HMSLogger.e(TAG, "$errorType: { method -> $methodName, error -> $error }")
            result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError(description = error)))
        }
    }
}
