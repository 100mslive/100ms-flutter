package live.hms.flutter

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.methods.HMSPipAction

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

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        if(isInPictureInPictureMode){
            if(HMSPipAction.pipResult != null){
                HMSPipAction.pipResult?.success(true);
                HMSPipAction.pipResult = null
            }
        }
        else{
            Log.i("PIP Mode","Exited PIP Mode")
        }
    }
}
