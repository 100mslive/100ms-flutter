package live.hms.hmssdk_flutter

import live.hms.video.signal.init.TokenResult

class HMSTokenResultExtension {

    companion object {
        fun toDictionary(hmsTokenResult: TokenResult):HashMap<String,String?>{
            val hashMap = HashMap<String, String?>()

            hashMap["auth_token"] = hmsTokenResult.token
            hashMap["expires_at"] = hmsTokenResult.expiresAt

            return hashMap
        }
    }
}