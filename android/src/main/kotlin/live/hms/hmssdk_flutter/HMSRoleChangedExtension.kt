package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSRoleChangeRequest

class HMSRoleChangedExtension {
    companion object{
        fun toDictionary(role:HMSRoleChangeRequest?):HashMap<String,Any>?{
            val args=HashMap<String,Any>()
            if(role==null)return null
            args.put("requested_by",HMSPeerExtension.toDictionary(role.requestedBy)!!)
            args.put("suggested_role",HMSRoleExtension.toDictionary(role.suggestedRole)!!)
            val roleChanged=HashMap<String,Any>()
            roleChanged.put("role_change_request",args)
            return roleChanged
        }
    }
}