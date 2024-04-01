package com.example.one_to_one_callkit

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import live.hms.hmssdk_flutter.Constants
import android.app.Activity

class MainActivity: FlutterActivity() {

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
            if (requestCode == Constants.SCREEN_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
                data?.action = Constants.HMSSDK_RECEIVER
                activity.sendBroadcast(data?.putExtra(Constants.METHOD_CALL, Constants.SCREEN_SHARE_REQUEST))
            }
        }
}
