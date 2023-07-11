import live.hms.video.sdk.models.role.SubscribeDegradationParams

class HMSSubscribeDegradationParams {
    companion object {
        fun toDictionary(subscribeDegradationParams: SubscribeDegradationParams): HashMap<String, Any> {
            val args = HashMap<String, Any>()
            args["degrade_grace_period_seconds"] = subscribeDegradationParams.degradeGracePeriodSeconds
            args["packet_loss_threshold"] = subscribeDegradationParams.packetLossThreshold
            args["recover_grace_period_seconds"] = subscribeDegradationParams.recoverGracePeriodSeconds
            return args
        }
    }
}
