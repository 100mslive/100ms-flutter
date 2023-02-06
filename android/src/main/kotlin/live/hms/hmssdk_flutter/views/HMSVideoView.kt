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
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.logError
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
    private val disableAutoSimulcastLayerSelect: Boolean
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
                logError("HMSVideoView onReceive","No receiver found for given action","HMSVideoView Receiver error")
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
            logError("HMSVideoView init","view is null","HMSVideoView Error")
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
                            logError("HMSVideoView captureSnapshot","hmsVideoViewResult is null","Receiver error")
                        }
                    } else {
                        logError("HMSVideoView captureSnapshot","hmssdkFlutterPlugin is null","Receiver error")
                    }
                }
            })
        } else {
            logError("HMSVideoView captureSnapshot","hmsVideoView is null","Receiver error")
        }
    }

    fun onDisposeCalled() {
        if (hmsVideoView != null) {
            hmsVideoView?.removeTrack()
        } else {
            logError("HMSVideoView onDisposeCalled","hmsVideoView is null","HMSVideoView error")
        }
        this.removeView(view)
        view = null
        hmsVideoView = null
        context.unregisterReceiver(broadcastReceiver)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (track != null) {
            hmsVideoView?.addTrack(track)
            context.registerReceiver(broadcastReceiver, IntentFilter(track.trackId))
        } else {
            logError("HMSVideoView onAttachedToWindow","track is null, cannot attach null track","HMSVideoView error")
        }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        if (hmsVideoView != null) {
            hmsVideoView?.removeTrack()
        } else {
            logError("HMSVideoView onDetachedFromWindow","hmsVideoView is null","HMSVideoView error")
        }
    }
}
