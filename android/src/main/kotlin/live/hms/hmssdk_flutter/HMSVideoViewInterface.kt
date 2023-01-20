package live.hms.hmssdk_flutter

import android.util.Base64
import io.flutter.plugin.common.MethodChannel.Result

interface HMSVideoViewInterface {
    var trackId:String

    fun captureBitmap(result: Result):Unit
}