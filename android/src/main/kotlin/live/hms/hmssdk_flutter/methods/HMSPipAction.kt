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
        fun pipActions(call: MethodCall, result: Result, activity : Activity){
            when(call.method){
                "enter_pip_mode"->{
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    enterPipMode(call,result,activity)
                }
                "is_pip_active"->{
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    result.success(activity.isInPictureInPictureMode)
                }
                "is_pip_available"->{
                    result.success(
                        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
                    )
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun enterPipMode(call: MethodCall, result: Result,activity:Activity){
            val aspectRatio = call.argument<List<Int>>("aspect_ratio")
            val autoEnterEnabled = call.argument<Boolean>("auto_enter_pip")

            var params = PictureInPictureParams.Builder().setAspectRatio(Rational(aspectRatio!![0],aspectRatio[1]))

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params = params.setAutoEnterEnabled(autoEnterEnabled!!)
            }
            pipResult = result
            activity.enterPictureInPictureMode(params.build())
        }

    }
}