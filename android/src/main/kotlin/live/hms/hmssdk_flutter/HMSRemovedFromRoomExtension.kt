package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSRemovedFromRoom

class HMSRemovedFromRoomExtension {
    companion object{
        fun toDictionary(notification:HMSRemovedFromRoom?): HashMap<String, Any?>? {
            val hashMap = HashMap<String,Any?>()

            if(notification==null)return null
            hashMap["peer_who_removed"] = HMSPeerExtension.toDictionary(notification.peerWhoRemoved)
            hashMap["reason"] = notification.reason
            hashMap["room_was_ended"] = notification.roomWasEnded

            val roomMap = HashMap<String,Any?>()
            roomMap["removed_from_room"] = hashMap
            return roomMap
        }
    }
}