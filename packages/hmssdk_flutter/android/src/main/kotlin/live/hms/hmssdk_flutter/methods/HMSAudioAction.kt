package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.utils.HmsUtilities

class HMSAudioAction {
    companion object {
        fun audioActions(call: MethodCall, result: Result, hmssdk: HMSSDK, hmssdkFlutterPlugin: HmssdkFlutterPlugin?) {
            when (call.method) {
                "switch_audio" -> {
                    switchAudio(call, result, hmssdk)
                }
                "is_audio_mute" -> {
                    result.success(isAudioMute(call, hmssdk))
                }
                "mute_room_audio_locally" -> {
                    toggleAudioMuteAll(true, result, hmssdk)
                }
                "un_mute_room_audio_locally" -> {
                    toggleAudioMuteAll(false, result, hmssdk)
                }
                "set_volume" -> {
                    setVolume(call, result, hmssdk)
                }
                "toggle_mic_mute_state" -> {
                    toggleMicMuteState(result, hmssdk, hmssdkFlutterPlugin)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchAudio(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val argsIsOn = call.argument<Boolean>("is_on")
            val peer = hmssdk.getLocalPeer()
            val audioTrack = peer?.audioTrack
            if (audioTrack != null) {
                audioTrack?.setMute(argsIsOn!!)
                result.success(true)
            } else {
                result.success(false)
            }
        }

        private fun toggleMicMuteState(result: Result, hmssdk: HMSSDK, hmssdkFlutterPlugin: HmssdkFlutterPlugin?) {
            val peer = hmssdk.getLocalPeer()
            val audioTrack = peer?.audioTrack
            if (audioTrack != null) {
                audioTrack?.setMute(!(audioTrack.isMute))
                result.success(true)
            } else {
                // /Checking whether preview for role audio track exist or not
                if (hmssdkFlutterPlugin?.previewForRoleAudioTrack != null) {
                    val previewTrack = hmssdkFlutterPlugin.previewForRoleAudioTrack
                    previewTrack?.setMute(!(previewTrack.isMute))
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
        }

        private fun toggleAudioMuteAll(shouldMute: Boolean, result: Result, hmssdk: HMSSDK) {
            val room: HMSRoom? = hmssdk.getRoom()
            if (room != null) {
                val audioTracks: List<HMSAudioTrack> = HmsUtilities.getAllAudioTracks(room)
                audioTracks.forEach { it ->
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = (!shouldMute)
                    }
                }
            }
        }

        private fun setVolume(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id")
            val volume = call.argument<Double>("volume")

            val room: HMSRoom? = hmssdk.getRoom()
            if (room != null && trackId != null && volume != null) {
                val audioTrack: HMSAudioTrack? = HmsUtilities.getAudioTrack(trackId, room)
                if (audioTrack != null) {
                    if (audioTrack is HMSRemoteAudioTrack) {
                        audioTrack.setVolume(volume)
                    } else if (audioTrack is HMSLocalAudioTrack) {
                        audioTrack.volume = volume
                    }
                    result.success(null)
                    return
                }
            }

            val map = HashMap<String, Map<String, String>>()
            val error = HashMap<String, String>()
            error["message"] = "Could not set volume"
            error["action"] = "NONE"
            error["description"] = "Track not found for setting volume"
            map["error"] = error
            result.success(map)
        }

        private fun isAudioMute(call: MethodCall, hmssdk: HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")

            if (peerId == "null") {
                return hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true
            }
            val peer = HMSCommonAction.getPeerById(peerId!!, hmssdk)
            return peer?.audioTrack?.isMute ?: true
        }
    }
}
