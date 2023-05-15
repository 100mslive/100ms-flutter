package live.hms.hmssdk_flutter.hls_player

import live.hms.hls_player.HmsHlsCue
import java.text.SimpleDateFormat

class HMSHLSCueExtension {

    companion object{
        fun toDictionary(hmsHlsCue: HmsHlsCue):HashMap<String, String?>{
            val args = HashMap<String, String?>()

            args["id"] = hmsHlsCue.id
            args["start_date"] =  SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsHlsCue.startDate).toString()
            args["end_date"] = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hmsHlsCue.endDate).toString()
            args["payload"] = hmsHlsCue.payloadval

            return args
        }
    }
}