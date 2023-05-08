package live.hms.hmssdk_flutter.methods

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSResultExtension
import live.hms.video.sdk.HMSSDK
import java.io.File
import java.util.*

class HMSCameraControlsAction {

    companion object {
        fun cameraControlsAction(call: MethodCall, result: Result, hmssdk: HMSSDK, context: Context) {
            when (call.method) {
                "is_tap_to_focus_supported" -> isTapToFocusSupported(result, hmssdk)
                "is_zoom_supported" -> isZoomSupported(result, hmssdk)
                "capture_image_at_max_supported_resolution" -> captureImageAtMaxSupportedResolution(call, result, hmssdk, context)
                "is_flash_supported" -> isFlashSupported(result, hmssdk)
                "toggle_flash" -> toggleFlash(result, hmssdk)
                else -> {
                    result.notImplemented()
                }
            }
        }

        // TODO: Complete the method
        private fun isTapToFocusSupported(result: Result, hmssdk: HMSSDK) {
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        HMSResultExtension.toDictionary(true, cameraControl.isTapToFocusSupported())
                        return
                    }
                }
            }
            result.success(false)
        }

        // TODO: Complete the method
        private fun isZoomSupported(result: Result, hmssdk: HMSSDK) {
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        HMSResultExtension.toDictionary(true, cameraControl.isZoomSupported())
                        return
                    }
                }
            }
            result.success(false)
        }

        /***
         * This is used to capture image at maximum resolution supported by the camera
         * Here we take the file path from user and save the image at that location
         * If flash is already on while calling this method then we turn OFF the flash
         */
        private fun captureImageAtMaxSupportedResolution(call: MethodCall, result: Result, hmssdk: HMSSDK, context: Context) {
            val withFlash: Boolean = call.argument<Boolean>("with_flash") ?: run {
                HMSErrorLogger.returnArgumentsError("withFlash parameter is null in captureImageAtMaxSupportedResolution method")
                false
            }

            // Creating a file at the application directory
            val dir = context.getExternalFilesDir("images")
            val filePath = "$dir/hms_${Date().time}.jpg"
            val imageFile = File(filePath)
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->

                        // If flash is already turned ON we turn it OFF before calling this method
                        if (cameraControl.isFlashEnabled()) {
                            cameraControl.setFlash(false)
                        }
                        if (withFlash) {
                            /***
                             * Here we check whether flash is supported by the currently facing camera device
                             */
                            if (cameraControl.isFlashSupported()) {
                                cameraControl.setFlash(true)
                            } else {
                                HMSErrorLogger.logError("captureImageAtMaxSupportedResolution", "Flash is not supported for current facing camera", "Compatibility error")
                            }
                        }
                        cameraControl.captureImageAtMaxSupportedResolution(imageFile) { isSuccess ->
                            // If the method call is successful we return null and in other case
                            // we return the HMSException map
                            if (isSuccess) {
                                result.success(HMSResultExtension.toDictionary(true, filePath))
                            } else {
                                result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Error in capturing image")))
                            }
                            if (withFlash) {
                                cameraControl.setFlash(false)
                            }
                        }

                        return
                    } ?: run {
                        result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("cameraControl is null")))
                        return
                    }
                } ?: run {
                    result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local video track is null")))
                    return
                }
            } ?: run {
                result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local peer is null")))
                return
            }
        }

        /***
         * This is used to check whether flash is supported by the current facing camera
         */
        private fun isFlashSupported(result: Result, hmssdk: HMSSDK) {
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        // Here we return whether flash is supported or not
                        result.success(HMSResultExtension.toDictionary(true, cameraControl.isFlashSupported()))
                        return
                    } ?: run {
                        result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("cameraControl is null")))
                        return
                    }
                } ?: run {
                    result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local video track is null")))
                    return
                }
            } ?: run {
                result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local peer is null")))
                return
            }
        }

        /***
         * This method is used to toggle the flash
         * Only if the flash is supported by the current facing camera
         * If video is muted then the flash light does not turn ON
         */
        private fun toggleFlash(result: Result, hmssdk: HMSSDK) {
            hmssdk.getLocalPeer()?.let { localPeer ->
                localPeer.videoTrack?.let { localVideoTrack ->
                    localVideoTrack.getCameraControl()?.let { cameraControl ->
                        if (cameraControl.isFlashSupported()) {
                            if (cameraControl.isFlashEnabled()) {
                                cameraControl.setFlash(false)
                            } else {
                                cameraControl.setFlash(true)
                            }
                            result.success(HMSResultExtension.toDictionary(true, null))
                            return
                        } else {
                            result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Flash is not supported for current facing camera, Also please ensure camera is turned ON")))
                            return
                        }
                    } ?: run {
                        result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("cameraControl is null")))
                        return
                    }
                } ?: run {
                    result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local video track is null")))
                    return
                }
            } ?: run {
                result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("local peer is null")))
                return
            }
        }
    }
}
