package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformViewFactory
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.sdk.models.HMSPeer

class HMSVideoViewWidget(context: Context, id: Int, creationParams: Map<String?, Any?>?,peer:HMSPeer) : PlatformView {
    val hmsVideoView: HMSVideoView

    override fun getView(): View {
        return hmsVideoView
    }

    override fun dispose() {}

    init {
        hmsVideoView=HMSVideoView(context)
        Log.i("HMSVIdeo",peer.toString())
        if (peer.videoTrack!=null)
            peer.videoTrack!!.addSink(hmsVideoView.surfaceViewRenderer)
        //hmsVideoView.setVideoTrack(peer)
    }
}

class HMSVideoViewFactory(val plugin: HmssdkFlutterPlugin) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    lateinit var hmsVideoViewWidget: HMSVideoViewWidget
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        val id=args!!["peer_id"] as String
        val isLocal=args!!["is_local"] as Boolean
        Log.i("HMSVideoViewFactory",plugin.getPeerById(id,isLocal)!!.videoTrack.toString()+"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
        this.hmsVideoViewWidget= HMSVideoViewWidget(context, viewId, creationParams,plugin.getPeerById(id,isLocal)!!)
        return hmsVideoViewWidget
    }
}




