package live.hms.hmssdk_flutter

class HMSResultExtension {

    companion object {
        fun toDictionary(success: Boolean, data: Any? = null): HashMap<String, Any?> {
            val hashMap = HashMap<String, Any?>()
            hashMap["success"] = success
            hashMap["data"] = data
            return hashMap
        }
    }
}
