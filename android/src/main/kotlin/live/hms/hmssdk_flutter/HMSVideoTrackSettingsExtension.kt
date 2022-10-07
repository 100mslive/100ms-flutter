package live.hms.hmssdk_flutter

import live.hms.video.media.codec.HMSVideoCodec
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.utils.HMSLogger

class HMSVideoTrackSettingsExtension {
    companion object{
        fun toDictionary(hmsVideoTrackSettings: HMSVideoTrackSettings?):HashMap<String,Any>?{
            val map = HashMap<String,Any>()
            map["camera_facing"] = getValueOfHMSCameraFacing(hmsVideoTrackSettings?.cameraFacing)!!
            map["disable_auto_resize"] = hmsVideoTrackSettings?.disableAutoResize!!
            map["track_initial_state"] = HMSTrackInitStateExtension.getValueFromHMSTrackInitState(hmsVideoTrackSettings.initialState)
            return  map
        }


        private fun getValueOfHMSCameraFacing(cameraFacing: HMSVideoTrackSettings.CameraFacing?):String?{
            if(cameraFacing==null)return null

            return when(cameraFacing){
                HMSVideoTrackSettings.CameraFacing.BACK-> "back"
                HMSVideoTrackSettings.CameraFacing.FRONT->"front"
                else-> "default"
            }
        }

    }
}