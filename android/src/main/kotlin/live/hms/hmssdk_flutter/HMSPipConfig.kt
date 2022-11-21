package live.hms.hmssdk_flutter

class HMSPipConfigExtension{

    companion object{
        fun setHMSPipConfig(hmsPipConfig: HashMap<String,Any>?):HMSPipConfig?{
            if (hmsPipConfig == null){
                return null;
            }
            return HMSPipConfig(aspectRatio = hmsPipConfig["aspect_ratio"] as List<Int>,
            autoEnterEnabled = hmsPipConfig["auto_enter_pip"] as Boolean,
            showAudioButton = hmsPipConfig["show_audio_button"] as Boolean,
            showVideoButton = hmsPipConfig["show_video_button"] as Boolean,
            showLeaveRoomButton = hmsPipConfig["show_leave_room_button"] as Boolean)
        }
    }
}

class HMSPipConfig(val aspectRatio:List<Int>, val autoEnterEnabled :Boolean = false, val showAudioButton:Boolean = false, val showVideoButton:Boolean = false, val showLeaveRoomButton:Boolean = false){}