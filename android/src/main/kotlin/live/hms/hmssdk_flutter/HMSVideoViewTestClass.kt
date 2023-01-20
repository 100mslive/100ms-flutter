package live.hms.hmssdk_flutter

import android.util.Log

class HMSVideoViewTestClass(override var trackId: String,val test: () -> Unit) : HMSVideoViewInterface{

    override fun printTrackId() {
        test()
    }
}