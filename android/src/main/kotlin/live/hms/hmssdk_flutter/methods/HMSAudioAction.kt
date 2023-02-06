package live.hms.hmssdk_flutter
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.logError
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.returnError
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.utils.HmsUtilities

class HMSAudioAction {
    companion object {
        fun audioActions(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            when (call.method) {
                "switch_audio" -> {
                    switchAudio(call, result, hmssdk)
                }
                "is_audio_mute" -> {
                    result.success(isAudioMute(call, hmssdk))
                }
                "mute_room_audio_locally" -> {
                    toggleAudioMuteAll(true, hmssdk)
                }
                "un_mute_room_audio_locally" -> {
                    toggleAudioMuteAll(false, hmssdk)
                }
                "set_volume" -> {
                    setVolume(call, result, hmssdk)
                }
                "toggle_mic_mute_state" -> {
                    toggleMicMuteState(result, hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchAudio(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val argsIsOn = call.argument<Boolean>("is_on")?: returnError("switchAudio error argsIsOn is null")
            if(argsIsOn != null){
                val peer = hmssdk.getLocalPeer()
                val audioTrack = peer?.audioTrack
                if (audioTrack != null) {
                    audioTrack.setMute(argsIsOn as Boolean)
                    result.success(true)
                } else {
                    logError("switchAudio","audioTrack is null","Null Error")
                    result.success(false)
                }
            }
        }

        private fun toggleMicMuteState(result: Result, hmssdk: HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val audioTrack = peer?.audioTrack
            if (audioTrack != null) {
                audioTrack.setMute(!(audioTrack.isMute))
                result.success(true)
            } else {
                logError("toggleMicMuteState","audioTrack is null","Null Error")
                result.success(false)
            }
        }

        private fun toggleAudioMuteAll(shouldMute: Boolean, hmssdk: HMSSDK) {
            val room: HMSRoom? = hmssdk.getRoom()
            if (room != null) {
                val audioTracks: List<HMSAudioTrack> = HmsUtilities.getAllAudioTracks(room)
                audioTracks.forEach { it ->
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = (!shouldMute)
                    }
                }
            }
            else{
                logError("toggleAudioMuteAll","room is null","Null Error")
            }
        }

        private fun setVolume(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id")?: returnError("setVolume error trackId is null")
            val volume = call.argument<Double>("volume")?: returnError("setVolume error volume is null")

            if(trackId != null && volume != null){
                val room: HMSRoom? = hmssdk.getRoom()
                if (room != null) {
                    val audioTrack: HMSAudioTrack? = HmsUtilities.getAudioTrack(trackId as String, room)
                    if (audioTrack != null) {
                        if (audioTrack is HMSRemoteAudioTrack) {
                            audioTrack.setVolume(volume as Double)
                        } else if (audioTrack is HMSLocalAudioTrack) {
                            audioTrack.volume = volume as Double
                        }
                        result.success(null)
                        return
                    }
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
            val peerId = call.argument<String>("peer_id")?: returnError("isAudioMute error peerId is null")

            if(peerId != null){
                // If peerId is sent as "null" then we return the mute state for local peer
                if (peerId == "null") {
                    return hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true
                }
                val peer = HMSCommonAction.getPeerById(peerId as String, hmssdk)
                return peer?.audioTrack?.isMute ?: true
            }

            //If peerId is null then we send the result as true
            return true
        }
    }
}
