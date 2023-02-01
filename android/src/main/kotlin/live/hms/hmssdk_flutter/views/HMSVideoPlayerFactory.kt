package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class HMSVideoPlayerWidget(
    context: Context,
    url: String): PlatformView  {

    private var hmsVideoPlayer: HMSVideoPlayer? = null

    init {
        if (hmsVideoPlayer == null) {
            hmsVideoPlayer = HMSVideoPlayer(context, url)
        }
    }

    override fun getView(): View? {
        return hmsVideoPlayer
    }

    override fun dispose() {
        if(hmsVideoPlayer!=null){
            hmsVideoPlayer?.onDisposeCalled()
        }
        hmsVideoPlayer = null
    }
}

class HMSVideoPlayerFactory() : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        args as Map<*, *>?
        val url = args!!["url"] as? String

        return HMSVideoPlayerWidget(requireNotNull(context),url!!)
    }
}
