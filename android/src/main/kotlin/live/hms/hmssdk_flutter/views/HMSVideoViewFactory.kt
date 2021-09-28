package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.sdk.models.HMSPeer
import org.webrtc.SurfaceViewRenderer

class HMSVideoViewWidget(context: Context, id: Int, creationParams: Map<String?, Any?>?,val peer:HMSPeer?,val trackId:String,val  isAux:Boolean) : PlatformView {
    private val hmsVideoView: HMSVideoView = HMSVideoView(context)

    override fun getView(): View {
        return hmsVideoView
    }

    override fun dispose() {

        peer?.videoTrack.let {
            if (it?.trackId == trackId || peer?.isLocal == true) {
                //peerToRenderer[peer.peerID]=hmsVideoView.surfaceViewRenderer
//                Log.i("OBJECTCODEOFRENDERER",hmsVideoView.surfaceViewRenderer.hashCode().toString())
                it?.removeSink(hmsVideoView.surfaceViewRenderer)
            }
        }
        hmsVideoView.surfaceViewRenderer.release()
        //Log.i("SURFACEDISPOSE","disposed")
    }

    init {
        renderVideo()
    }

    private fun renderVideo() {

        if (peer == null) return;

        val tracks = peer.auxiliaryTracks
        if (tracks.isNotEmpty() && isAux){
            val track = tracks.first {
                it.trackId == trackId
            }

            if (track != null) {
                hmsVideoView.setVideoTrack((track as HMSVideoTrack))
                return
            }
        }
        else {
            peer.videoTrack.let {
                if (it?.trackId == trackId || peer.isLocal) {
                    hmsVideoView.setVideoTrack(it)
                    return
                }
            }
        }
    }
}

class HMSVideoViewFactory(val plugin: HmssdkFlutterPlugin) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    //val peerIdToRenderer : HashMap<String,SurfaceViewRenderer> = HashMap()

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        val id=args!!["peer_id"] as? String
        val isLocal=args!!["is_local"] as? Boolean
        val trackId=args!!["track_id"] as? String
        val isAuxiliary = args!!["is_aux"] as? Boolean
       // Log.i("onCreateHMSVideoView", "$isLocal $id")
       // Log.i("HMSVideoViewFactory",trackId.toString())
        val peer = if(isLocal==null || isLocal!!) plugin.getLocalPeer()
        else plugin.getPeerById(id!!)!!
        return HMSVideoViewWidget(context, viewId, creationParams,peer,trackId!!,isAuxiliary!!)
    }
}




