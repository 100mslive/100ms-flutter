package live.hms.hmssdk_flutter.poll_extension

import live.hms.video.polls.models.network.HMSPollResponsePeerInfo

class HMSPollResponsePeerInfoExtension {
    companion object {
        fun toDictionary(hmsPollResponsePeerInfo: HMSPollResponsePeerInfo?): HashMap<String, Any?>? {
            if (hmsPollResponsePeerInfo == null) {
                return null
            }

            val map = HashMap<String, Any?>()

            map["hash"] = hmsPollResponsePeerInfo.hash
            map["peer_id"] = hmsPollResponsePeerInfo.peerid
            map["user_id"] = hmsPollResponsePeerInfo.userid
            map["username"] = hmsPollResponsePeerInfo.username

            return map
        }
    }
}
