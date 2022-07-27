package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.sdk.models.role.PermissionsParams

class PermissionParamsExtension {
    companion object{
        fun toDictionary(permissionsParams: PermissionsParams?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(permissionsParams==null)return null
            args["un_mute"] = permissionsParams.unmute
            args["change_role"] = permissionsParams.changeRole
            args["end_room"] = permissionsParams.endRoom
            args["mute"] = permissionsParams.mute
            args["change_role_force"] = permissionsParams.changeRoleForce
            args["remove_others"] = permissionsParams.removeOthers
            args["stop_presentation"] = permissionsParams.recording
            args["streaming"] = permissionsParams.streaming
            return args
        }
    }
}