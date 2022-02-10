package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.sdk.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class HMSRoomAction {
    companion object {
        fun roomActions(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            when (call.method) {
                "get_room" -> {
                    getRoom(result,hmssdk)
                }
                "get_local_peer" -> {
                    localPeer(result,hmssdk)
                }
                "get_remote_peers" -> {
                    getRemotePeers(result,hmssdk)
                }
                "get_peers" -> {
                    getPeers(result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        private fun getRoom(result: Result,hmssdk: HMSSDK) {
            result.success(HMSRoomExtension.toDictionary(hmssdk?.getRoom()))
        }
        private fun localPeer(result: Result,hmssdk: HMSSDK) {
            result.success(HMSPeerExtension.toDictionary(HMSCommonAction.getLocalPeer(hmssdk)))
        }
        private fun getRemotePeers(result: Result,hmssdk: HMSSDK) {
            val peersList = hmssdk.getRemotePeers()
            val peersMapList = ArrayList<HashMap<String, Any?>?>()
            peersList.forEach {
                peersMapList.add(HMSPeerExtension.toDictionary(it))
            }
            CoroutineScope(Dispatchers.Main).launch {
                result.success(peersMapList)
            }
        }

        // TODO: check behaviour when room is not joined
        private fun getPeers(result: Result,hmssdk: HMSSDK) {
            val peersList = hmssdk.getPeers()
            val peersMapList = ArrayList<HashMap<String, Any?>?>()
            peersList.forEach {
                peersMapList.add(HMSPeerExtension.toDictionary(it))
            }
            CoroutineScope(Dispatchers.Main).launch {
                result.success(peersMapList)
            }
        }
    }
}