package live.hms.hmssdk_flutter
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.error.HMSException
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import io.flutter.plugin.common.MethodChannel.Result


class HMSCommonAction {
    companion object {
        fun getLocalPeer(hmssdk:HMSSDK): HMSLocalPeer? {
            return hmssdk.getLocalPeer()
        }
        fun getPeerById(id: String,hmssdk:HMSSDK): HMSPeer? {
            if (id == "") return getLocalPeer(hmssdk)
            val peers = hmssdk.getPeers()
            peers.forEach {
                if (it.peerID == id) return it
            }

            return null
        }

        fun getActionListener(result: Result) = object: HMSActionResultListener {
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
    }
}