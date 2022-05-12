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
    peerName: String,
    track:HMSVideoTrack
) : FrameLayout(context, null) {

    private val surfaceViewRenderer: SurfaceViewRenderer

    private val myPeerName: String = peerName

    private  val myTrack: HMSVideoTrack = track

    init {
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)

        surfaceViewRenderer = view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.setEnableHardwareScaler(true)
        surfaceViewRenderer.setMirror(setMirror)

        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            surfaceViewRenderer.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }

        // Log.i("debugVideo", "HMSVideoView init peerName: $myPeerName")
    }


    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        // Log.i("debugVideo", "HMSVideoView onAttachedToWindow peerName: $myPeerName")
        surfaceViewRenderer.init(SharedEglContext.context, null)
        myTrack.addSink(surfaceViewRenderer)
    }


    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        // Log.i("debugVideo", "HMSVideoView onDetachedFromWindow peerName: $myPeerName")
        myTrack.removeSink(surfaceViewRenderer)
        surfaceViewRenderer.release()
    }

    // fun setVideoTrack(track: HMSVideoTrack) {
    //     Log.i("debugVideo", "HMSVideoView setVideoTrack peerName: $myPeerName")
    //     surfaceViewRenderer.init(SharedEglContext.context, null)
    //     track.addSink(surfaceViewRenderer)
    // }

    // fun removeVideoTrack(track: HMSVideoTrack) {
    //     Log.i("debugVideo", "HMSVideoView removeVideoTrack peerName: $myPeerName")
    //     track.removeSink(surfaceViewRenderer)
    //     surfaceViewRenderer.release()
    // }
}


