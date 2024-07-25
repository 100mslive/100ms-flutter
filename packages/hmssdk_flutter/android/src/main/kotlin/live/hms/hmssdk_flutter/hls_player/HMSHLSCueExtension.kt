package live.hms.hmssdk_flutter.hls_player

import live.hms.hls_player.HmsHlsCue
import java.text.SimpleDateFormat

class HMSHLSCueExtension {
    companion object {
        fun toDictionary(hmsHlsCue: HmsHlsCue): HashMap<String, Any?> {
            val args = HashMap<String, Any?>()

            args["id"] = hmsHlsCue.id
            args["start_date"] = hmsHlsCue.startDate
            args["end_date"] = hmsHlsCue.endDate
            args["payload"] = hmsHlsCue.payloadval

            return args
        }
    }
}
