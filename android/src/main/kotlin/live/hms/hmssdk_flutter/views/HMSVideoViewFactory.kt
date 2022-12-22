package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.utils.HmsUtilities



class HMSVideoViewWidget(private val context: Context, id: Int, creationParams: Map<String?, Any?>?, private val track: HMSVideoTrack, private val setMirror:Boolean,
                        private val scaleType : Int?,private val matchParent: Boolean? = true, private val isVideoViewStateChangeListenerAdded:Boolean = false
            ,private val binaryMessenger: BinaryMessenger
) : PlatformView {

    private var hmsVideoView: HMSVideoView? = null


    override fun getView(): View {
    if(hmsVideoView == null){
        hmsVideoView = HMSVideoView(context, setMirror, scaleType, track,isVideoViewStateChangeListenerAdded,binaryMessenger)
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

    override fun dispose() {
        hmsVideoView?.onDisposeCalled();
        hmsVideoView = null
        Log.i("dispose outside called","ViewId : ${hmsVideoView?.id} TrackId : ${track.trackId}")
    }
}


class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin,private val binaryMessenger: BinaryMessenger) :

    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?

        val setMirror = args!!["set_mirror"] as? Boolean
        val trackId = args!!["track_id"] as? String

        val scaleType = args!!["scale_type"] as? Int

        val matchParent = args!!["match_parent"] as? Boolean

        val room = plugin.hmssdk!!.getRoom()

        val track = HmsUtilities.getVideoTrack(trackId!!, room!!)

        val isVideoViewStateChangeListenerAdded = args["is_video_view_state_change_listener_added"] as? Boolean?:false

        Log.i("create called","TrackId : $trackId")
        return HMSVideoViewWidget(requireNotNull(context), viewId, creationParams, track!!, setMirror!!, scaleType, matchParent,isVideoViewStateChangeListenerAdded,binaryMessenger)
    }
}