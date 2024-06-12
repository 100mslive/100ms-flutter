package live.hms.hmssdk_flutter

import live.hms.video.whiteboard.HMSWhiteboard
import live.hms.video.whiteboard.State

class HMSWhiteboardExtension {
    companion object {
        fun toDictionary(hmsWhiteboard: HMSWhiteboard?): HashMap<String, Any?>? {
            if (hmsWhiteboard == null) {
                return null
            }

            val whiteboardMap = HashMap<String, Any?>()

            whiteboardMap["id"] = hmsWhiteboard.id
            whiteboardMap["owner"] = HMSPeerExtension.toDictionary(hmsWhiteboard.owner)
            whiteboardMap["title"] = hmsWhiteboard.title
            whiteboardMap["url"] = hmsWhiteboard.url
            whiteboardMap["state"] = getStateFromString(hmsWhiteboard.state)
            whiteboardMap["is_owner"] = hmsWhiteboard.isOwner
            return whiteboardMap
        }

        private fun getStateFromString(state: State): String {
            return when (state) {
                State.Started -> "started"
                State.Stopped -> "stopped"
                else -> "stopped"
            }
        }
    }
}
