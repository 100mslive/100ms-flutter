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
                         private val scaleType : Int?,private val matchParent: Boolean? = true, peerName: String
) : PlatformView {

    private val viewContext: Context = context
    private val myPeerName: String = peerName
    private val myTrack: HMSVideoTrack = track

    private var hmsVideoView: HMSVideoView? = null

    override fun getView(): View {
        if (hmsVideoView == null) {
            hmsVideoView = HMSVideoView(viewContext, setMirror, scaleType, myPeerName, myTrack)
        }
        // Log.i("debugVideo", "HMSVideoViewWidget getView peerName: $myPeerName")
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
        // Log.i("debugVideo", "HMSVideoViewWidget onFlutterViewAttached peerName: $myPeerName")

        // hmsVideoView!!.setVideoTrack(track)
    }

    override fun dispose() {
        // Log.i("debugVideo", "HMSVideoViewWidget dispose peerName: $myPeerName")
        hmsVideoView = null
    }
}


class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin) :

    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?

        val setMirror = args!!["set_mirror"] as? Boolean
        val trackId = args!!["track_id"] as? String

        val scaleType = args!!["scale_type"] as? Int

        val matchParent = args!!["match_parent"] as? Boolean

        val room = plugin.hmssdk.getRoom()

        val track = HmsUtilities.getVideoTrack(trackId!!, room!!)

        val peerName = args!!["peerName"] as? String

        // Log.i("debugVideo", "HMSVideoViewFactory create peerName: $peerName")

        return HMSVideoViewWidget(context, viewId, creationParams, track!!, setMirror!!, scaleType, matchParent, peerName!!)
    }
}