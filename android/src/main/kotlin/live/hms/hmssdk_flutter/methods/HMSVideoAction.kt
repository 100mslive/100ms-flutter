package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.logError
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.returnError
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.utils.HmsUtilities

class HMSVideoAction {
    companion object {
        fun videoActions(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            when (call.method) {
                "switch_video" -> {
                    switchVideo(call, result, hmssdk)
                }

                "switch_camera" -> {
                    switchCamera(result, hmssdk)
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
                    toggleCameraMuteState(result, hmssdk)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchVideo(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val argsIsOn = call.argument<Boolean>("is_on") ?:
            run{
                logError("switchVideo","argsIsOn is null","Parameter Error")
                result.success(false)
                return
            }
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            videoTrack ?:
            run {
                logError("switchVideo","videoTrack is null","Null Error")
                result.success(false)
                return
            }
            videoTrack.setMute(argsIsOn)
            result.success(true)
        }

        private fun toggleCameraMuteState(result: Result, hmssdk: HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack ?:
            run {
                logError("toggleCameraMuteState","videoTrack is null","Null Error")
                result.success(false)
                return
            }
            videoTrack.setMute(!(videoTrack.isMute))
            result.success(true)
        }

        private fun switchCamera(result: Result, hmssdk: HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val videoTrack = peer?.videoTrack
            CoroutineScope(Dispatchers.Default).launch {
                videoTrack?.switchCamera(onAction = HMSCommonAction.getActionListener(result))
            }
            result.success(null)
        }

        private fun isVideoMute(call: MethodCall, hmssdk: HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")?: returnError("isVideoMute error peerId is null")

            if(peerId != null){
                if (peerId == "null") {
                    return hmssdk.getLocalPeer()?.videoTrack?.isMute ?: true
                }
                val peer = HMSCommonAction.getPeerById(peerId as String, hmssdk)
                return peer?.videoTrack?.isMute ?: true
            }
            //If peerId is null then we send the result as true
            return true
        }

        private fun toggleVideoMuteAll(shouldMute: Boolean, result: Result, hmssdk: HMSSDK) {
            val room: HMSRoom? = hmssdk.getRoom()
            room ?:
            run {
                logError("toggleVideoMuteAll","room is null","Null Error")
                result.success(false)
                return
            }
            val videoTracks: List<HMSVideoTrack> = HmsUtilities.getAllVideoTracks(room)
            videoTracks.forEach { it ->
                if (it is HMSRemoteVideoTrack) {
                    it.isPlaybackAllowed = (!shouldMute)
                }
            }
            HMSCommonAction.getLocalPeer(hmssdk)!!.videoTrack?.setMute((shouldMute))
            result.success(true)
        }
    }
}
