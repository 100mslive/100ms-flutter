package live.hms.hmssdk_flutter.hls_player

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.Constants.Companion.HLS_PLAYER_INTENT
import live.hms.hmssdk_flutter.Constants.Companion.METHOD_CALL
import live.hms.hmssdk_flutter.HMSErrorLogger

/**
 * This class is used to send actions from flutter plugin to HLS Player
 * We use broadcast receiver to forward the request to HMSHLSPlayer
 */
class HMSHLSPlayerAction {
    companion object {
        fun hlsPlayerAction(call: MethodCall, result: Result, activity: Activity) {
            when (call.method) {
                "start_hls_player" -> start(call, result, activity)
                "stop_hls_player" -> stop(result, activity)
                "pause_hls_player" -> pause(result, activity)
                "resume_hls_player" -> resume(result, activity)
                "seek_to_live_position" -> seekToLivePosition(result, activity)
                "seek_forward" -> seekForward(call, result, activity)
                "seek_backward" -> seekBackward(call, result, activity)
                "set_hls_player_volume" -> setVolume(call, result, activity)
                "add_hls_stats_listener" -> addHLSStatsListener(result, activity)
                "remove_hls_stats_listener" -> removeHLSStatsListener(result, activity)
                else -> {
                    result.notImplemented()
                }
            }
        }

        /**
         * Starts the HLS player by sending a broadcast intent with the specified method call and HLS URL.
         *
         * @param call The method call object containing the HLS URL as an argument.
         * @param result The result object to be returned after starting the player.
         * @param activity The current activity from which the method is called.
         */
        private fun start(call: MethodCall, result: Result, activity: Activity) {
            val hlsUrl = call.argument<String?>("hls_url")
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "start_hls_player").putExtra("hls_url", hlsUrl))
            result.success(null)
        }

        /**
         * Stops the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after stopping the player.
         * @param activity The current activity from which the method is called.
         */
        private fun stop(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "stop_hls_player"))
            result.success(null)
        }

        /**
         * Pauses the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after pausing the player.
         * @param activity The current activity from which the method is called.
         */
        private fun pause(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "pause_hls_player"))
            result.success(null)
        }

        /**
         * Resumes the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after resuming the player.
         * @param activity The current activity from which the method is called.
         */
        private fun resume(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "resume_hls_player"))
            result.success(null)
        }

        /**
         * Seeks to the live position in the HLS player by sending a broadcast intent with the specified method call.
         *
         * @param result The result object to be returned after seeking to the live position.
         * @param activity The current activity from which the method is called.
         */
        private fun seekToLivePosition(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "seek_to_live_position"))
            result.success(null)
        }

        /**
         * Seeks forward in the HLS player by the specified number of seconds, sending a broadcast intent with the seek duration.
         *
         * @param call The method call object containing the number of seconds to seek forward as an argument.
         * @param result The result object to be returned after seeking forward.
         * @param activity The current activity from which the method is called.
         */
        private fun seekForward(call: MethodCall, result: Result, activity: Activity) {
            val seconds: Int? = call.argument<Int?>("seconds") ?: run {
                HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekForward method")
                null
            }

            seconds?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "seek_forward").putExtra("seconds", seconds))
            }
            result.success(null)
        }

        /**
         * Seeks backward in the HLS player by the specified number of seconds, sending a broadcast intent with the seek duration.
         *
         * @param call The method call object containing the number of seconds to seek backward as an argument.
         * @param result The result object to be returned after seeking backward.
         * @param activity The current activity from which the method is called.
         */
        private fun seekBackward(call: MethodCall, result: Result, activity: Activity) {
            val seconds: Int? = call.argument<Int?>("seconds") ?: run {
                HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekBackward method")
                null
            }

            seconds?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "seek_backward").putExtra("seconds", seconds))
            }
            result.success(null)
        }

        /**
         * Sets the volume level of the HLS player by sending a broadcast intent with the specified volume value.
         *
         * @param call The method call object containing the volume level as an argument.
         * @param result The result object to be returned after setting the volume.
         * @param activity The current activity from which the method is called.
         */
        private fun setVolume(call: MethodCall, result: Result, activity: Activity) {
            val volume: Int? = call.argument<Int?>("volume") ?: run {
                HMSErrorLogger.returnArgumentsError("Volume parameter is null in setVolume method")
                null
            }

            volume?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "set_volume").putExtra("volume", volume))
            }
            result.success(null)
        }

        /**
         * Adds a listener to receive HLS player statistics by sending a broadcast intent with the corresponding method call.
         *
         * @param result The result object to be returned after adding the HLS stats listener.
         * @param activity The current activity from which the method is called.
         */
        private fun addHLSStatsListener(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "add_hls_stats_listener"))
            result.success(null)
        }

        /**
         * Removes the listener for HLS player statistics by sending a broadcast intent with the corresponding method call.
         *
         * @param result The result object to be returned after removing the HLS stats listener.
         * @param activity The current activity from which the method is called.
         */
        private fun removeHLSStatsListener(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL, "remove_hls_stats_listener"))
            result.success(null)
        }
    }
}
