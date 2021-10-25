package live.hms.hmssdk_flutter.views

import android.content.Context
import android.content.res.Resources
import android.graphics.Rect
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import androidx.constraintlayout.widget.ConstraintLayout
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.utils.SharedEglContext
import org.webrtc.EglBase
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer

class HMSVideoView(context: Context,setMirror:Boolean) : ConstraintLayout(context, null) {
    val surfaceViewRenderer: SurfaceViewRenderer

    init {
        val inflater = getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)

        surfaceViewRenderer = view.findViewById(R.id.surfaceViewRenderer)
        surfaceViewRenderer.setEnableHardwareScaler(true)
        Log.i("HMSVideoViewAndroid",setMirror.toString())
        surfaceViewRenderer.setMirror(setMirror)
        surfaceViewRenderer.setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_FIT)
        surfaceViewRenderer.init(SharedEglContext.context, null)
    }

    fun setVideoTrack(track: HMSVideoTrack?) {
        track?.addSink(surfaceViewRenderer)
    }
}


