package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.sdk.models.role.HMSWhiteBoardPermission
import live.hms.video.sdk.models.role.PermissionsParams

class PermissionParamsExtension {
    companion object {
        fun toDictionary(permissionsParams: PermissionsParams?): HashMap<String, Any>? {
            val args = HashMap<String, Any>()
            if (permissionsParams == null)return null
            args["browser_recording"] = permissionsParams.browserRecording
            args["change_role"] = permissionsParams.changeRole
            args["end_room"] = permissionsParams.endRoom
            args["hls_streaming"] = permissionsParams.hlsStreaming
            args["mute"] = permissionsParams.mute
            args["remove_others"] = permissionsParams.removeOthers
            args["rtmp_streaming"] = permissionsParams.rtmpStreaming
            args["un_mute"] = permissionsParams.unmute
            args["poll_read"] = permissionsParams.pollRead
            args["poll_write"] = permissionsParams.pollWrite
            permissionsParams.whiteboard.let {
                args["whiteboard_permission"] = getMapFromHMSWhiteboardPermission(it)
            }
            return args
        }

        private fun getMapFromHMSWhiteboardPermission(hmsWhiteboardPermission: HMSWhiteBoardPermission): HashMap<String, Any?> {
            val permission = HashMap<String, Any?>()

            permission["admin"] = hmsWhiteboardPermission.admin
            permission["write"] = hmsWhiteboardPermission.write
            permission["read"] = hmsWhiteboardPermission.read

            return permission
        }
    }
}
