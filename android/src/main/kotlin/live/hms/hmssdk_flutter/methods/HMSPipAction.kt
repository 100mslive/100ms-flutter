package live.hms.hmssdk_flutter.methods

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSErrorLogger
import io.flutter.plugin.common.MethodChannel.Result

class HMSPipAction {

    companion object {
        var pipResult: Result? = null
        fun pipActions(call: MethodCall, result: Result, activity: Activity) {
            when (call.method) {
                "enter_pip_mode" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        enterPipMode(call, result, activity)
                    }
                    else{
                        result.success(false)
                    }
                }
                "is_pip_active" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        result.success(activity.isInPictureInPictureMode)
                    }
                }
                "is_pip_available" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N){
                        result.success(
                            activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
                        )
                    }
                    else{
                        result.success(false)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        fun isPIPActive(activity: Activity): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                return activity.isInPictureInPictureMode
            }
            return false
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun enterPipMode(call: MethodCall, result: MethodChannel.Result,activity:Activity){
            val aspectRatio = call.argument<List<Int>>("aspect_ratio") ?:
                run{
                    HMSErrorLogger.logError("enterPipMode", "aspectRatio is null", "Parameter Error")
                    result.success(false)
                    return
                }
            val autoEnterEnabled = call.argument<Boolean>("auto_enter_pip") ?:
                run{
                    HMSErrorLogger.logError("enterPipMode", "autoEnterEnabled is null", "Parameter Error")
                    result.success(false)
                    return
                }

            var params = PictureInPictureParams.Builder().setAspectRatio(Rational((aspectRatio)[0],aspectRatio[1]))

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params = params.setAutoEnterEnabled(autoEnterEnabled)
            }
            pipResult = result
            activity.enterPictureInPictureMode(params.build())
        }
    }
}
