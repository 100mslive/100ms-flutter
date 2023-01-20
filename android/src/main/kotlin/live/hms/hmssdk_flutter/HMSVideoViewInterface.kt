package live.hms.hmssdk_flutter

import android.util.Base64

interface HMSVideoViewInterface {
    var trackId:String

    fun captureBitmap():String?
}