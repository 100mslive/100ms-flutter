package live.hms.hmssdk_flutter.views

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hmssdk_flutter.R
import live.hms.video.media.tracks.HMSVideoTrack
import live.hms.videoview.HMSVideoView
import live.hms.videoview.VideoViewStateChangeListener
import org.webrtc.RendererCommon


//class TestStreamHandler(private var videoViewSink : EventChannel.EventSink?,val track: HMSVideoTrack) :
//    {

//    override fun onFirstFrameRendered(){
//
//        Log.i("xyzonFirstFrame called","TrackId : ${track.trackId}")
//
//        val hashMap: HashMap<String, Any?> = HashMap()
//        hashMap["event_name"] = "on_first_frame_rendered"
//        hashMap["data"] = track.trackId
//        CoroutineScope(Dispatchers.Main).launch {
//            if (videoViewSink == null) {
//                Log.i(
//                    "xyz videoViewSink",
//                    "onFirstFrameRendered Videoviewsink is null trackId : ${track.trackId}"
//                )
//            } else {
//                videoViewSink?.success(hashMap)
//            }
//        }
//    }
//
//    override fun onResolutionChange(newWidth: Int, newHeight: Int){
//
//        val hashMap: HashMap<String, Any?> = HashMap()
//
//        val resolutionHashMap : HashMap<String, Any?> = HashMap()
//
//        resolutionHashMap["new_width"] = newWidth
//        resolutionHashMap["new_height"] = newHeight
//        resolutionHashMap["track_id"] = track.trackId
//
//        Log.i("xyzonResolution called","hashmap : ${resolutionHashMap} and TrackId : ${track.trackId}")
//
//        hashMap["event_name"] = "on_resolution_change"
//        hashMap["data"] = resolutionHashMap
//
//        CoroutineScope(Dispatchers.Main).launch {
//            if(videoViewSink == null){
//                Log.i("xyz videoViewSink", "onResolutionChange Videoviewsink is null trackId : ${track.trackId}")
//            }
//            else
//            {
//                videoViewSink?.success(hashMap)
//            }
//        }
//
//    }

//    override fun onListen(arguments: Any, events: EventChannel.EventSink) {
//        Log.i("xyz onListen called","Attached videoviewsink trackId: ${track.trackId}")
//        videoViewSink = events
//    }
//
//    override fun onCancel(arguments: Any) {
//
//        Log.i("xyz onCancel called","Attached videoviewsink trackId: ${track.trackId}")
//        val nameOfEventSink = (arguments as HashMap<String, Any>)["name"]
//        if (nameOfEventSink!! == "hms_video_view") {
//            videoViewSink = null
//        }
//    }
//}

class HMSVideoView(
        context: Context,
        setMirror: Boolean,
        scaleType: Int? = RendererCommon.ScalingType.SCALE_ASPECT_FIT.ordinal,
        private val track:HMSVideoTrack,
        isVideoViewStateChangeListenerAdded: Boolean,
        private val binaryMessenger: BinaryMessenger
) : FrameLayout(context, null),VideoViewStateChangeListener{

    private val hmsVideoView: HMSVideoView
    private var videoViewChannel: EventChannel? = null
    private var videoViewSink : EventChannel.EventSink? = null

    init {
        val inflater =
            getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val view = inflater.inflate(R.layout.hms_video_view, this)
        hmsVideoView = view.findViewById(R.id.hmsVideoView)
        hmsVideoView.setEnableHardwareScaler(false)
        hmsVideoView.setMirror(setMirror)
        hmsVideoView.setAutoSimulcast(true)
            if(isVideoViewStateChangeListenerAdded){
            this.videoViewChannel =
                EventChannel(binaryMessenger,"hms_video_view_channel${track.trackId}")
                this.videoViewChannel!!.setStreamHandler(
                object : EventChannel.StreamHandler{
                    override fun onListen(arguments: Any, events: EventChannel.EventSink) {
                        Log.i("xyz onListen called","Attached videoviewsink trackId: ${track.trackId}")
                        videoViewSink = events
                    }

                    override fun onCancel(arguments: Any) {
                        Log.i("xyz onCancel called","Attached videoviewsink trackId: ${track.trackId}")
                            videoViewSink = null
                    }
                }
            )
                hmsVideoView.addVideoViewStateChangeListener(this)
            }
        if ((scaleType ?: 0) <= RendererCommon.ScalingType.values().size) {
            hmsVideoView.setScalingType(RendererCommon.ScalingType.values()[scaleType ?: 0])
        }
        Log.i("init called","ViewId : ${hmsVideoView.id} and TrackId : ${track.trackId}")
    }

    fun onDisposeCalled(){
        Log.i("Dispose called","ViewId : ${hmsVideoView!!.id} and TrackId : ${track.trackId}")
        hmsVideoView.removeTrack()
    }

    fun addTrack(){
        hmsVideoView.addTrack(track)
    }

    fun removeTrack(){
        hmsVideoView.removeTrack()
    }

//    override fun onAttachedToWindow() {
//        super.onAttachedToWindow()
//        hmsVideoView.addTrack(track)
//    }

//    override fun onDetachedFromWindow() {
//        super.onDetachedFromWindow()
//        hmsVideoView.removeTrack()
//    }

    override fun onFirstFrameRendered(){

        Log.i("xyzonFirstFrame called","TrackId : ${track.trackId}")

        val hashMap: HashMap<String, Any?> = HashMap()
        hashMap["event_name"] = "on_first_frame_rendered"
        hashMap["data"] = track.trackId
        CoroutineScope(Dispatchers.Main).launch {
            if (videoViewSink == null) {
                Log.i(
                    "xyz videoViewSink",
                    "onFirstFrameRendered Videoviewsink is null trackId : ${track.trackId}"
                )
            } else {
                videoViewSink?.success(hashMap)
            }
        }
    }

    override fun onResolutionChange(newWidth: Int, newHeight: Int){

        val hashMap: HashMap<String, Any?> = HashMap()

        val resolutionHashMap : HashMap<String, Any?> = HashMap()

        resolutionHashMap["new_width"] = newWidth
        resolutionHashMap["new_height"] = newHeight
        resolutionHashMap["track_id"] = track.trackId

        Log.i("xyzonResolution called","hashmap : ${resolutionHashMap} and TrackId : ${track.trackId}")

        hashMap["event_name"] = "on_resolution_change"
        hashMap["data"] = resolutionHashMap

        CoroutineScope(Dispatchers.Main).launch {
            if(videoViewSink == null){
                Log.i("xyz videoViewSink", "onResolutionChange Videoviewsink is null trackId : ${track.trackId}")
            }
            else
            {
                videoViewSink?.success(hashMap)
            }
        }
    }
}
