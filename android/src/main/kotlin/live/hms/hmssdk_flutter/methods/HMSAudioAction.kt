package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*



class HMSAudioAction {
    companion object {
        fun audioActions(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            when (call.method) {
                "switch_audio" -> {
                    switchAudio(call, result,hmssdk)
                }
                "is_audio_mute" -> {
                    result.success(isAudioMute(call,hmssdk))
                }
                "mute_all" -> {
                    muteAll(result,hmssdk)
                }
                "un_mute_all" -> {
                    unMuteAll(result,hmssdk)
                }
                "set_volume" -> {
                    setVolume(call, result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun switchAudio(call: MethodCall, result: Result,hmssdk:HMSSDK) {
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

        private fun muteAll(result: Result,hmssdk:HMSSDK) {
            val peersList = hmssdk.getRemotePeers()

            peersList.forEach {
                it.audioTrack?.isPlaybackAllowed = false
                it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = false
                    }
                }
            }
//        result(null)
        }

        private fun unMuteAll(result: Result,hmssdk:HMSSDK) {
            val peersList = hmssdk.getRemotePeers()

            peersList.forEach {
                it.audioTrack?.isPlaybackAllowed = true
                it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = true
                    }
                }
            }
//        result(null)
        }


        private fun setVolume(call: MethodCall, result: Result,hmssdk:HMSSDK){
            val trackId = call.argument<String>("track_id")
            val volume = call.argument<Double>("volume")

            hmssdk.getPeers().forEach { it ->
                if(it.audioTrack?.trackId == trackId){
                    if(it.audioTrack is HMSRemoteAudioTrack){
                        (it.audioTrack as HMSRemoteAudioTrack).setVolume(volume!!)
                        result.success(null)
                        return
                    }
                    else if(it.audioTrack is HMSLocalAudioTrack){
                        (it.audioTrack as HMSLocalAudioTrack).volume = volume!!
                        result.success(null)
                        return
                    }
                }

                it.auxiliaryTracks.forEach {
                    if(it.trackId == trackId && it is HMSRemoteAudioTrack){
                        it.setVolume(volume!!.toDouble())
                        result.success(null)
                        return
                    }
                }
            }

            val map = HashMap<String,Map<String,String>>()
            val error = HashMap<String, String>()
            error["message"] = "Could not set volume"
            error["action"] = "NONE"
            error["description"] = "Track not found for setting volume"
            map["error"] = error
            result.success(map)
        }

        private fun isAudioMute(call: MethodCall, hmssdk:HMSSDK): Boolean {
            val peerId = call.argument<String>("peer_id")

            if (peerId == "null") {
                return hmssdk.getLocalPeer()?.audioTrack?.isMute?:true
            }
            val peer = HMSCommonAction.getPeerById(peerId!!,hmssdk)
            return peer?.audioTrack?.isMute?:true
        }
    }
}