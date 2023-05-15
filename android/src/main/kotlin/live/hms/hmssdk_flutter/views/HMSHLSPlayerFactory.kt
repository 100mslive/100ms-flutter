package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin

class HMSHLSPlayerWidget(
    context: Context,
    hlsUrl: String?,
    hmssdkFlutterPlugin: HmssdkFlutterPlugin?
): PlatformView{

    private var hmsHLSPlayer: HMSHLSPlayer? = null

    init {
        if(hmsHLSPlayer == null){
            hmsHLSPlayer = HMSHLSPlayer(context,hlsUrl,hmssdkFlutterPlugin)
        }
    }

    override fun getView(): View? {
        return hmsHLSPlayer
    }

    override fun dispose() {
        hmsHLSPlayer?.dispose()
        hmsHLSPlayer = null
    }
}
class HMSHLSPlayerFactory(private val plugin:HmssdkFlutterPlugin):PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {

        var hlsUrl : String? = null
        val params : Map<String,String?>? = args as Map<String, String?>?
        if(params != null){
            hlsUrl= params["hls_url"]
        }
        return HMSHLSPlayerWidget(requireNotNull(context),hlsUrl,plugin)
    }

}