package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSPeer
import live.hms.video.whiteboard.HMSWhiteboard

class HMSWhiteboardExtension {
    companion object{

        fun toDictionary(hmsWhiteboard: HMSWhiteboard?): HashMap<String,Any?>?{

            if(hmsWhiteboard == null){
                return null
            }

            val whiteboardMap = HashMap<String,Any?>()

            whiteboardMap["id"] =   hmsWhiteboard.id
            whiteboardMap["is_admin"] = hmsWhiteboard.isAdmin
            whiteboardMap["is_open"] = hmsWhiteboard.isOpen
            whiteboardMap["is_owner"] = hmsWhiteboard.isOwner
            whiteboardMap["is_presence_tracking_enabled"] = hmsWhiteboard.isPresenceTrackingEnabled
            whiteboardMap["owner"] = HMSPeerExtension.toDictionary(hmsWhiteboard.owner)
            whiteboardMap["title"] = hmsWhiteboard.title
            whiteboardMap["url"] = hmsWhiteboard.url

            return whiteboardMap
        }
    }
}