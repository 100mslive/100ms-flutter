package live.hms.hmssdk_flutter.views

import android.content.Context
import android.graphics.Bitmap
import android.util.Base64
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSVideoViewTestClass
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import org.webrtc.RendererCommon
import java.io.ByteArrayOutputStream


class HMSVideoView(
    context: Context,
    setMirror: Boolean,
    scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
    private val track: HMSVideoTrack?,
    disableAutoSimulcastLayerSelect: Boolean,
) : FrameLayout(context, null){

    private val hmsVideoView: HMSVideoView
    private var toggle = 1
    init {
        if(HmssdkFlutterPlugin.hmssdkFlutterPlugin != null){
            Log.i("%%% trackId--",track?.trackId?:"")
            if(HmssdkFlutterPlugin.hmssdkFlutterPlugin != null){
                HmssdkFlutterPlugin.hmssdkFlutterPlugin!!.hmsVideoViewInterfaceMap?.set(track!!.trackId,
                    HMSVideoViewTestClass(track.trackId,::captureBitmap)
                )
            }
            Log.i("%%% trackId--"," Added ${track?.trackId}")
        }
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)
        hmsVideoView = view.findViewById(R.id.hmsVideoView)
        hmsVideoView.setEnableHardwareScaler(false)
        hmsVideoView.setMirror(setMirror)
        hmsVideoView.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            hmsVideoView.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }
    }

    private fun captureBitmap(result: MethodChannel.Result){
        var byteArray : ByteArray? = null
        hmsVideoView.captureBitmap({bitmap ->
            if(bitmap != null){
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                byteArray = stream.toByteArray()
                bitmap.recycle()
                Log.i("bitmap received",byteArray.toString())
                result.success(Base64.encodeToString(byteArray,Base64.DEFAULT))
            }
        })
    }

    fun onDisposeCalled() {
        super.onDetachedFromWindow()
        Log.i("%%% trackId","removed ${track?.trackId}")
        if(HmssdkFlutterPlugin.hmssdkFlutterPlugin != null) {
            HmssdkFlutterPlugin.hmssdkFlutterPlugin!!.hmsVideoViewInterfaceMap?.remove(track?.trackId)
        }
        hmsVideoView.removeTrack()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (track != null) {
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
