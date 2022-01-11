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

        Log.i("HMSVideoViewFactory","### will start renderVideo <> $trackId  ${peer?.peerID}")

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
        
        Log.i("Called for render","${peer.name} ${isAux} ${tracks.isNotEmpty()}")
        if (tracks.isNotEmpty() && isAux) {
            val track = tracks.first {
                it.trackId == trackId
            }

            hmsVideoView.setVideoTrack((track as HMSVideoTrack))
//                Log.i("HMSVideoViewFactory","### renderVideo auxiliary ${peer!!.name} <> ${track.source} <> ${track.trackId} <> $trackId")
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
//        Log.i("Called for release","### will start dispose ${peer!!.name} <> $trackId")
        release()
    }

    private fun release() {
        if (hmsVideoView.currentVideoTrack != null) {
            if (hmsVideoView.currentVideoTrack!!.trackId == trackId) { // peer?.isLocal == true
                hmsVideoView.currentVideoTrack!!.removeSink(hmsVideoView.surfaceViewRenderer)
                hmsVideoView.surfaceViewRenderer.release()
                hmsVideoView.currentVideoTrack = null
                Log.i("HMSVideoViewFactory","### released ${peer!!.name} <> $trackId")
            }
        }
        else {
            // TODO: add exception logs
        }
//        peer?.videoTrack.let {
//            if (it?.trackId == trackId || peer?.isLocal == true) {
//                it?.removeSink(hmsVideoView.surfaceViewRenderer)
//            }
//        }
//        hmsVideoView.surfaceViewRenderer.release()
    }
}

class HMSVideoViewFactory(private val plugin: HmssdkFlutterPlugin) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        val id=args!!["peer_id"] as? String ?: ""
        val isLocal=args!!["is_local"] as? Boolean
        val setMirror=args!!["set_mirror"] as? Boolean
        val trackId=args!!["track_id"] as? String
        val isAuxiliary = args!!["is_aux"] as? Boolean
        val scaleType = args!!["scale_type"] as? Int
        val screenShare = args!!["screen_share"] as? Boolean
        val matchParent = args!!["match_parent"] as? Boolean


        val peer = if(isLocal==null || isLocal) plugin.getLocalPeer()
        else plugin.getPeerById(id!!)!!
        Log.i("viewFactory",plugin.getPeers().size.toString())
        return HMSVideoViewWidget(context, viewId, creationParams,peer,trackId!!,isAuxiliary!!,setMirror!!,scaleType,screenShare,matchParent)
    }
}
