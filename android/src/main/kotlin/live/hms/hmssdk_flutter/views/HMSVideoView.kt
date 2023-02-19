package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import org.webrtc.RendererCommon
import java.io.ByteArrayOutputStream

class HMSVideoView(
    id: Int,
    private val context: Context,
    setMirror: Boolean,
    scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
    private val track: HMSVideoTrack?,
    disableAutoSimulcastLayerSelect: Boolean,
    matchParent:Boolean
) : PlatformView{

    private var hmsVideoView: HMSVideoView? = null

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
        hmsVideoView = HMSVideoView(context)
        hmsVideoView?.id = id
        Log.e("HMSVIDEOVIEW","init called for view with id:${hmsVideoView?.id}")
        var frameLayoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        if (!matchParent) {
            frameLayoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
        }
        hmsVideoView?.layoutParams = frameLayoutParams
        hmsVideoView?.setEnableHardwareScaler(false)
        hmsVideoView?.setMirror(setMirror)
        hmsVideoView?.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            hmsVideoView?.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
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
                    if (HmssdkFlutterPlugin.hmssdkFlutterPlugin != null) {
                        if (HmssdkFlutterPlugin.hmssdkFlutterPlugin?.hmsVideoViewResult != null) {
                            HmssdkFlutterPlugin.hmssdkFlutterPlugin?.hmsVideoViewResult?.success(data)
                        } else {
                            Log.e("Receiver error", "hmsVideoViewResult is null")
                        }
                    } else {
                        Log.e("Receiver error", "hmssdkFlutterPlugin is null")
                    }
                }
            })
        } else {
            Log.e("Receiver error", "hmsVideoView is null")
        }
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
        if(track != null){
            hmsVideoView?.addTrack(track)
            context.registerReceiver(broadcastReceiver, IntentFilter(track.trackId))
        }
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        hmsVideoView?.removeTrack()
        context.unregisterReceiver(broadcastReceiver)
        hmsVideoView = null
    }
    override fun getView(): View? {
        return hmsVideoView
    }

    override fun dispose() {
        Log.e("HMSVIDEOVIEW","Dispose called for view with id:${hmsVideoView?.id}")
        hmsVideoView?.removeTrack()
        context.unregisterReceiver(broadcastReceiver)
        hmsVideoView = null
    }

}
