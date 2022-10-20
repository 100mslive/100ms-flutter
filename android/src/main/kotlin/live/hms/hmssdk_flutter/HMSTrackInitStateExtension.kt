package live.hms.hmssdk_flutter

import live.hms.video.media.settings.HMSTrackSettings

class HMSTrackInitStateExtension {
    companion object{
        fun getHMSTrackInitStatefromValue(value:String):HMSTrackSettings.InitState{
            return when(value){
                "MUTED" -> HMSTrackSettings.InitState.MUTED
                "UNMUTED" -> HMSTrackSettings.InitState.UNMUTED
                else->HMSTrackSettings.InitState.MUTED
            }
        }

        fun getValueFromHMSTrackInitState(hmsTrackInitState:HMSTrackSettings.InitState):String{
            return when(hmsTrackInitState){
                HMSTrackSettings.InitState.UNMUTED-> "UNMUTED"
                HMSTrackSettings.InitState.MUTED-> "MUTED"
                else->"MUTED"
            }
        }
    }
}