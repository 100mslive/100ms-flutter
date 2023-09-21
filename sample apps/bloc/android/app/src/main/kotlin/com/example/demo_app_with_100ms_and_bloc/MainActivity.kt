package com.example.demo_app_with_100ms_and_bloc

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin

class MainActivity : FlutterActivity() {
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == Constants.SCREEN_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.requestScreenShare(data)
        }
    }
}
