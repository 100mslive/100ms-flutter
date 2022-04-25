package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class HMSVideoAction {
    companion object {
        fun videoActions(call: MethodCall, result: Result,hmssdk: HMSSDK){
            when (call.method) {
                "switch_video" -> {
                    switchVideo(call, result,hmssdk)
                }

                "switch_camera" -> {
                    switchCamera(hmssdk)
                    result.success("switch_camera")
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

                "set_playback_allowed"->{
                    setPlayBackAllowed(call, result,hmssdk)
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

        private fun switchCamera(hmssdk:HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            CoroutineScope(Dispatchers.Default).launch {
                videoTrack?.switchCamera()
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

        private fun setPlayBackAllowed(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            val allowed = call.argument<Boolean>("allowed")
            hmssdk.getRemotePeers().forEach {
                it.videoTrack?.isPlaybackAllowed = allowed!!

                it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteVideoTrack) {
                        it.isPlaybackAllowed = allowed!!
                    }
                }
            }
            HMSCommonAction.getLocalPeer(hmssdk)!!.videoTrack?.setMute(!(allowed!!))
            result.success(null)
        }
    }
}