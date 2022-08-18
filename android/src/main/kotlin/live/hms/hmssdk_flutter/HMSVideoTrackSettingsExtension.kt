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
            map["video_codec"] = getValueOfHMSVideoCodec(hmsVideoTrackSettings?.codec)!!
            map["max_bit_rate"] = hmsVideoTrackSettings?.maxBitRate!!
            map["max_frame_rate"] = hmsVideoTrackSettings.maxFrameRate
            map["disable_auto_resize"] = hmsVideoTrackSettings.disableAutoResize
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

        private fun getValueOfHMSVideoCodec(codec: HMSVideoCodec?):String?{
            if(codec==null)return null

            return when(codec){
                HMSVideoCodec.H264-> "h264"
                HMSVideoCodec.VP8->"vp8"
                HMSVideoCodec.VP9->"vp9"
                else-> "defaultCodec"
            }
        }
    }
}