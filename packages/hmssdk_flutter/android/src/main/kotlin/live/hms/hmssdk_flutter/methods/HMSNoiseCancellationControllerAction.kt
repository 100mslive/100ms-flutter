package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.video.factories.noisecancellation.AvailabilityStatus
import live.hms.video.sdk.HMSSDK

class HMSNoiseCancellationControllerAction {
    companion object {
        fun noiseCancellationActions(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ) {
            when (call.method) {
                "enable_noise_cancellation" -> {
                    enable(result, hmssdk)
                }
                "disable_noise_cancellation" -> {
                    disable(result, hmssdk)
                }
                "is_noise_cancellation_enabled" -> {
                    isEnabled(result, hmssdk)
                }
                "is_noise_cancellation_available" -> {
                    isAvailable(result, hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        /**
         * [enable] method enables noise cancellation for the user
         */
        private fun enable(
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ) {
            hmssdk.enableNoiseCancellation(true,HMSCommonAction.getActionListener(result))
        }

        /**
         * [disable] method disables noise cancellation for the user
         */
        private fun disable(
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ) {
            hmssdk.enableNoiseCancellation(false, HMSCommonAction.getActionListener(result))
        }

        /**
         * [isEnabled] method returns whether noise cancellation is enabled or not
         */
        private fun isEnabled(
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ) {
            val isEnabled = hmssdk.isNoiseCancellationEnabled()
            result.success(HMSResultExtension.toDictionary(true, isEnabled))
        }

        /**
         * [isAvailable] method returns whether noise cancellation is available in the room
         */
        private fun isAvailable(
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ) {
            val availabilityStatus = hmssdk.isNoiseCancellationSupported()
            if (availabilityStatus == AvailabilityStatus.Available) {
                result.success(HMSResultExtension.toDictionary(true, data = true))
            } else {
                val reason = (availabilityStatus as AvailabilityStatus.NotAvailable).reason
                HMSErrorLogger.logError("isAvailable", reason, "NoiseCancellation Error")
                result.success(HMSResultExtension.toDictionary(true, data = false))
            }
        }
    }
}
