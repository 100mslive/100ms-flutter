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
    val track: HMSVideoTrack,
    var entry: TextureRegistry.SurfaceTextureEntry?
){

//    var eventChannel: EventChannel? = null
//    var eventSink: EventSink? = null
    var hmsTextureRenderer: HMSTextureRenderer? = null
    var uid: Long? = null
    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        Log.i("HMSTextureView","creating texture view track: ${track.trackId}")
//        addTrack()
        uid = entry?.id()
    }

    fun addTrack(){
        Log.i("HMSTextureView","Add Track called for track: ${track.trackId}")
        hmsTextureRenderer?.addTrack(track)
    }

    fun removeTrack(){
        Log.i("HMSTextureView","Remove Track called for track: ${track.trackId}")
        hmsTextureRenderer?.removeTrack()
    }

    fun disposeTextureView(){
        Log.i("HMSTextureView","disposeTextureView track: ${track.trackId}")
        hmsTextureRenderer?.removeTrack()
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