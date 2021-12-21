package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.models.HMSRoom

class HMSRoomExtension {
    companion object{
        fun toDictionary(room:HMSRoom?):HashMap<String,Any?>?{
            val hashMap=HashMap<String,Any?>()

            if (room==null)return null
            hashMap.put("id",room.roomId )
            hashMap.put("name",room.name)
            hashMap.put("meta_data","")

            val args=ArrayList<Any>()
            room.peerList.forEach {
                io.flutter.Log.i("OnJoinAndroidSDk",it.toString())
                args.add(HMSPeerExtension.toDictionary(it)!!)
            }
            hashMap.put("peers",args)
            hashMap["rtmp_streaming_state"] = HMSStreamingState.toDictionary(room.rtmpHMSRtmpStreamingState)
            hashMap["browser_recording_state"] = HMSStreamingState.toDictionary(room.browserRecordingState)
            hashMap["server_recording_state"] = HMSStreamingState.toDictionary(room.serverRecordingState)
            return hashMap
        }
    }
}