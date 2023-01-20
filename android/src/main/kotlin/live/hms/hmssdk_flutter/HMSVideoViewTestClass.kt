package live.hms.hmssdk_flutter

import io.flutter.plugin.common.MethodChannel.Result

class HMSVideoViewTestClass(override var trackId: String,val onCapture: (result:Result) -> Unit) : HMSVideoViewInterface{

    override fun captureBitmap(result: Result):Unit{
        onCapture(result)
    }
}