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
    hmssdkFlutterPlugin: HmssdkFlutterPlugin?,
    isHLSStatsRequired: Boolean,
    showPlayerControls: Boolean,
) : PlatformView {

    private var hmsHLSPlayer: HMSHLSPlayer? = null

    init {
        if (hmsHLSPlayer == null) {
            hmsHLSPlayer = HMSHLSPlayer(context, hlsUrl, hmssdkFlutterPlugin, isHLSStatsRequired, showPlayerControls)
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
class HMSHLSPlayerFactory(private val plugin: HmssdkFlutterPlugin) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        var hlsUrl: String? = null
        var isHLSStatsRequired: Boolean? = false
        var showPlayerControls: Boolean? = false
        val params: Map<String, Any?>? = args as Map<String, Any?>?
        if (params != null) {
            hlsUrl = params["hls_url"] as? String?
            isHLSStatsRequired = params["is_hls_stats_required"] as? Boolean?
            showPlayerControls = params["show_player_controls"] as? Boolean?
        }
        return HMSHLSPlayerWidget(requireNotNull(context), hlsUrl, plugin, isHLSStatsRequired ?: false, showPlayerControls ?: false)
    }
}
