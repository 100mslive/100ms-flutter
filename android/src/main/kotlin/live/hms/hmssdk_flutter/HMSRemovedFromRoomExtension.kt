package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSRemovedFromRoom

class HMSRemovedFromRoomExtension {
    companion object{
        fun toDictionary(notification:HMSRemovedFromRoom?): HashMap<String, Any?>? {
            val hashMap = HashMap<String,Any?>()

            if(notification==null)return null
            hashMap.put("peer_who_removed",HMSPeerExtension.toDictionary(notification.peerWhoRemoved))
            hashMap.put("reason",notification.reason)
            hashMap.put("room_was_ended",notification.roomWasEnded)

            val roomMap = HashMap<String,Any?>()
            roomMap.put("removed_from_room",hashMap)
            return roomMap
        }
    }
}