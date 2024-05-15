package live.hms.hmssdk_flutter.hls_player

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HMSErrorLogger
import java.lang.ref.WeakReference

/**
 * This class is used to send actions from flutter plugin to HLS Player
 * We use broadcast receiver to forward the request to HMSHLSPlayer
 */
class HMSHLSPlayerAction {
    companion object {
        private var hlsActions: WeakReference<IHLSPlayerActionInterface>? = null

        fun hlsPlayerAction(
            call: MethodCall,
            result: Result,
        ) {
            when (call.method) {
                "start_hls_player" -> start(call, result)
                "stop_hls_player" -> stop(result)
                "pause_hls_player" -> pause(result)
                "resume_hls_player" -> resume(result)
                "seek_to_live_position" -> seekToLivePosition(result)
                "seek_forward" -> seekForward(call, result)
                "seek_backward" -> seekBackward(call, result)
                "set_hls_player_volume" -> setVolume(call, result)
                "add_hls_stats_listener" -> addHLSStatsListener(result)
                "remove_hls_stats_listener" -> removeHLSStatsListener(result)
                "are_closed_captions_supported" -> areClosedCaptionsSupported(result)
                "enable_closed_captions" -> enableClosedCaptions(result)
                "disable_closed_captions" -> disableClosedCaptions(result)
                "get_stream_properties" -> getStreamProperties(result)
                "get_hls_layers" -> getHLSLayers(result)
                "set_hls_layer" -> setHLSLayer(call, result)
                "get_current_hls_layer" -> getCurrentHLSLayer(result)
                else -> {
                    result.notImplemented()
                }
            }
        }

        fun assignInterfaceObject(actionObject: WeakReference<IHLSPlayerActionInterface>) {
            hlsActions = actionObject
        }

        /**
         * Starts the HLS player by sending a broadcast intent with the specified method call and HLS URL.
         *
         * @param call The method call object containing the HLS URL as an argument.
         * @param result The result object to be returned after starting the player.
         */
        private fun start(
            call: MethodCall,
            result: Result,
        ) {
            val hlsUrl = call.argument<String?>("hls_url")
            hlsActions?.let {
                it.get()?.start(hlsUrl, result)
            } ?: run {
                HMSErrorLogger.logError("start", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Stops the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after stopping the player.
         */
        private fun stop(result: Result) {
            hlsActions?.let {
                it.get()?.stop(result)
            } ?: run {
                HMSErrorLogger.logError("stop", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Pauses the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after pausing the player.
         */
        private fun pause(result: Result) {
            hlsActions?.let {
                it.get()?.pause(result)
            } ?: run {
                HMSErrorLogger.logError("pause", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Resumes the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after resuming the player.
         */
        private fun resume(result: Result) {
            hlsActions?.let {
                it.get()?.resume(result)
            } ?: run {
                HMSErrorLogger.logError("resume", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Seeks to the live position in the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after seeking to the live position.
         */
        private fun seekToLivePosition(result: Result) {
            hlsActions?.let {
                it.get()?.seekToLivePosition(result)
            } ?: run {
                HMSErrorLogger.logError("seekToLivePosition", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Seeks forward in the HLS player by the specified number of seconds, sending a broadcast intent with the seek duration.
         *
         * @param call The method call object containing the number of seconds to seek forward as an argument.
         * @param result The result object to be returned after seeking forward.
         */
        private fun seekForward(
            call: MethodCall,
            result: Result,
        ) {
            val seconds: Int? =
                call.argument<Int?>("seconds") ?: run {
                    HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekForward method")
                    null
                }

            seconds?.let {
                hlsActions?.let { _hlsActions ->
                    _hlsActions.get()?.seekForward(it, result)
                } ?: run {
                    HMSErrorLogger.logError("seekForward", "hlsActions is NULL", "NULL Error")
                }
            }
        }

        /**
         * Seeks backward in the HLS player by the specified number of seconds, sending a broadcast intent with the seek duration.
         *
         * @param call The method call object containing the number of seconds to seek backward as an argument.
         * @param result The result object to be returned after seeking backward.
         */
        private fun seekBackward(
            call: MethodCall,
            result: Result,
        ) {
            val seconds: Int? =
                call.argument<Int?>("seconds") ?: run {
                    HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekBackward method")
                    null
                }

            seconds?.let {
                hlsActions?.let { _hlsActions ->
                    _hlsActions.get()?.seekBackward(it, result)
                } ?: run {
                    HMSErrorLogger.logError("seekBackward", "hlsActions is NULL", "NULL Error")
                }
            }
        }

        /**
         * Sets the volume level of the HLS player by sending a broadcast intent with the specified volume value.
         *
         * @param call The method call object containing the volume level as an argument.
         * @param result The result object to be returned after setting the volume.
         */
        private fun setVolume(
            call: MethodCall,
            result: Result,
        ) {
            val volume: Int? =
                call.argument<Int?>("volume") ?: run {
                    HMSErrorLogger.returnArgumentsError("Volume parameter is null in setVolume method")
                    null
                }

            volume?.let {
                hlsActions?.let { _hlsActions ->
                    _hlsActions.get()?.setVolume(it, result)
                } ?: run {
                    HMSErrorLogger.logError("setVolume", "hlsActions is NULL", "NULL Error")
                }
            }
        }

        /**
         * Adds a listener to receive HLS player statistics by sending a broadcast intent with the corresponding method call.
         *
         * @param result The result object to be returned after adding the HLS stats listener.
         */
        private fun addHLSStatsListener(result: Result) {
            hlsActions?.let {
                it.get()?.addHLSStatsListener(result)
            } ?: run {
                HMSErrorLogger.logError("addHLSStatsListener", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Removes the listener for HLS player statistics by sending a broadcast intent with the corresponding method call.
         *
         * @param result The result object to be returned after removing the HLS stats listener.
         */
        private fun removeHLSStatsListener(result: Result) {
            hlsActions?.let {
                it.get()?.removeHLSStatsListener(result)
            } ?: run {
                HMSErrorLogger.logError("removeHLSStatsListener", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Checks whether closed captions are supported or not
         * This can be enabled/disabled from 100ms dashboard
         *
         * @param result The result object used to send response regarding closed captions
         */
        private fun areClosedCaptionsSupported(result: Result) {
            hlsActions?.let {
                it.get()?.areClosedCaptionsSupported(result)
            } ?: run {
                HMSErrorLogger.logError("areClosedCaptionsSupported", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Enable closed captions in the player
         *
         * @param result is the object to be returned after enabling closed captions
         */
        private fun enableClosedCaptions(result: Result) {
            hlsActions?.let {
                it.get()?.enableClosedCaptions(result)
            } ?: run {
                HMSErrorLogger.logError("enableClosedCaptions", "hlsActions is NULL", "NULL Error")
            }
        }

        /**
         * Disable closed captions in the player
         *
         * @param result is the object to be returned after disabling closed captions
         */
        private fun disableClosedCaptions(result: Result) {
            hlsActions?.let {
                it.get()?.disableClosedCaptions(result)
            } ?: run {
                HMSErrorLogger.logError("disableClosedCaptions", "hlsActions is NULL", "NULL Error")
            }
        }

        private fun getStreamProperties(result: Result) {
            hlsActions?.let {
                it.get()?.getStreamProperties(result)
            } ?: run {
                HMSErrorLogger.logError("getStreamProperties", "hlsActions is NULL", "NULL Error")
            }
        }

        private fun getHLSLayers(result: Result) {
            hlsActions?.let {
                it.get()?.getHLSLayers(result)
            } ?: run {
                HMSErrorLogger.logError("getHLSLayers", "hlsActions is NULL", "NULL Error")
            }
        }

        private fun setHLSLayer(
            call: MethodCall,
            result: Result,
        ) {
            val layerMap = call.argument<HashMap<Any, Any?>?>("layer")

            layerMap?.let {
                if (layerMap["resolution"] != null && layerMap["bitrate"] != null) {
                    hlsActions?.let {
                        it.get()?.setHLSLayer(layerMap, result)
                    } ?: run {
                        HMSErrorLogger.logError("getCurrentHLSLayer", "hlsActions is NULL", "NULL Error")
                    }
                }
            } ?: run {
                HMSErrorLogger.returnArgumentsError("hmsHLSLayer is null in setHLSLayer")
            }
        }

        private fun getCurrentHLSLayer(result: Result) {
            hlsActions?.let {
                it.get()?.getCurrentHLSLayer(result)
            } ?: run {
                HMSErrorLogger.logError("getCurrentHLSLayer", "hlsActions is NULL", "NULL Error")
            }
        }
    }
}
