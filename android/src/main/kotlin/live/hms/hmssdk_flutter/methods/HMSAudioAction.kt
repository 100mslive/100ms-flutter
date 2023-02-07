package live.hms.hmssdk_flutter

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
                    result.success(isAudioMute(result,call, hmssdk))
                }
                "mute_room_audio_locally" -> {
                    toggleAudioMuteAll(result,true, hmssdk)
                }
                "un_mute_room_audio_locally" -> {
                    toggleAudioMuteAll(result,false, hmssdk)
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
            val argsIsOn = call.argument<Boolean>("is_on")?:
            run{
                logError("switchAudio","argsIsOn is null","Parameter Error")
                result.success(false)
                return
            }
            val peer = hmssdk.getLocalPeer()
            val audioTrack = peer?.audioTrack
            audioTrack ?:
            run {
                logError("switchAudio","audioTrack is null","Null Error")
                result.success(false)
                return
            }
            audioTrack.setMute(argsIsOn)
            result.success(true)

        }

        private fun toggleMicMuteState(result: Result, hmssdk: HMSSDK) {
            val peer = hmssdk.getLocalPeer()
            val audioTrack = peer?.audioTrack ?:
            run {
                logError("toggleMicMuteState","audioTrack is null","Null Error")
                result.success(false)
                return
            }
            audioTrack.setMute(!(audioTrack.isMute))
            result.success(true)
        }

        private fun toggleAudioMuteAll(result: Result,shouldMute: Boolean, hmssdk: HMSSDK) {
            val room: HMSRoom? = hmssdk.getRoom()
            room ?:
            run {
                logError("toggleAudioMuteAll","room is null","Null Error")
                result.success(false)
                return
            }
            val audioTracks: List<HMSAudioTrack> = HmsUtilities.getAllAudioTracks(room)
            audioTracks.forEach {
                if (it is HMSRemoteAudioTrack) {
                    it.isPlaybackAllowed = (!shouldMute)
                }
            }
            result.success(true)
        }

        private fun setVolume(call: MethodCall, result: Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id")?:
                run{
                    logError("setVolume","trackId is null","Parameter Error")
                    result.success(HMSExceptionExtension.getError("trackId is null in setVolume"))
                    return
                }
            val volume = call.argument<Double>("volume")?:
                run{
                    logError("setVolume","volume is null","Parameter Error")
                    result.success(HMSExceptionExtension.getError("volume is null in setVolume"))
                    return
                }

            val room: HMSRoom? = hmssdk.getRoom()
            room ?:
            run{
                logError("setVolume","room is null","Null Error")
                result.success(HMSExceptionExtension.getError("room is null in setVolume"))
                return
            }
            val audioTrack: HMSAudioTrack? = HmsUtilities.getAudioTrack(trackId, room)
            audioTrack ?:
            run{
                logError("setVolume","audioTrack is null","Null Error")
                result.success(HMSExceptionExtension.getError("Can't find audioTrack to set volume in setVolume"))
                return
            }
            if (audioTrack is HMSRemoteAudioTrack) {
                audioTrack.setVolume(volume)
            } else if (audioTrack is HMSLocalAudioTrack) {
                audioTrack.volume = volume
            }
            result.success(null)
        }

        private fun isAudioMute(result:Result,call: MethodCall, hmssdk: HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")?: returnError("isAudioMute error peerId is null")

            if(peerId != null){
                // If peerId is sent as "null" then we return the mute state for local peer
                if (peerId == "null") {
                    result.success(hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true)
                    return hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true
                }
                val peer = HMSCommonAction.getPeerById(peerId as String, hmssdk)
                result.success(hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true)
                return peer?.audioTrack?.isMute ?: true
            }

            //If peerId is null then we send the result as true
            result.success(true)
            return true
        }
    }
}
