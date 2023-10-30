package live.hms.hmssdk_flutter.views

import android.graphics.SurfaceTexture
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.view.TextureRegistry
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.textureview.HMSTextureRenderer

class HMSTextureView(
    texture: SurfaceTexture,
    var entry: TextureRegistry.SurfaceTextureEntry?
):EventChannel.StreamHandler{

    var eventChannel: EventChannel? = null
    var eventSink: EventSink? = null
    private var hmsTextureRenderer: HMSTextureRenderer? = null
    var uid: Long? = null
    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        uid = entry?.id()
    }

    fun addTrack(track: HMSVideoTrack){
        Log.i("HMSTextureView","Add Track called for track: ${track.trackId}")
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