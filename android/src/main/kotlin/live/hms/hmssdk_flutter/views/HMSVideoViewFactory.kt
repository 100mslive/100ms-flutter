package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.utils.HmsUtilities



class HMSVideoViewWidget(context: Context, id: Int, creationParams: Map<String?, Any?>?, private val track: HMSVideoTrack, private val setMirror:Boolean,
                         private val scaleType : Int?,private val matchParent: Boolean? = true
) : PlatformView {

    private val viewContext: Context = context
    private val myTrack: HMSVideoTrack = track

    private var hmsVideoView: HMSVideoView? = null

    override fun getView(): View {        
        if (hmsVideoView == null) {
            hmsVideoView = HMSVideoView(viewContext, setMirror, scaleType, myTrack)
        }
        return hmsVideoView!!
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
        view.layoutParams = frameLayoutParams
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
    }

    override fun dispose() {
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

        val room = plugin.hmssdk.getRoom()

        val track = HmsUtilities.getVideoTrack(trackId!!, room!!)

        return HMSVideoViewWidget(requireNotNull(context), viewId, creationParams, track!!, setMirror!!, scaleType, matchParent)
    }
}