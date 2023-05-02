package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.sdk.models.role.PermissionsParams

class PermissionParamsExtension {
    companion object{
        fun toDictionary(permissionsParams: PermissionsParams?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(permissionsParams==null)return null
            args["browser_recording"] = permissionsParams.browserRecording
            args["change_role"] = permissionsParams.changeRole
            args["end_room"] = permissionsParams.endRoom
            args["hls_streaming"] = permissionsParams.hlsStreaming
            args["mute"] = permissionsParams.mute
            args["remove_others"] = permissionsParams.removeOthers
            args["rtmp_streaming"] = permissionsParams.rtmpStreaming
            args["un_mute"] = permissionsParams.unmute
            return args
        }
    }
}