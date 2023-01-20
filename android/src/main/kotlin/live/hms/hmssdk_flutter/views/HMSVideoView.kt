package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import live.hms.hmssdk_flutter.HMSVideoViewInterface
import live.hms.hmssdk_flutter.HMSVideoViewTestClass
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import org.webrtc.RendererCommon

class HMSVideoView(
    context: Context,
    private val setMirror: Boolean,
    private val scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
    private val track: HMSVideoTrack?,
    private val disableAutoSimulcastLayerSelect: Boolean,
) : FrameLayout(context, null){

    private var hmsVideoView: HMSVideoView
    private var toggle = 1
    init {

        if(HmssdkFlutterPlugin.hmssdkFlutterPlugin != null){
            Log.i("%%% trackId--",track?.trackId?:"")
            HmssdkFlutterPlugin.hmssdkFlutterPlugin!!.hmsVideoViewInterfaceMap[track!!.trackId] = HMSVideoViewTestClass(track.trackId,::test)
            Log.i("%%% trackId--"," Added ${track.trackId}")
        }
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)
        hmsVideoView = view.findViewById(R.id.hmsVideoView)

    }

    private fun test(){
        toggle = if(toggle == 1){
            hmsVideoView.removeTrack()
            0
        } else{
            hmsVideoView.addTrack(track!!)
            1
        }
    }
    fun onDisposeCalled() {
        super.onDetachedFromWindow()
        Log.i("%%% trackId","removed ${track?.trackId}")
        HmssdkFlutterPlugin.hmssdkFlutterPlugin!!.hmsVideoViewInterfaceMap.remove(track?.trackId)
        hmsVideoView.removeTrack()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (track != null) {
            hmsVideoView.setEnableHardwareScaler(false)
            hmsVideoView.setMirror(setMirror)
            hmsVideoView.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
            if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
                hmsVideoView.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
            }
            hmsVideoView.addTrack(track)
        } else {
            Log.e("HMSVideoView Error", "track is null, cannot attach null track")
        }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        hmsVideoView.removeTrack()
    }
}
