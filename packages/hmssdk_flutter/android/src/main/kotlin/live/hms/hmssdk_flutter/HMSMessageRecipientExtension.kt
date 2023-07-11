package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSMessageRecipient
import live.hms.video.sdk.models.enums.HMSMessageRecipientType

class HMSMessageRecipientExtension {
    companion object {
        fun toDictionary(hmsMessageRecipient: HMSMessageRecipient?): HashMap<String, Any?>? {
            val hashMap = HashMap<String, Any?>()
            if (hmsMessageRecipient == null)return null

            hashMap["recipient_peer"] = HMSPeerExtension.toDictionary(hmsMessageRecipient.recipientPeer)

            val recipientRoles = ArrayList<HashMap<String, Any?>?>()
            hmsMessageRecipient.recipientRoles.forEach {
                recipientRoles.add(HMSRoleExtension.toDictionary(it))
            }
            hashMap["recipient_roles"] = if (recipientRoles.size != 0)recipientRoles else null

            hashMap["recipient_type"] = getValueOfHMSMessageRecipient(hmsMessageRecipient.recipientType)

            return hashMap
        }

        private fun getValueOfHMSMessageRecipient(hmsMessageRecipientType: HMSMessageRecipientType?): String? {
            if (hmsMessageRecipientType == null)return null
            return when (hmsMessageRecipientType) {
                HMSMessageRecipientType.BROADCAST -> "broadCast"
                HMSMessageRecipientType.PEER -> "peer"
                HMSMessageRecipientType.ROLES -> "roles"
                else -> "defaultRecipient"
            }
        }
    }
}
