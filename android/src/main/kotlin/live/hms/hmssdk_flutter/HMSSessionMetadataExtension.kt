package live.hms.hmssdk_flutter

class HMSSessionMetadataExtension {
    companion object{
        fun toDictionary(metadata: String?):HashMap<String,Any?>?{

            val hashMap=HashMap<String,Any?>()

            hashMap["metadata"] = metadata

            return hashMap
        }
    }
}