package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSRoleChangeRequest

class HMSRoleChangedExtension {
    companion object{
        fun toDictionary(role:HMSRoleChangeRequest):HashMap<String,Any>{
            val args=HashMap<String,Any>()
            args.put("peer",HMSPeerExtension.toDictionary(role.requestedBy)!!)
            args.put("role",HMSRoleExtension.toDictionary(role.suggestedRole)!!)
            args.put("token",role.token)
            val roleChanged=HashMap<String,Any>()
            roleChanged.put("role_change_request",args)
            return roleChanged
        }
    }
}