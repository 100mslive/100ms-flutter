package com.example.sample_application

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.methods.HMSPipAction

class MainActivity : FlutterActivity() {
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Constants.SCREEN_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            data?.action = Constants.HMSSDK_RECEIVER
            activity.sendBroadcast(data?.putExtra(Constants.METHOD_CALL, Constants.SCREEN_SHARE_REQUEST))
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?,
    ) {
        if (isInPictureInPictureMode) {
            if (HMSPipAction.pipResult != null) {
                HMSPipAction.pipResult?.success(true)
                HMSPipAction.pipResult = null
            }
        } else {
            Log.i("PIP Mode", "Exited PIP Mode")
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // This should only work for android version above 8 since PIP is only supported after
        // android 8 and will not be called after android 12 since it automatically gets handled by android.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            HMSPipAction.autoEnterPipMode(this)
        }
    }
}
