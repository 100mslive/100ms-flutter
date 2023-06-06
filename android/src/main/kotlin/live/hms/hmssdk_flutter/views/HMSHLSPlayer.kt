package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.media3.ui.PlayerView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hls_player.*
import live.hms.hmssdk_flutter.Constants
import live.hms.hmssdk_flutter.Constants.Companion.HLS_PLAYER_INTENT
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.R
import live.hms.hmssdk_flutter.hls_player.HLSStatsHandler
import live.hms.hmssdk_flutter.hls_player.HMSHLSCueExtension
import live.hms.hmssdk_flutter.hls_player.HMSHLSPlaybackStateExtension
import java.util.concurrent.TimeUnit

/**
 * This class renders the HMSHLSPlayer over Android View
 *
 * We create the object of this class when the init of HMSHLSPlayerWidget is called from create method.
 */
class HMSHLSPlayer(
    context: Context,
    private val hlsUrl: String?,
    private val hmssdkFlutterPlugin: HmssdkFlutterPlugin?,
    private val isHLSStatsRequired: Boolean,
    showHLSControls: Boolean,
) : FrameLayout(context, null) {

    var hlsPlayer: HmsHlsPlayer? = null
    private var hlsPlayerView: PlayerView? = null
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(contxt: Context?, intent: Intent?) {
            if (intent?.action == HLS_PLAYER_INTENT) {
                when (intent.extras?.getString(Constants.METHOD_CALL)) {
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
                        return seekForward(intent.extras?.getLong("seconds"))
                    }
                    "seek_backward" -> {
                        return seekBackward(intent.extras?.getLong("seconds"))
                    }
                    "set_volume" -> {
                        return setVolume(intent.extras?.getInt("volume"))
                    }
                    "add_hls_stats_listener" -> {
                        return HLSStatsHandler.addHLSStatsListener(hmssdkFlutterPlugin, hlsPlayer)
                    }
                    "remove_hls_stats_listener" -> {
                        return HLSStatsHandler.removeStatsListener(hlsPlayer)
                    }
                }
            } else {
                Log.e("Receiver error", "No receiver found for given action")
            }
        }
    }

    private fun seekBackward(seconds: Long?) {
        seconds?.let { time ->
            hlsPlayer?.seekBackward(time, TimeUnit.SECONDS)
        }
    }

    private fun seekForward(seconds: Long?) {
        seconds?.let { time ->
            hlsPlayer?.seekForward(time, TimeUnit.SECONDS)
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
        } ?: run {
            HMSErrorLogger.logError("start", "HLS Stream URL is null", "NULL Error")
        }
    }

    private fun setVolume(volume: Int?) {
        volume?.let {
            hlsPlayer?.volume = it
        }
    }

    init {
        hlsPlayerView = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.hms_hls_player, this)?.findViewById(R.id.hlsView)
        hlsPlayerView?.let {
            it.useController = showHLSControls
            hlsPlayer = HmsHlsPlayer(context, hmssdkFlutterPlugin?.hmssdk)
            it.player = hlsPlayer?.getNativePlayer()
        } ?: run {
            HMSErrorLogger.logError("init HMSHLSPlayer", "hlsPlayerView is null", "NULL_ERROR")
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
                /**
                 * Here we play the stream using streamUrl using the stream from
                 * url passed by the user
                 */
                player.play(hlsUrl)
            } ?: run {
                hmssdkFlutterPlugin?.let { plugin ->
                    plugin.hlsStreamUrl?.let { streamUrl ->
                        /**
                         * Here we play the stream using streamUrl using the stream from
                         * onRoomUpdate or onJoin
                         */
                        player.play(streamUrl)
                        context.registerReceiver(broadcastReceiver, IntentFilter(HLS_PLAYER_INTENT))

                        /**
                         * Here we add the event listener to listen to the events
                         * of HLS Player
                         */
                        player.addPlayerEventListener(
                            hmsHLSPlaybackEvents,
                        )

                        /**
                         * Here we add the stats listener to the
                         * HLS Player
                         */
                        if (isHLSStatsRequired) {
                            HLSStatsHandler.addHLSStatsListener(hmssdkFlutterPlugin, hlsPlayer)
                        }
                    }
                }
            }
        }
    }

    fun dispose() {
        hlsPlayer?.stop()
        hlsPlayer = null
        hlsPlayerView = null
        context.unregisterReceiver(broadcastReceiver)
        HLSStatsHandler.removeStatsListener(hlsPlayer)
    }

    private val hmsHLSPlaybackEvents = object : HmsHlsPlaybackEvents {
        override fun onPlaybackFailure(error: HmsHlsException) {
            val hashMap: HashMap<String, Any?> = HashMap()
            val args: HashMap<String, String?> = HashMap()
            hashMap["event_name"] = "on_playback_failure"
            args["error"] = error.error.localizedMessage
            hashMap["data"] = args
            CoroutineScope(Dispatchers.Main).launch {
                hmssdkFlutterPlugin?.hlsPlayerSink?.success(hashMap)
            }
        }

        override fun onPlaybackStateChanged(p1: HmsHlsPlaybackState) {
            val hashMap: HashMap<String, Any?> = HashMap()
            hashMap["event_name"] = "on_playback_state_changed"
            hashMap["data"] = HMSHLSPlaybackStateExtension.toDictionary(p1)
            if (hashMap["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    hmssdkFlutterPlugin?.hlsPlayerSink?.success(hashMap)
                }
            }
        }

        override fun onCue(hlsCue: HmsHlsCue) {
            val hashMap: HashMap<String, Any?> = HashMap()
            hashMap["event_name"] = "on_cue"
            hashMap["data"] = HMSHLSCueExtension.toDictionary(hlsCue)
            if (hashMap["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    hmssdkFlutterPlugin?.hlsPlayerSink?.success(hashMap)
                }
            }
        }
    }
}
