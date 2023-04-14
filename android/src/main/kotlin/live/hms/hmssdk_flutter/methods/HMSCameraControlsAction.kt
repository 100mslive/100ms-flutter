package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.video.media.capturers.camera.CameraControl
import live.hms.video.media.tracks.HMSLocalVideoTrack
import live.hms.video.sdk.HMSSDK

class HMSCameraControlsAction {

    companion object{
        fun cameraControlsAction(call:MethodCall,result:Result,hmssdk: HMSSDK){
            when(call.method){
                "is_tap_to_focus_supported" -> isTapToFocusSupported(result,hmssdk)
                "is_zoom_supported" -> isZoomSupported(result,hmssdk)
                "capture_image_at_max_supported_resolution" -> captureImageAtMaxSupportedResolution(call,result,hmssdk)
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun isTapToFocusSupported(result: Result,hmssdk: HMSSDK){
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        HMSResultExtension.toDictionary(true,cameraControl.isTapToFocusSupported())
                        return
                    }
                }
            }
            result.success(false)
        }

        private fun isZoomSupported(result: Result,hmssdk: HMSSDK){
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        HMSResultExtension.toDictionary(true,cameraControl.isZoomSupported())
                        return
                    }
                }
            }
            result.success(false)
        }

        private fun captureImageAtMaxSupportedResolution(call: MethodCall,result: Result,hmssdk: HMSSDK){

            val filePath = call.argument<String>("file_path")?: run {

            }

            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        cameraControl.captureImageAtMaxSupportedResolution()
                        return
                    }
                }
            }
        }

    }
}