package live.hms.hmssdk_flutter.hls_player

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.Constants.Companion.HLS_PLAYER_INTENT
import live.hms.hmssdk_flutter.Constants.Companion.METHOD_CALL
import live.hms.hmssdk_flutter.HMSErrorLogger

class HMSHLSPlayerAction {
    companion object {
        fun hlsPlayerAction(call:MethodCall, result: Result, activity: Activity){
            when (call.method){
                "start_hls_player" -> start(result,activity)
                "stop_hls_player" -> stop(result,activity)
                "pause_hls_player" -> pause(result,activity)
                "resume_hls_player" -> resume(result,activity)
                "seek_to_live_position" -> seekToLivePosition(result,activity)
                "seek_forward" -> seekForward(call, result, activity)
                "seek_backward" -> seekBackward(call, result, activity)
                "set_hls_player_volume" -> setVolume(call, result, activity)
                "add_hls_stats_listener" -> addHLSStatsListener(result,activity)
                "remove_hls_stats_listener" -> removeHLSStatsListener(result,activity)
                else -> {
                    result.notImplemented()
                }
            }
        }


        private fun start(result: Result,activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"start_hls_player"))
            result.success(null)
        }

        private fun stop(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"stop_hls_player"))
            result.success(null)
        }

        private fun pause(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"pause_hls_player"))
            result.success(null)
        }

        private fun resume(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"resume_hls_player"))
            result.success(null)
        }

        private fun seekToLivePosition(result: Result, activity: Activity) {
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"seek_to_live_position"))
            result.success(null)
        }

        private fun seekForward(call: MethodCall, result: Result, activity: Activity) {
            val seconds: Long? = call.argument<Long?>("seconds") ?: run {
                HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekForward method")
                null
            }

            seconds?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"seek_forward").putExtra("seconds",seconds))
            }
            result.success(null)
        }

        private fun seekBackward(call: MethodCall, result: Result, activity: Activity) {
            val seconds: Long? = call.argument<Long?>("seconds") ?: run {
                HMSErrorLogger.returnArgumentsError("seconds parameter is null in seekForward method")
                null
            }

            seconds?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"seek_backward").putExtra("seconds",seconds))
            }
            result.success(null)
        }

        private fun setVolume(call:MethodCall,result: Result, activity: Activity){
            val volume: Int? = call.argument<Int?>("volume") ?:run {
                HMSErrorLogger.returnArgumentsError("Volume parameter is null in setVolume method")
                null
            }

            volume?.let {
                activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"set_volume").putExtra("volume",volume))
            }
            result.success(null)
        }

        private fun addHLSStatsListener(result: Result, activity: Activity){
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"add_hls_stats_listener"))
            result.success(null)
        }

        private fun removeHLSStatsListener(result: Result, activity: Activity){
            activity.sendBroadcast(Intent(HLS_PLAYER_INTENT).putExtra(METHOD_CALL,"remove_hls_stats_listener"))
            result.success(null)

        }
    }
}