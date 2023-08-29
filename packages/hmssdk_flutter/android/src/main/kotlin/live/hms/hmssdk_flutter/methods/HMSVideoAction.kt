package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.utils.HmsUtilities

class HMSVideoAction {
    companion object {
        fun videoActions(call: MethodCall, result: Result, hmssdk: HMSSDK, hmssdkFlutterPlugin: HmssdkFlutterPlugin?) {
            when (call.method) {
                "switch_video" -> {
                    switchVideo(call, result, hmssdk)
                }

                "switch_camera" -> {
                    switchCamera(result, hmssdk, hmssdkFlutterPlugin)
                }

                "is_video_mute" -> {
                    result.success(isVideoMute(call, hmssdk))
                }

                "mute_room_video_locally" -> {
                    toggleVideoMuteAll(true, result, hmssdk)
                }

                "un_mute_room_video_locally" -> {
                    toggleVideoMuteAll(false, result, hmssdk)
                }

                "toggle_camera_mute_state" -> {
                    toggleCameraMuteState(result, hmssdk, hmssdkFlutterPlugin)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchVideo(call: MethodCall, result: Result, hmssdk: HMSSDK) {
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

        private fun toggleCameraMuteState(result: Result, hmssdk: HMSSDK, hmssdkFlutterPlugin: HmssdkFlutterPlugin?) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            if (videoTrack != null) {
                videoTrack.setMute(!(videoTrack.isMute))
                result.success(true)
            } else {
                // /Checking whether preview for role audio track exist or not
                if (hmssdkFlutterPlugin?.previewForRoleVideoTrack != null) {
                    val previewTrack = hmssdkFlutterPlugin.previewForRoleVideoTrack
                    previewTrack?.setMute(!(previewTrack.isMute))
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
        }

        private fun switchCamera(result: Result, hmssdk: HMSSDK, hmssdkFlutterPlugin: HmssdkFlutterPlugin?) {
            val peer = hmssdk.getLocalPeer()
            var videoTrack = peer?.videoTrack
            if (videoTrack == null) {
                // /Checking whether preview for role audio track exist or not
                if (hmssdkFlutterPlugin?.previewForRoleVideoTrack != null) {
                    videoTrack = hmssdkFlutterPlugin.previewForRoleVideoTrack
                } else {
                    return
                }
            }
            CoroutineScope(Dispatchers.Default).launch {
                videoTrack?.switchCamera(onAction = HMSCommonAction.getActionListener(result))
            }
        }

        private fun isVideoMute(call: MethodCall, hmssdk: HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")
            if (peerId == "null") {
                return hmssdk.getLocalPeer()?.videoTrack?.isMute ?: true
            }
            val peer = HMSCommonAction.getPeerById(peerId!!, hmssdk)
            return peer?.videoTrack?.isMute ?: true
        }

        private fun toggleVideoMuteAll(shouldMute: Boolean, result: Result, hmssdk: HMSSDK) {
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
