package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.logError
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.error.HMSException
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
    disableAutoSimulcastLayerSelect: Boolean
) : PlatformView {

    private var hmsVideoView: HMSVideoView? = null

    init {
        if (hmsVideoView == null) {
            hmsVideoView = HMSVideoView(context, setMirror, scaleType, track, disableAutoSimulcastLayerSelect)
        }
    }

    override fun getView(): View? {
        return hmsVideoView
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        var frameLayoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        if (matchParent == false) {
            frameLayoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
        }
        if (view != null) {
            view?.layoutParams = frameLayoutParams
        } else {
            logError("HMSVideoView onFlutterViewAttached","view is null","HMSVideoView Error")
        }
    }

    override fun dispose() {
        if (hmsVideoView != null) {
            hmsVideoView?.onDisposeCalled()
        } else {
            logError("HMSVideoView onDisposeCalled","hmsVideoView is null","HMSVideoView Error")
        }
        hmsVideoView = null
    }
}

class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin) :

    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>

        val setMirror = args["set_mirror"] as? Boolean
        val trackId = args["track_id"] as? String

        val scaleType = args["scale_type"] as? Int

        val matchParent = args["match_parent"] as? Boolean

        var track:HMSVideoTrack? = null
        if(plugin.hmssdk != null){
            val room = plugin.hmssdk!!.getRoom()
            if(room != null){
                track = HmsUtilities.getVideoTrack(trackId!!, room)
                if (track == null) {
                    val eventArgs = HashMap<String, Any?>()
                    eventArgs["event_name"] = "on_error"
                    val hmsException = HMSException(
                        action = "Check the trackId for the track",
                        code = 6004,
                        description = "There is no track corresponding to the given trackId",
                        message = "Video track is null for corresponding trackId",
                        name = "HMSVideoView Error"
                    )
                    eventArgs["data"] = HMSExceptionExtension.toDictionary(hmsException)
                    plugin.onVideoViewError(eventArgs)
                }
            }
            else{
                logError("HMSVideoView create","room is null","Null Error")
            }
        }
        else{
            logError("HMSVideoView create","hmssdk is null","HMSSDK Error")
        }

        val disableAutoSimulcastLayerSelect = args["disable_auto_simulcast_layer_select"] as? Boolean ?: false

        return HMSVideoViewWidget(requireNotNull(context), viewId, creationParams, track, setMirror!!, scaleType, matchParent, disableAutoSimulcastLayerSelect)
    }
}
