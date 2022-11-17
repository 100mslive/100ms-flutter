package live.hms.hmssdk_flutter

class HMSPipConfigExtension{

    companion object{
        fun setHMSPipConfig(hmsPipConfig: HashMap<String,Any>?):HMSPipConfig?{
            if (hmsPipConfig == null){
                return null;
            }
            return HMSPipConfig(aspectRatio = hmsPipConfig["aspect_ratio"] as List<Int>,
            autoEnterEnabled = hmsPipConfig["auto_enter_pip"] as Boolean,
            addAudioMuteButton = hmsPipConfig["add_audio_mute_button"] as Boolean,
            addVideoMuteButton = hmsPipConfig["add_video_mute_button"] as Boolean,
            addLeaveRoomButton = hmsPipConfig["add_leave_room_button"] as Boolean)
        }
    }
}

class HMSPipConfig(val aspectRatio:List<Int>, val autoEnterEnabled :Boolean = false, val addAudioMuteButton:Boolean = false, val addVideoMuteButton:Boolean = false, val addLeaveRoomButton:Boolean = false){}