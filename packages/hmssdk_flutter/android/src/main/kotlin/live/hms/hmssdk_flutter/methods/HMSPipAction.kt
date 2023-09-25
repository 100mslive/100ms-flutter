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
        private var isPIPEnabled = false
        private var pipParams : PictureInPictureParams.Builder? = null

        fun pipActions(
            call: MethodCall,
            result: Result,
            activity: Activity,
        ) {
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
                        activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE),
                    )
                }
                "setup_pip" -> {
                    setupPIP(call, result)
                }
                "destroy_pip" -> {
                    destroyPIP(call, result, activity)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun setupPIP(
            call: MethodCall,
            result: Result,
        ){
            isPIPEnabled = true
            call.argument<List<Int>?>("ratio")?.let {
                pipAspectRatio = it.toMutableList()
            }
            call.argument<Boolean?>("auto_enter_pip")?.let {
                pipAutoEnterEnabled = it
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                pipParams = PictureInPictureParams.Builder()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    pipParams?.setAutoEnterEnabled(pipAutoEnterEnabled)
                }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                pipParams?.build()
            }
            result.success(null)
        }

        private fun destroyPIP(
            call: MethodCall,
            result: Result,
            activity: Activity,
        ) {
            pipAspectRatio = mutableListOf(16, 9)
            pipAutoEnterEnabled = false
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && activity.isInPictureInPictureMode) {
                activity.moveTaskToBack(false)
            }
            result.success(true)
        }

        fun isPIPActive(activity: Activity): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                return activity.isInPictureInPictureMode
            }
            return false
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun enterPipMode(
            call: MethodCall,
            result: Result,
            activity: Activity,
        ) {
            isPIPEnabled = true
            call.argument<List<Int>>("aspect_ratio")?.let {
                pipAspectRatio = it.toMutableList()
            }
            call.argument<Boolean>("auto_enter_pip")?.let {
                pipAutoEnterEnabled = it
            }

            var params = pipParams?.setAspectRatio(Rational(pipAspectRatio[0], pipAspectRatio[1]))

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params = params?.setAutoEnterEnabled(pipAutoEnterEnabled)
            }
            pipResult = result
            params?.let {
                activity.enterPictureInPictureMode(it.build())
            }
        }

        fun enterPIP(activity: Activity){
            pipParams?.let {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    activity.enterPictureInPictureMode(it.build())
                } else {
                    TODO("VERSION.SDK_INT < O")
                }
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        fun autoEnterPipMode(activity: Activity) {
            if (pipAutoEnterEnabled && isPIPEnabled) {
                var params =pipParams?.setAspectRatio(Rational(pipAspectRatio[0], pipAspectRatio[1]))

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    params = params?.setAutoEnterEnabled(pipAutoEnterEnabled)
                }
                params?.let {
                    activity.enterPictureInPictureMode(it.build())
                }
            }
        }

        /**
         * This method only needs to be called when application is using PIP mode
         * [isPIPEnabled] variable keeps a track whether PIP was enabled in application or not
         */
        fun disposePIP(activity: Activity) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && isPIPEnabled) {
                pipParams?.let {
                    activity.setPictureInPictureParams(it.setAutoEnterEnabled(false).build())
                    isPIPEnabled = false
                }
            }
        }
    }
}
