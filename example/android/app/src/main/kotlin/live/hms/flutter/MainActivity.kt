package live.hms.flutter

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.plugin.video.HMSVideoPlugin
import live.hms.video.virtualbackground.HMSVirtualBackground

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
    private var broadcastReceiver: BroadcastReceiver? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        var virtualBackgroundPlugin: HMSVirtualBackground? = null
        broadcastReceiver = object : BroadcastReceiver() {
            override fun onReceive(contxt: Context?, intent: Intent?) {
                if (intent?.action == Constants.VIRTUAL_BACKGROUND) {
                    when (intent.extras?.getString(Constants.METHOD_CALL)) {
                        Constants.SETUP_VIRTUAL_BACKGROUND -> {
                            virtualBackgroundPlugin = HMSVirtualBackground(
                                HmssdkFlutterPlugin.hmssdkFlutterPlugin?.hmssdk!!,
                                HmssdkFlutterPlugin.hmssdkFlutterPlugin?.vbImage!!
                            )
                            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.vbSetup(virtualBackgroundPlugin as HMSVideoPlugin)
                        }
                        Constants.CHANGE_VIRTUAL_BACKGROUND -> {
                            if (virtualBackgroundPlugin != null) {
                                virtualBackgroundPlugin!!.setBackground(HmssdkFlutterPlugin.hmssdkFlutterPlugin?.vbImage!!)
                            }
                        }
                    }
                } else {
                    Log.i("Receiver error", "No receiver found for given action")
                }
            }
        }
        context.registerReceiver(broadcastReceiver, IntentFilter("virtual_background"))
    }
    override fun onDestroy() {
        super.onDestroy()
        context.unregisterReceiver(broadcastReceiver)
    }
}
