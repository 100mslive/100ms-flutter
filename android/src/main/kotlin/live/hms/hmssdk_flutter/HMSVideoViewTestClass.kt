package live.hms.hmssdk_flutter

import android.util.Base64
import android.util.Log

class HMSVideoViewTestClass(override var trackId: String,val onCapture: () -> String?) : HMSVideoViewInterface{

    override fun captureBitmap():String? {
        return onCapture()
    }
}