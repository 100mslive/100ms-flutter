package live.hms.flutter

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin

class MainActivity: FlutterActivity() {

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == Constants.SCREEN_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK){
            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.requestScreenShare(data)
        }

        if (requestCode == Constants.AUDIO_SHARE_INTENT_REQUEST_CODE && resultCode == Activity.RESULT_OK){
            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.requestAudioShare(data)
        }

    }
}
