package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.*
import live.hms.video.error.HMSException
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.listeners.PeerListResultListener
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.PeerListIterator
import live.hms.video.sdk.models.PeerListIteratorOptions

class HMSPeerListIteratorAction {

    companion object{

        /**
         * [peerListIterators] stores the iterators with unique id's.
         * This is used whenever we call [peerListIteratorHasNext], or [peerListIteratorNext]
         * we fetch the respective peerListIterator based on the uid passed from flutter channel
         * and execute the method based on it.
         */
        private var peerListIterators = HashMap<String,PeerListIterator>()

        fun peerListIteratorAction(
            call: MethodCall,
            result: MethodChannel.Result,
            hmssdk: HMSSDK,
        ){
            when(call.method){
                "get_peer_list_iterator"-> {
                    getPeerListIterator(call,result,hmssdk)
                }
                "peer_list_iterator_has_next" -> {
                    peerListIteratorHasNext(call,result)
                }
                "peer_list_iterator_next" -> {
                    peerListIteratorNext(call,result)
                }
            }
        }

        /**
         * This method returns the peer list iterator based on the parameter we pass from flutter channel
         */
        private fun getPeerListIterator(call: MethodCall,result:MethodChannel.Result,hmssdk: HMSSDK){
            val uid = call.argument<String?>("uid")

            uid?.let {id ->
                val peerListOptionsMap = call.argument<HashMap<String,Any>?>("peer_list_iterator_options")

                var peerListIteratorOptions : PeerListIteratorOptions? = null

                peerListOptionsMap?.let {

                    val limit = it["limit"] as Int?

                    limit?.let {limitValue ->
                        peerListIteratorOptions   = PeerListIteratorOptions(byRoleName = it["by_role_name"] as String?,
                            byPeerIds = it["by_peer_ids"] as ArrayList<String>?, limit = limitValue)
                    }?:run{
                        HMSErrorLogger.returnHMSException("getPeerListIterator","limit parameter is null while peerListIteratorOptions is non-null","NULL Error",result)
                    }
                }

                val peerListIterator = hmssdk.getPeerListIterator(peerListIteratorOptions)

                /**
                 * We store the iterator in [peerListIterators] map for later operations with key as [id] which unique
                 * id for the iterator
                 */
                peerListIterators[id] = peerListIterator

                result.success(HMSResultExtension.toDictionary(true,PeerListIteratorExtension.toDictionary(peerListIterator,id)))

            }?:run {
                HMSErrorLogger.returnHMSException("getPeerListIterator","uid is null","NULL Error",result)
            }
        }

        /**
         * Method to check whether iterator has next set of peers or not
         */
        private fun peerListIteratorHasNext(call: MethodCall,result:MethodChannel.Result){
            val uid = call.argument<String?>("uid")

            uid?.let {

                /**
                 * Here we find the iterator with [uid] passed from flutter channel
                 * Since we need to perform the operation on that specific iterator
                 */
                val peerListIterator = peerListIterators[it]

                peerListIterator?.let { iterator ->
                    result.success(HMSResultExtension.toDictionary(true,iterator.hasNext()))
                }?: run{
                    HMSErrorLogger.returnHMSException("peerListIteratorHasNext","No peerListIterator with given uid found","NULL Error",result)
                }

            }?:run {
                HMSErrorLogger.returnHMSException("peerListIteratorHasNext","uid is null","NULL Error",result)
            }
        }

        /**
         * Method to get a list of next set of peers in iterator, the number of peers returned is equal to
         * the limit.
         */
        private fun peerListIteratorNext(call: MethodCall,methodChannelResult:MethodChannel.Result){
            val uid = call.argument<String?>("uid")

            uid?.let {

                /**
                 * Here we find the iterator with [uid] passed from flutter channel
                 * Since we need to perform the operation on that specific iterator
                 */
                val peerListIterator = peerListIterators[it]

                peerListIterator?.let{ iterator ->
                    iterator.next(object : PeerListResultListener{
                        override fun onError(error: HMSException) {
                            methodChannelResult.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.toDictionary(error)))
                        }

                        override fun onSuccess(result: ArrayList<HMSPeer>) {
                            val peerList = ArrayList<Any?>()
                            result.forEach { peer ->
                                peerList.add(HMSPeerExtension.toDictionary(peer))
                            }
                            methodChannelResult.success(HMSResultExtension.toDictionary(true,peerList))
                        }}
                        )
                    }   ?:run {
                    HMSErrorLogger.returnHMSException("peerListIteratorNext","No peerListIterator with given uid found","NULL Error",methodChannelResult)

                }

            }?:run {
                HMSErrorLogger.returnHMSException("peerListIteratorNext","uid is null","NULL Error",methodChannelResult)
            }
        }

        /**
         * This method clears the iterator map on leave, end Room or onRemovedFromRoom method calls
         */
        fun clearIteratorMap(){
            peerListIterators.clear()
        }
    }
}