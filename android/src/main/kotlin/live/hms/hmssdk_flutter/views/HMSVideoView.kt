package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.utils.SharedEglContext
import org.webrtc.NetworkMonitor.init
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer


class HMSVideoView(
        context: Context,
        setMirror: Boolean,
        scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
        private val track:HMSVideoTrack
) : FrameLayout(context, null) {

    private val surfaceViewRenderer: SurfaceViewRenderer

    init {
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)

        surfaceViewRenderer = view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.setEnableHardwareScaler(false)
        surfaceViewRenderer.setMirror(setMirror)

        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            surfaceViewRenderer.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }

    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        surfaceViewRenderer.init(SharedEglContext.context, null)
        track.addSink(surfaceViewRenderer)
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        track.removeSink(surfaceViewRenderer)
        surfaceViewRenderer.release()
    }
}


