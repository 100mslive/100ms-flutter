package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.models.HMSRoom
import live.hms.video.sdk.models.enums.HMSRoomUpdate

class HMSRoomExtension {
    companion object{
        fun toDictionary(room:HMSRoom?,hmsRoomUpdate: HMSRoomUpdate?):HashMap<String,Any?>?{
            val hashMap=HashMap<String,Any?>()

            if (room==null)return null
            hashMap.put("id",room.roomId )
            hashMap.put("name",room.name)
            hashMap.put("meta_data","")
            if(hmsRoomUpdate != null){
                hashMap["update"] = hmsRoomUpdate.toString()
            }
            val args=ArrayList<Any>()
            room.peerList.forEach {
                //io.flutter.Log.i("OnJoinAndroidSDk",it.toString())
                args.add(HMSPeerExtension.toDictionary(it)!!)
            }
            hashMap.put("peers",args)
            hashMap.put("local_peer",HMSPeerExtension.toDictionary(room.localPeer)!!)
            hashMap["rtmp_streaming_state"] = HMSStreamingState.toDictionary(room.rtmpHMSRtmpStreamingState)
            hashMap["browser_recording_state"] = HMSStreamingState.toDictionary(room.browserRecordingState)
            hashMap["server_recording_state"] = HMSStreamingState.toDictionary(room.serverRecordingState)
            hashMap["hls_streaming_state"] = HMSStreamingState.toDictionary(room.hlsStreamingState)
            return hashMap
        }
    }
}