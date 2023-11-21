package live.hms.hmssdk_flutter.views

import android.graphics.SurfaceTexture
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.view.TextureRegistry
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.VideoViewStateChangeListener
import live.hms.videoview.textureview.HMSTextureRenderer

class HMSTextureView(
    texture: SurfaceTexture,
    private var entry: TextureRegistry.SurfaceTextureEntry?
):EventChannel.StreamHandler{

    private var eventChannel: EventChannel? = null
    private var eventSink: EventSink? = null
    private var hmsTextureRenderer: HMSTextureRenderer? = null
    private var uid: Long? = null
    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        uid = entry?.id()
    }

    private val videoViewStateChangeListener = object : VideoViewStateChangeListener{
        override fun onResolutionChange(newWidth: kotlin.Int, newHeight: kotlin.Int) {

        }

        override fun onFirstFrameRendered() {
            super.onFirstFrameRendered()
        }
    }

    fun addTrack(track: HMSVideoTrack, disableAutoSimulcastLayerSelect: Boolean, height: Int?, width: Int?){
        Log.i("HMSTextureView","Add Track called for track: ${track.trackId}")
        hmsTextureRenderer?.addVideoViewStateChangeListener(videoViewStateChangeListener)
        hmsTextureRenderer?.disableAutoSimulcastLayerSelect(disableAutoSimulcastLayerSelect)
        if(!disableAutoSimulcastLayerSelect){
            height?.let { videoHeight ->
                width?.let { videoWidth ->
                    hmsTextureRenderer?.displayResolution(videoWidth,videoHeight)
                }
            }
        }
        hmsTextureRenderer?.addTrack(track)
        eventSink?.success("Hey there addTrack Called")
    }

    fun removeTrack(){
        Log.i("HMSTextureView","Remove Track called")
        hmsTextureRenderer?.removeTrack()
        eventSink?.success("Hey there removeTrack called")
    }

    fun disposeTextureView(){
        Log.i("HMSTextureView","disposeTextureView called")
        removeTrack()
        entry?.release()
        entry = null
        hmsTextureRenderer = null
        this.eventChannel = null
        eventSink = null
    }

    fun setTextureViewEventChannel(eventChannel:EventChannel){
       this.eventChannel = eventChannel
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}