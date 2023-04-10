package live.hms.hmssdk_flutter.methods

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class HMSPipAction {

    companion object {
        var pipResult: Result? = null
        private var pipAutoEnterEnabled = false
        private var pipAspectRatio = mutableListOf(16, 9)
        fun pipActions(call: MethodCall, result: Result, activity: Activity) {
            when (call.method) {
                "enter_pip_mode" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        enterPipMode(call, result, activity)
                    }
                }
                "is_pip_active" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        result.success(activity.isInPictureInPictureMode)
                    }
                }
                "is_pip_available" -> {
                    result.success(
                        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
                    )
                }
                "setup_pip" -> {
                    setupPIP(call,result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun setupPIP(call: MethodCall,result: Result){
            call.argument<List<Int>?>("ratio")?.let {
                pipAspectRatio = it.toMutableList()
            }
            call.argument<Boolean?>("auto_enter_pip")?.let {
                pipAutoEnterEnabled = it
            }
            result.success(null)
        }

        fun isPIPActive(activity: Activity): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                return activity.isInPictureInPictureMode
            }
            return false
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun enterPipMode(call: MethodCall, result: Result, activity: Activity) {
            call.argument<List<Int>>("aspect_ratio")?.let {
                pipAspectRatio = it.toMutableList()
            }
            call.argument<Boolean>("auto_enter_pip")?.let {
                pipAutoEnterEnabled = it
            }

            var params = PictureInPictureParams.Builder().setAspectRatio(Rational(pipAspectRatio[0], pipAspectRatio[1]))

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params = params.setAutoEnterEnabled(pipAutoEnterEnabled)
            }
            pipResult = result
            activity.enterPictureInPictureMode(params.build())
        }

        @RequiresApi(Build.VERSION_CODES.O)
        fun autoEnterPipMode(activity: Activity){
            if(pipAutoEnterEnabled){
                var params = PictureInPictureParams.Builder().setAspectRatio(Rational(pipAspectRatio[0], pipAspectRatio[1]))

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    params = params.setAutoEnterEnabled(pipAutoEnterEnabled)
                }
                activity.enterPictureInPictureMode(params.build())
            }
        }
    }
}
