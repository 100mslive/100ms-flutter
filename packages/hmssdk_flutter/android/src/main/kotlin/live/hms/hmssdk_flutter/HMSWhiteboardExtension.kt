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
            whiteboardMap["owner"] = HMSPeerExtension.toDictionary(hmsWhiteboard.owner)
            whiteboardMap["title"] = hmsWhiteboard.title
            whiteboardMap["url"] = hmsWhiteboard.url

            return whiteboardMap
        }
    }
}