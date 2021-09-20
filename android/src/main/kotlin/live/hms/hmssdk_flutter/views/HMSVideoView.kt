package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.utils.SharedEglContext
import org.webrtc.EglBase
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer

class HMSVideoView(context: Context) : LinearLayout(context, null) {
    val surfaceViewRenderer: SurfaceViewRenderer

    init {

        val view = View.inflate(context, R.layout.hms_video_view, this)

        surfaceViewRenderer = view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.setEnableHardwareScaler(true)
        surfaceViewRenderer.setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_BALANCED)
        surfaceViewRenderer.init(SharedEglContext.context, null)

    }

    fun setVideoTrack(track: HMSVideoTrack?) {
        track?.addSink(surfaceViewRenderer)
    }
}


