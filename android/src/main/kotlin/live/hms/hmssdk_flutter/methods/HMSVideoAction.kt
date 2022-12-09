package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.utils.HmsUtilities

class HMSVideoAction {
    companion object {
        fun videoActions(call: MethodCall, result: Result,hmssdk: HMSSDK){
            when (call.method) {
                "switch_video" -> {
                    switchVideo(call, result,hmssdk)
                }

                "switch_camera" -> {
                    switchCamera(result,hmssdk)
                }

                "start_capturing" -> {
                    startCapturing(result,hmssdk)
                }

                "stop_capturing" -> {
                    stopCapturing(result,hmssdk)
                }

                "is_video_mute" -> {
                    result.success(isVideoMute(call,hmssdk))
                }

                "mute_room_video_locally"->{
                    toggleVideoMuteAll(true,result,hmssdk)
                }

                "un_mute_room_video_locally"->{
                    toggleVideoMuteAll(false,result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchVideo(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val argsIsOn = call.argument<Boolean>("is_on")
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            if (videoTrack != null) {
                videoTrack.setMute(argsIsOn ?: false)
                result.success(true)
            } else {
                result.success(false)
            }
        }


        private fun stopCapturing(result: Result,hmssdk:HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            if (videoTrack != null) {
                videoTrack.setMute(true)
                result.success(true)
            } else {
                result.success(false)
            }
        }

        private fun startCapturing(result: Result,hmssdk:HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            if (videoTrack != null) {
                videoTrack.setMute(false)
                result.success(true)
            } else {
                result.success(false)
            }
        }

        private fun switchCamera(result : Result,hmssdk:HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            CoroutineScope(Dispatchers.Default).launch {
                videoTrack?.switchCamera(onAction = HMSCommonAction.getActionListener(result))
            }
        }

        private fun isVideoMute(call: MethodCall,hmssdk:HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")
            if (peerId == "null") {
                return hmssdk.getLocalPeer()?.videoTrack?.isMute ?: true
            }
            val peer = HMSCommonAction.getPeerById(peerId!!,hmssdk)
            return peer?.videoTrack?.isMute?:true
        }

        private fun toggleVideoMuteAll(shouldMute : Boolean, result: Result,hmssdk:HMSSDK) {
            val room: HMSRoom? = hmssdk.getRoom()
            if (room != null) {
                val videoTracks: List<HMSVideoTrack> = HmsUtilities.getAllVideoTracks(room)
                videoTracks.forEach { it ->
                    if (it is HMSRemoteVideoTrack) {
                        it.isPlaybackAllowed = (!shouldMute)
                    }
                }
                HMSCommonAction.getLocalPeer(hmssdk)!!.videoTrack?.setMute((shouldMute))
            }
        }
    }
}