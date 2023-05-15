package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.view.LayoutInflater
import live.hms.hmssdk_flutter.R
import android.widget.FrameLayout
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hls_player.*
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.hls_player.HMSHLSCueExtension
import live.hms.hmssdk_flutter.hls_player.HMSHLSPlaybackStateExtension
import java.util.concurrent.TimeUnit

class HMSHLSPlayer(
    context: Context,
    private val hlsUrl: String?,
    private val hmssdkFlutterPlugin: HmssdkFlutterPlugin?,
    ): FrameLayout(context,null) {

    var hlsPlayer: HmsHlsPlayer? = null
    private var hlsPlayerView: PlayerView? = null
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(contxt: Context?, intent: Intent?) {
            if (intent?.action == "hms_player") {
                when (intent?.extras?.getString("method_name")) {
                    "start_hls_player" -> {
                        return start()
                    }
                    "stop_hls_player" -> {
                        return stop()
                    }
                    "pause_hls_player" -> {
                        return pause()
                    }
                    "resume_hls_player" -> {
                        return resume()
                    }
                    "seek_to_live_position" -> {
                        return seekToLivePosition()
                    }
                    "seek_forward" -> {
                        return seekForward(intent?.extras?.getLong("seconds"))
                    }
                    "seek_backward" -> {
                        return seekBackward(intent?.extras?.getLong("seconds"))
                    }
                }
            } else {
                Log.e("Receiver error", "No receiver found for given action")
            }
        }
    }

    private fun seekBackward(seconds: Long?) {
        seconds?.let { time ->
            hlsPlayer?.seekBackward(time,TimeUnit.SECONDS)
        }
    }

    private fun seekForward(seconds: Long?) {
        seconds?.let { time ->
            hlsPlayer?.seekForward(time,TimeUnit.SECONDS)
        }
    }

    private fun seekToLivePosition() {
        hlsPlayer?.seekToLivePosition()
    }

    private fun resume() {
        hlsPlayer?.resume()
    }

    private fun pause() {
        hlsPlayer?.pause()
    }

    private fun stop() {
        hlsPlayer?.stop()
    }

    private fun start() {

        hmssdkFlutterPlugin?.hlsStreamUrl?.let {
            hlsPlayer?.play(it)
        }?:run {
            HMSErrorLogger.logError("start","HLS Stream URL is null","NULL Error")
        }
    }

    init {
        hlsPlayerView = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.hms_hls_player, this)?.findViewById(R.id.hlsView)
        if(hlsPlayerView != null){
            hlsPlayer = HmsHlsPlayer(context, hmssdkFlutterPlugin?.hmssdk)
            hlsPlayerView?.player = hlsPlayer?.getNativePlayer()

        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        /**
         * Here we start the player
         * We first check whether the user has passed the streamUrl or not
         * If not, we fetch the URL from SDK
         * else we use the URL sent by the user
         */
        hlsPlayer?.let { player ->
            hlsUrl?.let {
                player.play(hlsUrl)
            }?:run{
                hmssdkFlutterPlugin?.let { plugin ->
                    plugin.hlsStreamUrl?.let { streamUrl ->
                        player.play(streamUrl)
                        context.registerReceiver(broadcastReceiver, IntentFilter("hms_player"))
                        player.addPlayerEventListener(
                            object : HmsHlsPlaybackEvents{
                                val hashMap: HashMap<String, Any?> = HashMap()
                                override fun onPlaybackFailure(error : HmsHlsException) {
                                    Log.d("HMSHLSPLAYER","From App, error: ${error.error.localizedMessage}")
                                    val args: HashMap<String, String?> = HashMap()
                                    hashMap["event_name"] = "on_playback_failure"
                                    args["error"] = error.error.localizedMessage
                                    hashMap["data"] = args
                                    CoroutineScope(Dispatchers.Main).launch {
                                        hmssdkFlutterPlugin.hlsPlayerSink?.success(hashMap)
                                    }
                                }

                                override fun onPlaybackStateChanged(p1 : HmsHlsPlaybackState){
                                    Log.d("HMSHLSPLAYER","From App, playback state: $p1")
                                    hashMap["event_name"] = "on_playback_state_changed"
                                    hashMap["data"] = HMSHLSPlaybackStateExtension.toDictionary(p1)
                                    if(hashMap["data"]!= null){
                                        CoroutineScope(Dispatchers.Main).launch {
                                            hmssdkFlutterPlugin.hlsPlayerSink?.success(hashMap)
                                        }
                                    }
                                }

                                override fun onCue(hlsCue : HmsHlsCue) {
                                    Log.d("HMSHLSPLAYER","From App, onCue: ${hlsCue.payloadval}")
                                    hashMap["event_name"] = "on_cue"
                                    hashMap["data"] = HMSHLSCueExtension.toDictionary(hlsCue)
                                    if(hashMap["data"]!= null){
                                        CoroutineScope(Dispatchers.Main).launch {
                                            hmssdkFlutterPlugin.hlsPlayerSink?.success(hashMap)
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        hlsPlayer?.stop()
        hlsPlayer = null
        hlsPlayerView = null
        context.unregisterReceiver(broadcastReceiver)
    }

    fun dispose() {
        hlsPlayer?.stop()
        hlsPlayer = null
        hlsPlayerView = null
        context.unregisterReceiver(broadcastReceiver)
    }
}