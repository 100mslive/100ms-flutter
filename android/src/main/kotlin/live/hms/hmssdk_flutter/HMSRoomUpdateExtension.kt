package live.hms.hmssdk_flutter

import live.hms.video.sdk.models.HMSRoom
import live.hms.video.sdk.models.enums.HMSRoomUpdate

class HMSRoomUpdateExtension {
    companion object{
        fun toDictionary(room:HMSRoom?,update: HMSRoomUpdate?):HashMap<String,Any?>?{
            val args=HashMap<String,Any?>()

            if (room==null)return null

            args["room"] = HMSRoomExtension.toDictionary(room)!!
            args["update"] = HMSRoomExtension.getValueOfHMSRoomUpdate(update)!!
            return args
        }
    }
}
