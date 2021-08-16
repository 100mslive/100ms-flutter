package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import live.hms.hmssdk_flutter.R
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.utils.SharedEglContext
import org.webrtc.EglBase
import org.webrtc.SurfaceViewRenderer

class HMSVideoView(context: Context) : LinearLayout(context,null) {
    val surfaceViewRenderer:SurfaceViewRenderer
    init {
        //val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view=View.inflate(context,R.layout.hms_video_view,this)

        surfaceViewRenderer=view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.init(SharedEglContext.context,null)
    }

    fun setVideoTrack(hmsPeer: HMSPeer?){
        if(hmsPeer!=null)
            hmsPeer.videoTrack!!.addSink(surfaceViewRenderer)
    }
}


