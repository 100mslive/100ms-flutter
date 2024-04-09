
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSHLSVariantExtension
import live.hms.video.sdk.models.*

class HMSStreamingState {
    companion object {
        fun toDictionary(rtmpStreamingState: HMSRtmpStreamingState?): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            if (rtmpStreamingState == null) return null

            map["running"] = rtmpStreamingState.running

            map["error"] = HMSExceptionExtension.toDictionary(rtmpStreamingState.error)

            rtmpStreamingState.startedAt?.let {
                map["started_at"] = it
            }

            map["state"] = rtmpStreamingState.state.name

            return map
        }

        fun toDictionary(serverRecordingState: HMSServerRecordingState?): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            if (serverRecordingState == null) return null

            map["running"] = serverRecordingState.running

            map["error"] = HMSExceptionExtension.toDictionary(serverRecordingState.error)

            serverRecordingState.startedAt?.let {
                map["started_at"] = it
            }

            map["state"] = serverRecordingState.state.name

            return map
        }

        fun toDictionary(browserRecordingState: HMSBrowserRecordingState?): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            if (browserRecordingState == null) return null

            map["running"] = browserRecordingState.running

            map["error"] = HMSExceptionExtension.toDictionary(browserRecordingState.error)

            browserRecordingState.startedAt?.let {
                map["started_at"] = it
            }

            map["initialising"] = browserRecordingState.initialising

            map["state"] = browserRecordingState.state.name

            return map
        }

        fun toDictionary(hlsStreamingState: HMSHLSStreamingState?): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            if (hlsStreamingState == null) return null

            map["running"] = hlsStreamingState.running

            val args = ArrayList<Any>()
            hlsStreamingState.variants?.forEach {
                args.add(HMSHLSVariantExtension.toDictionary(it)!!)
            }

            map["variants"] = args

            map["state"] = hlsStreamingState.state.name

            return map
        }

        fun toDictionary(hlsRecordingState: HmsHlsRecordingState?): HashMap<String, Any?>? {
            val map = HashMap<String, Any?>()
            if (hlsRecordingState == null) return null

            map["running"] = hlsRecordingState.running

            hlsRecordingState.startedAt?.let {
                map["started_at"] = it
            }

            map["state"] = hlsRecordingState.state.name

            return map
        }
    }
}
