package live.hms.hmssdk_flutter.views

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin

class HMSHLSPlayerFactory(private val plugin:HmssdkFlutterPlugin):PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {

        var hlsUrl : String? = null
        args?.let { it as Map<*, *>
                 hlsUrl= it["hls_url"] as String? ?:run {
                     HMSErrorLogger.logError(methodName = "HMSHLSPlayer",
                         error = "No URL found to play HLS Stream",
                         errorType = "NULL Error")
                    plugin.onVideoViewError(methodName = "HMSHLSPlayer",
                        error = "No URL found to play HLS Stream",
                        errorMessage = "HLS stream URL is null")
                    null
                }

        }?:run {
            HMSErrorLogger.returnArgumentsError("No arguments found for HMSHLSPlayer")
            plugin.onVideoViewError(methodName = "HMSHLSPlayer",
                error = "No arguments found for HMSHLSPlayer",
                errorMessage = "arguments is null")
        }
        return HMSHLSPlayer(requireNotNull(context),hlsUrl)
    }

}