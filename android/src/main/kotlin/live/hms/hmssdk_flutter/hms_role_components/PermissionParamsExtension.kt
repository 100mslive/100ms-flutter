package live.hms.hmssdk_flutter.hms_role_components

import live.hms.video.sdk.models.role.PermissionsParams

class PermissionParamsExtension {
    companion object{
        fun toDictionary(permissionsParams: PermissionsParams?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(permissionsParams==null)return null
            args.put("ask_to_un_mute",permissionsParams.unmute)
            args.put("change_role",permissionsParams.changeRole)
            args.put("end_room",permissionsParams.endRoom)
            args.put("mute_all",permissionsParams.endRoom)
            args.put("mute_selective",permissionsParams.changeRoleForce)
            args.put("remove_others",permissionsParams.removeOthers)
            args.put("stop_presentation",permissionsParams.recording)
            return args
        }
    }
}