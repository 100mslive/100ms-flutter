package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.util.Base64
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
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
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(contxt: Context?, intent: Intent?) {
            if(intent?.action == track?.trackId){
                when(intent?.extras?.getString("method_name")){
                    "CAPTURE_SNAPSHOT" -> {
                        return captureSnapshot()
                    }
                }
            }
            else{
                Log.i("Receiver error","No receiver found for given action")
            }
        }
    }
    init {
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

    private fun captureSnapshot(){
        var byteArray : ByteArray?
        hmsVideoView.captureBitmap({bitmap ->
            if(bitmap != null){
                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                byteArray = stream.toByteArray()
                bitmap.recycle()
                val data = Base64.encodeToString(byteArray,Base64.DEFAULT)
                if(HmssdkFlutterPlugin.hmssdkFlutterPlugin != null){
                    if(HmssdkFlutterPlugin.hmssdkFlutterPlugin?.hmsVideoViewResult != null){
                        HmssdkFlutterPlugin.hmssdkFlutterPlugin?.hmsVideoViewResult?.success(data)
                    }
                    else{
                        Log.i("Receiver error","hmsVideoViewResult is null")
                    }
                }
                else{
                    Log.i("Receiver error","hmssdkFlutterPlugin is null")
                }
            }
        })
    }

    fun onDisposeCalled() {
        super.onDetachedFromWindow()
        hmsVideoView.removeTrack()
        context.unregisterReceiver(broadcastReceiver)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (track != null) {
            hmsVideoView.addTrack(track)
            context.registerReceiver(broadcastReceiver,IntentFilter(track.trackId))
        } else {
            Log.e("HMSVideoView Error", "track is null, cannot attach null track")
        }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        hmsVideoView.removeTrack()
    }
}
