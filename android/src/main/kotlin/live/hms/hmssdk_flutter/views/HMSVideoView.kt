package live.hms.hmssdk_flutter.views

import android.content.Context
import android.view.LayoutInflater
import android.widget.FrameLayout
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import live.hms.videoview.VideoViewStateChangeListener
import org.webrtc.RendererCommon


class HMSVideoView(
        context: Context,
        setMirror: Boolean,
        scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
        private val track:HMSVideoTrack,
        isVideoViewListenerAdded : Boolean
) : FrameLayout(context, null), VideoViewStateChangeListener {

    private val hmsVideoView: HMSVideoView

    init {
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)
        hmsVideoView = view.findViewById(R.id.hmsVideoView)
        hmsVideoView.setEnableHardwareScaler(false)
        hmsVideoView.setMirror(setMirror)
        hmsVideoView.setAutoSimulcast(true)
        if(isVideoViewListenerAdded){
            hmsVideoView.addVideoViewStateChangeListener(this)
        }
        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            hmsVideoView.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }
    }

    fun onDisposeCalled(){
        hmsVideoView.removeTrack()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        hmsVideoView.addTrack(track)
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        hmsVideoView.removeTrack()
    }

    override fun onFirstFrameRendered() {
        super.onFirstFrameRendered()
        val hashMap = HashMap<String,Any>()
        val data = HashMap<String,Any>()
        hashMap["event_name"] = "on_first_frame_rendered"
        data["track_id"] = track.trackId
        hashMap["data"] = data
        CoroutineScope(Dispatchers.Main).launch {
            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.videoViewSink?.success(hashMap)
        }
    }

    override fun onResolutionChange(newWidth: Int, newHeight: Int) {
        super.onResolutionChange(newWidth, newHeight)
        val hashMap = HashMap<String,Any>()
        val data = HashMap<String,Any>()
        hashMap["event_name"] = "on_resolution_change"
        data["track_id"] = track.trackId
        data["new_width"] = newWidth
        data["new_height"] = newHeight
        hashMap["data"] = data
        CoroutineScope(Dispatchers.Main).launch {
            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.videoViewSink?.success(hashMap)
        }
    }
}
