package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSCommonAction
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.models.HMSPeer

class HMSPeerAction {
    companion object{
        // MARK: Peer Actions
        fun peerActions(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk: HMSSDK
        ) {
            when (call.method) {
                "change_metadata" -> {
                    changeMetadata(call, result,hmssdk)
                }
                "change_name" -> {
                    changeName(call, result,hmssdk)
                }
                "raise_local_peer_hand"->{
                    raiseLocalPeerHand(result,hmssdk)
                }
                "lower_local_peer_hand"->{
                    lowerLocalPeerHand(result,hmssdk)
                }
                "lower_remote_peer_hand"->{
                    lowerRemotePeerHand(call,result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun changeMetadata(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk:HMSSDK
        ) {
            val metadata = call.argument<String?>("metadata")

            metadata?.let {
                hmssdk.changeMetadata(
                    it,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result),
                )
            }
        }

        private fun changeName(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk: HMSSDK
        ) {
            val name = call.argument<String?>("name")

            name?.let {
                hmssdk.changeName(
                    name = name,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result),
                )
            }
        }

        private fun lowerLocalPeerHand(
            result: MethodChannel.Result,
            hmssdk: HMSSDK
        ) {
            hmssdk.lowerLocalPeerHand(HMSCommonAction.getActionListener(result))
        }

        private fun raiseLocalPeerHand(
            result: MethodChannel.Result,
            hmssdk: HMSSDK
        ) {
            hmssdk.raiseLocalPeerHand(HMSCommonAction.getActionListener(result))
        }

        private fun lowerRemotePeerHand(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk: HMSSDK
        ){
            val peerId = call.argument<String?>("peer_id")
            peerId?.let{
                var forPeer : HMSPeer? = null
                hmssdk.getPeers().forEach{ peer ->
                   if(peer.peerID==peerId) {
                       forPeer = peer
                       return@forEach
                   }
                }
                forPeer?.let {
                    hmssdk.lowerRemotePeerHand(it,HMSCommonAction.getActionListener(result))
                }

            }
        }
    }
}