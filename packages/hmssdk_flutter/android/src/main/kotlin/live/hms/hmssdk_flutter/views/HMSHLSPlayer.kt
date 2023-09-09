package live.hms.hmssdk_flutter.views

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import androidx.media3.common.Player
import androidx.media3.common.VideoSize
import androidx.media3.ui.AspectRatioFrameLayout.RESIZE_MODE_FIT
import androidx.media3.ui.AspectRatioFrameLayout.RESIZE_MODE_ZOOM
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

    /**
     *  Inflate the HLS player view and initialize the HLS player.
     *  Set the HLS player view and player if the inflation is successful.
     *  Otherwise, log an error indicating that the HLS player view is null.
     *  If inflation is successful, then we add the HLS Controls based on the parameter
     *  passed from flutter i.e. whether to show controls or not.
     */
    init {
        // Inflate the HLS player view using the layout inflater service.
        hlsPlayerView = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.hms_hls_player, this)?.findViewById(R.id.hlsView)
        hlsPlayerView?.let {

            // Set the HLS player controller visibility based on the showHLSControls flag.
            it.useController = showHLSControls

            // Initialize the HmsHlsPlayer with the provided context and hmssdk instance.
            hlsPlayer = HmsHlsPlayer(context, hmssdkFlutterPlugin?.hmssdk)

            // Set the native player of the HLS player view.
            it.player = hlsPlayer?.getNativePlayer()

            it.player?.addListener(object : Player.Listener {
                override fun onSurfaceSizeChanged(width: Int, height: Int) {
                    super.onSurfaceSizeChanged(width, height)

                }
                override fun onVideoSizeChanged(videoSize: VideoSize) {
                    super.onVideoSizeChanged(videoSize)

                        if (videoSize.height !=0 && videoSize.width !=0) {
                            val width = videoSize.width
                            val height = videoSize.height

                            //landscape play
                            if (width >= height) {
                                hlsPlayerView?.resizeMode = RESIZE_MODE_FIT
                            } else {
                                hlsPlayerView?.resizeMode = RESIZE_MODE_ZOOM
                            }
                        }
                }
            })
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

    /**
     *  This method is used to dispose of the HLS player and clean up resources.
     *  Stop the HLS player.
     *  Set the HLS player and player view references to null.
     *  Unregister the broadcast receiver.
     *  Remove the HLS stats listener.
     */
    fun dispose() {
        hlsPlayer?.stop()
        hlsPlayer = null
        hlsPlayerView = null
        context.unregisterReceiver(broadcastReceiver)
        HLSStatsHandler.removeStatsListener(hlsPlayer)
    }

    /**
     * An object implementing the HmsHlsPlaybackEvents interface.
     * It handles the events related to HLS playback.
     */
    private val hmsHLSPlaybackEvents = object : HmsHlsPlaybackEvents {

        /**
         * Callback function triggered when there is a playback failure in the HLS player.
         * It constructs a HashMap with the event details and error information, and sends it to the Flutter side through the plugin's sink.
         * - Parameters:
         *   - error: The HmsHlsException object representing the playback failure.
         */
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

        /**
         * Callback function triggered when the playback state of the HLS player changes.
         * It constructs a HashMap with the event details and the playback state information,
         * and sends it to the Flutter side through the plugin's sink.
         * - Parameters:
         *   - p1: The HmsHlsPlaybackState representing the updated playback state.
         */
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

        /**
         * Callback function triggered when a cue event occurs in the HLS player.
         * It constructs a HashMap with the event details and the cue information,
         * and sends it to the Flutter side through the plugin's sink.
         * - Parameters:
         *   - hlsCue: The HmsHlsCue representing the cue event.
         */
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

    /**
     * An object implementing the BroadcastReceiver interface.
     * It handles the events related to HLS Controller.
     */
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(contxt: Context?, intent: Intent?) {
            if (intent?.action == HLS_PLAYER_INTENT) {
                when (intent.extras?.getString(Constants.METHOD_CALL)) {
                    "start_hls_player" -> {
                        return start(intent.extras?.getString("hls_url"))
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
                        return seekForward(intent.extras?.getInt("seconds"))
                    }
                    "seek_backward" -> {
                        return seekBackward(intent.extras?.getInt("seconds"))
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

    /**
     * Below methods handles the HLS Player controller calls
     */
    private fun seekBackward(seconds: Int?) {
        seconds?.let { time ->
            hlsPlayer?.seekBackward(time.toLong(), TimeUnit.SECONDS)
        }
    }

    private fun seekForward(seconds: Int?) {
        seconds?.let { time ->
            hlsPlayer?.seekForward(time.toLong(), TimeUnit.SECONDS)
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

    /**
     * Starts the HLS player with the specified HLS URL.
     * - Parameters:
     * - hlsUrl: The HLS URL to play. If nil, the HLS URL from hmssdkFlutterPlugin will be used.
     */
    private fun start(hlsUrl: String?) {
        hlsUrl?.let {
            hlsPlayer?.play(hlsUrl)
        } ?: run {
            hmssdkFlutterPlugin?.hlsStreamUrl?.let {
                hlsPlayer?.play(it)
            } ?: run {
                HMSErrorLogger.logError("start", "HLS Stream URL is null", "NULL Error")
            }
        }
    }

    private fun setVolume(volume: Int?) {
        volume?.let {
            hlsPlayer?.volume = it
        }
    }

    /********************************************/
}
