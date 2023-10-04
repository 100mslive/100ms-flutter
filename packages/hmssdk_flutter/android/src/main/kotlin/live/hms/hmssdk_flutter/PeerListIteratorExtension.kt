package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.PeerListIterator

class PeerListIteratorExtension {

    companion object{

        fun toDictionary(peerListIterator: PeerListIterator,uid: String):HashMap<String,Any?>{
            val map = HashMap<String, Any?>()

            map["limit"] = peerListIterator.limit
            map["total_count"] = peerListIterator.totalCount
            map["uid"] = uid

            return map
        }
    }
}