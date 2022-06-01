package live.hms.hmssdk_flutter

import android.util.Log
import live.hms.video.sdk.models.HMSRoom
import live.hms.video.sdk.models.enums.HMSRoomUpdate

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
                args.add(HMSPeerExtension.toDictionary(it)!!)
            }
            hashMap["local_peer"] = HMSPeerExtension.toDictionary(room.localPeer)
            hashMap["peers"] = args
            hashMap["rtmp_streaming_state"] = HMSStreamingState.toDictionary(room.rtmpHMSRtmpStreamingState)
            hashMap["browser_recording_state"] = HMSStreamingState.toDictionary(room.browserRecordingState)
            hashMap["server_recording_state"] = HMSStreamingState.toDictionary(room.serverRecordingState)
            hashMap["hls_streaming_state"] = HMSStreamingState.toDictionary(room.hlsStreamingState)
            hashMap["peer_count"] = room.peerCount
            hashMap["started_at"] = room.startedAt?:-1
            hashMap["session_id"] = room.sessionId
            return hashMap
        }

        fun getValueofHMSRoomUpdate(update:HMSRoomUpdate?):String?{
            if(update==null)return null

            return when(update){
                HMSRoomUpdate.ROOM_MUTED-> "room_unmuted"
                HMSRoomUpdate.ROOM_UNMUTED-> "room_muted"
                HMSRoomUpdate.SERVER_RECORDING_STATE_UPDATED-> "server_recording_state_updated"
                HMSRoomUpdate.RTMP_STREAMING_STATE_UPDATED-> "rtmp_streaming_state_updated"
                HMSRoomUpdate.HLS_STREAMING_STATE_UPDATED-> "hls_streaming_state_updated"
                HMSRoomUpdate.BROWSER_RECORDING_STATE_UPDATED-> "browser_recording_state_updated"
                HMSRoomUpdate.ROOM_NAME_UPDATED->"room_name_updated"
                HMSRoomUpdate.ROOM_PEER_COUNT_UPDATED->"room_peer_count_updated"
                else-> "defaultUpdate"
            }
        }
    }
}
