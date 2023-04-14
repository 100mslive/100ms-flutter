package live.hms.hmssdk_flutter.methods

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.video.sdk.HMSSDK
import java.io.File
import java.util.*

class HMSCameraControlsAction {

    companion object{
        fun cameraControlsAction(call:MethodCall,result:Result,hmssdk: HMSSDK,context: Context){
            when(call.method){
                "is_tap_to_focus_supported" -> isTapToFocusSupported(result,hmssdk)
                "is_zoom_supported" -> isZoomSupported(result,hmssdk)
                "capture_image_at_max_supported_resolution" -> captureImageAtMaxSupportedResolution(result,hmssdk,context)
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

        /***
         * This is used to capture image at maximum resolution supported by the camera
         * Here we take the file path from user and save the image at that location
         */
        private fun captureImageAtMaxSupportedResolution(result: Result,hmssdk: HMSSDK,context: Context){

            //Creating a file at the application directory
            val dir = context.getExternalFilesDir("images")
            val filePath = "$dir/hms_${Date().time}.JPEG"
            val imageFile = File(filePath)
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        cameraControl.captureImageAtMaxSupportedResolution(imageFile){ isSuccess ->
                            //If the method call is successful we return null and in other case
                            //we return the HMSException map
                            if(isSuccess){
                                result.success(HMSResultExtension.toDictionary(true,filePath))
                            }
                            else{
                                result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.getError("Error in capturing image")))
                            }
                        }
                        return
                    }?: run {
                        result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.getError("cameraControl is null")))
                        return
                    }
                }?: run {
                    result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.getError("local video track is null")))
                    return
                }
            }?: run{
                result.success(HMSResultExtension.toDictionary(false,HMSExceptionExtension.getError("local peer is null")))
                return
            }
        }
    }
}