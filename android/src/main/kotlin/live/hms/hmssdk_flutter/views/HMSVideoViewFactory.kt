package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSLocalTrack
import live.hms.video.media.tracks.HMSLocalVideoTrack
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.sdk.models.HMSPeer
import org.webrtc.SurfaceViewRenderer

class HMSVideoViewWidget(context: Context, id: Int, creationParams: Map<String?, Any?>?, private val peer:HMSPeer?, private val trackId:String, private val  isAux:Boolean, private val setMirror:Boolean,
                         private val scaleType : Int?,val screenShare:Boolean? = false,private val matchParent: Boolean? = true
) : PlatformView {

    private val hmsVideoView: HMSVideoView = HMSVideoView(context,setMirror,scaleType)

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        renderVideo()
    }

    private fun renderVideo() {

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

        if (peer == null) return


        if (hmsVideoView.currentVideoTrack != null) {
            if (hmsVideoView.currentVideoTrack!!.trackId == trackId) {
                return
            }
        }
        val tracks = peer.auxiliaryTracks

        if (tracks.isNotEmpty() && isAux) {
            val track = tracks.first {
                it.trackId == trackId
            }

            hmsVideoView.setVideoTrack((track as HMSVideoTrack))
            return
        } else {
            peer.videoTrack.let {
                if (it?.trackId == trackId || peer.isLocal) {
                    hmsVideoView.setVideoTrack(it)
                    Log.i("HMSVideoViewFactory","### renderVideo regular ${peer!!.name} <> ${it!!.source} <> ${it!!.trackId} <> $trackId")
                }
            }
        }
    }

    override fun getView(): View {
        return hmsVideoView
    }

    override fun dispose() {
        release()
    }

    private fun release() {
        if (hmsVideoView.currentVideoTrack != null) {
            if (hmsVideoView.currentVideoTrack!!.trackId == trackId) { // peer?.isLocal == true
                hmsVideoView.currentVideoTrack!!.removeSink(hmsVideoView.surfaceViewRenderer)
                hmsVideoView.surfaceViewRenderer.release()
                hmsVideoView.currentVideoTrack = null
            }
        }
    }
}


class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin) :

    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?

        val setMirror=args!!["set_mirror"] as? Boolean
        val trackId=args!!["track_id"] as? String
        val isAuxiliary = args!!["is_aux"] as? Boolean
        val scaleType = args!!["scale_type"] as? Int
        val screenShare = args!!["screen_share"] as? Boolean
        val matchParent = args!!["match_parent"] as? Boolean

        val peer : HMSPeer = plugin.hmssdk.getPeers().first {
            it.getTrackById(trackId?.trim()!!)?.trackId?.trim() == trackId.trim()
        }
        return HMSVideoViewWidget(context, viewId, creationParams,peer,trackId!!,isAuxiliary!!,setMirror!!,scaleType,screenShare,matchParent)
    }
}
