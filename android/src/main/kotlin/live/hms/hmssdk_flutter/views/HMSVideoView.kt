package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.util.Base64
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import org.webrtc.RendererCommon
import java.io.ByteArrayOutputStream

class HMSVideoView(
    context: Context,
    private val setMirror: Boolean,
    private val scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
    private val track: HMSVideoTrack?,
    private val disableAutoSimulcastLayerSelect: Boolean,
    private val hmssdkFlutterPlugin: HmssdkFlutterPlugin
) : FrameLayout(context, null) {

    private var hmsVideoView: HMSVideoView? = null
    private var view: View? = null
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(contxt: Context?, intent: Intent?) {
            if (intent?.action == track?.trackId) {
                when (intent?.extras?.getString("method_name")) {
                    "CAPTURE_SNAPSHOT" -> {
                        return captureSnapshot()
                    }
                }
            } else {
                Log.e("Receiver error", "No receiver found for given action")
            }
        }
    }
    init {
        view =
            (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.hms_video_view, this)
        if (view != null) {
            hmsVideoView = view?.findViewById(R.id.hmsVideoView)
            hmsVideoView?.setEnableHardwareScaler(false)
            hmsVideoView?.setMirror(setMirror)
            hmsVideoView?.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
            if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
                hmsVideoView?.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
            }
        } else {
            Log.e("HMSVideoView Error", "HMSVideoView init error view is null")
        }
    }

    private fun captureSnapshot() {
        var byteArray: ByteArray?
        if (hmsVideoView != null) {
            hmsVideoView?.captureBitmap({ bitmap ->
                if (bitmap != null) {
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    byteArray = stream.toByteArray()
                    bitmap.recycle()
                    val data = Base64.encodeToString(byteArray, Base64.DEFAULT)
                    if (hmssdkFlutterPlugin.hmsVideoViewResult != null) {
                        hmssdkFlutterPlugin.hmsVideoViewResult?.success(data)
                    } else {
                        Log.i("Receiver error", "hmsVideoViewResult is null")
                    }
                }
            })
        } else {
            Log.e("Receiver error", "hmsVideoView is null")
        }
    }

    fun onDisposeCalled() {
        if (hmsVideoView != null) {
            hmsVideoView?.removeTrack()
        } else {
            Log.e("HMSVideoView error", "onDisposeCalled error hmsVideoView is null")
        }
        this.removeView(view)
        view = null
        hmsVideoView = null
        context.unregisterReceiver(broadcastReceiver)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (track != null) {
            if(hmsVideoView != null){
                hmsVideoView?.addTrack(track)
                context.registerReceiver(broadcastReceiver, IntentFilter(track.trackId))
            }
            else{
                Log.e("HMSVideoView Error", "onAttachedToWindow error hmsVideoView is null")
            }
        } else {
            Log.e("HMSVideoView Error", "onAttachedToWindow error track is null, cannot attach null track")
        }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        if (hmsVideoView != null) {
            hmsVideoView?.removeTrack()
            context.unregisterReceiver(broadcastReceiver)
        } else {
            Log.e("HMSVideoView error", "onDetachedFromWindow error hmsVideoView is null")
        }
    }
}
