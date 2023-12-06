package live.hms.hmssdk_flutter.views

import android.graphics.SurfaceTexture
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.view.TextureRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.VideoViewStateChangeListener
import live.hms.videoview.textureview.HMSTextureRenderer

class HMSTextureView(
    texture: SurfaceTexture,
    private var entry: TextureRegistry.SurfaceTextureEntry?,
) : EventChannel.StreamHandler {
    private var eventChannel: EventChannel? = null
    private var eventSink: EventSink? = null
    private var hmsTextureRenderer: HMSTextureRenderer? = null
    private var uid: Long? = null

    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        uid = entry?.id()
    }

    private val videoViewStateChangeListener =
        object : VideoViewStateChangeListener {
            override fun onResolutionChange(
                newWidth: kotlin.Int,
                newHeight: kotlin.Int,
            ) {
                val args = HashMap<String, Any?>()
                args["event_name"] = "on_resolution_changed"
                val data = HashMap<String, Int>()
                data["height"] = newHeight
                data["width"] = newWidth
                args["data"] = data
                if (args["data"] != null) {
                    CoroutineScope(Dispatchers.Main).launch {
                        eventSink?.success(args)
                    }
                }
            }

            override fun onFirstFrameRendered() {
                super.onFirstFrameRendered()
            }
        }

    fun addTrack(
        track: HMSVideoTrack,
        disableAutoSimulcastLayerSelect: Boolean,
        height: Int? = null,
        width: Int? = null,
    ) {
        Log.i("HMSTextureView", "Add Track called for track: ${track.trackId}")
        hmsTextureRenderer?.addVideoViewStateChangeListener(videoViewStateChangeListener)
        hmsTextureRenderer?.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
        if (!disableAutoSimulcastLayerSelect) {
            height?.let { videoViewHeight ->
                width?.let { videoViewWidth ->
                    hmsTextureRenderer?.displayResolution(videoViewWidth, videoViewHeight)
                }
            }
        }
        hmsTextureRenderer?.addTrack(track, true)
    }

    fun setDisplayResolution(
        width: Int,
        height: Int,
    ) {
        hmsTextureRenderer?.displayResolution(width, height)
    }

    fun removeTrack() {
        Log.i("HMSTextureView", "Remove Track called")
        hmsTextureRenderer?.removeTrack()
    }

    fun disposeTextureView() {
        Log.i("HMSTextureView", "disposeTextureView called")
        removeTrack()
        entry?.release()
        entry = null
        hmsTextureRenderer = null
        this.eventChannel = null
        eventSink = null
    }

    fun setTextureViewEventChannel(eventChannel: EventChannel) {
        this.eventChannel = eventChannel
    }

    override fun onListen(
        arguments: Any?,
        events: EventSink?,
    ) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
