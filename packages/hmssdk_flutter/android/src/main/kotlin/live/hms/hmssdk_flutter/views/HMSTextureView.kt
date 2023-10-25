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
){

//    var eventChannel: EventChannel? = null
//    var eventSink: EventSink? = null
    private var hmsTextureRenderer: HMSTextureRenderer? = null
    var uid: Long? = null
    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        uid = entry?.id()
    }

    fun addTrack(track: HMSVideoTrack){
        Log.i("HMSTextureView","Add Track called for track: ${track.trackId}")
        hmsTextureRenderer?.addTrack(track)
    }

    fun removeTrack(){
        Log.i("HMSTextureView","Remove Track called")
        hmsTextureRenderer?.removeTrack()
    }

    fun disposeTextureView(){
        Log.i("HMSTextureView","disposeTextureView called")
        removeTrack()
        entry?.release()
        entry = null
        hmsTextureRenderer = null
    }

//    fun setTextureViewEventChannel(eventChannel:EventChannel){
//       this.eventChannel = eventChannel
//    }
//
//    override fun onListen(arguments: Any?, events: EventSink?) {
//        eventSink = events
//    }
//
//    override fun onCancel(arguments: Any?) {
//        eventSink = null
//    }
}