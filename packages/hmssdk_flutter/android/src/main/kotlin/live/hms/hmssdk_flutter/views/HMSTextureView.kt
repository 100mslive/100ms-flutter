package live.hms.hmssdk_flutter.views

import android.graphics.SurfaceTexture
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.textureview.HMSTextureRenderer

class HMSTextureView(
    texture: SurfaceTexture,
    track: HMSVideoTrack
): EventChannel.StreamHandler{

    var eventChannel: EventChannel? = null
    var eventSink: EventSink? = null
    var hmsTextureRenderer: HMSTextureRenderer? = null

    init {
        hmsTextureRenderer = HMSTextureRenderer(texture)
        hmsTextureRenderer?.addTrack(track)
    }

    fun disposeTextureView(){
        hmsTextureRenderer?.removeTrack()
        hmsTextureRenderer = null
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