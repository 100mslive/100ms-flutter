package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.error.HMSException
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.signal.init.HMSTokenListener
import live.hms.video.signal.init.TokenResult

class HMSCommonAction {
    companion object {
        fun getLocalPeer(hmssdk: HMSSDK): HMSLocalPeer? {
            return hmssdk.getLocalPeer()
        }
        fun getPeerById(id: String, hmssdk: HMSSDK): HMSPeer? {
            if (id == "") return getLocalPeer(hmssdk)
            val peers = hmssdk.getPeers()
            peers.forEach {
                if (it.peerID == id) return it
            }

            return null
        }

        fun getActionListener(result: Result) = object : HMSActionResultListener {
            override fun onError(error: HMSException) {
                CoroutineScope(Dispatchers.Main).launch {
                    result.success(HMSExceptionExtension.toDictionary(error))
                }
            }

            override fun onSuccess() {
                CoroutineScope(Dispatchers.Main).launch {
                    result.success(null)
                }
            }
        }

        fun getTokenListener(result: Result) = object : HMSTokenListener {
            override fun onError(error: HMSException) {
                result.success(HMSResultExtension.toDictionary(success = false, data = HMSExceptionExtension.toDictionary(error)))
            }

            override fun onTokenSuccess(string: String) {
                result.success(HMSResultExtension.toDictionary(success = true, data = string))

            }
        }
    }
}
