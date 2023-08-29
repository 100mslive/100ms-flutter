package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.utils.HmsUtilities

class HMSVideoViewWidget(
    private val context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    track: HMSVideoTrack?,
    setMirror: Boolean,
    scaleType: Int?,
    private val matchParent: Boolean? = true,
    disableAutoSimulcastLayerSelect: Boolean,
    hmssdkFlutterPlugin: HmssdkFlutterPlugin?,
) : PlatformView {

    private var hmsVideoView: HMSVideoView? = null

    init {
        if (hmsVideoView == null) {
            hmsVideoView = HMSVideoView(context, setMirror, scaleType, track, disableAutoSimulcastLayerSelect, hmssdkFlutterPlugin)
        }
    }

    override fun getView(): View? {
        return hmsVideoView
    }

    override fun dispose() {
        if (hmsVideoView != null) {
            hmsVideoView?.onDisposeCalled()
        } else {
            Log.e("HMSVideoView error", "onDisposeCalled error hmsVideoView is null")
        }
        hmsVideoView = null
    }
}

class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin) :

    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        val setMirror = args!!["set_mirror"] as? Boolean
        val trackId = args!!["track_id"] as? String

        val scaleType = args!!["scale_type"] as? Int

        val matchParent = args!!["match_parent"] as? Boolean

        val room = plugin.hmssdk!!.getRoom()

        var track = HmsUtilities.getVideoTrack(trackId!!, room!!)
        if (track == null) {
            // /Checking here for preview for role video track is any
            // /Otherwise return the error
            if (plugin.previewForRoleVideoTrack != null && trackId == plugin.previewForRoleVideoTrack?.trackId) {
                track = plugin.previewForRoleVideoTrack
            } else {
                plugin.onVideoViewError(
                    methodName = "HMSVideoView",
                    error = "There is no track corresponding to the given trackId",
                    errorMessage = "Video track is null for corresponding trackId",
                )
            }
        }
        val disableAutoSimulcastLayerSelect = args!!["disable_auto_simulcast_layer_select"] as? Boolean ?: false

        return HMSVideoViewWidget(requireNotNull(context), viewId, creationParams, track, setMirror!!, scaleType, matchParent, disableAutoSimulcastLayerSelect, plugin)
    }
}
