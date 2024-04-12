package live.hms.hmssdk_flutter.views

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.RECEIVER_NOT_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.util.Log
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.media3.common.Player
import androidx.media3.common.VideoSize
import androidx.media3.common.text.CueGroup
import androidx.media3.ui.AspectRatioFrameLayout.RESIZE_MODE_FIT
import androidx.media3.ui.AspectRatioFrameLayout.RESIZE_MODE_ZOOM
import androidx.media3.ui.PlayerView
import io.flutter.plugin.common.MethodChannel.Result
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
import live.hms.hmssdk_flutter.hls_player.HMSHLSPlayerAction
import live.hms.hmssdk_flutter.hls_player.IHLSPlayerActionInterface
import java.lang.ref.WeakReference
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
    private var actions: IHLSPlayerActionInterface? = null

    /**
     *  Inflate the HLS player view and initialize the HLS player.
     *  Set the HLS player view and player if the inflation is successful.
     *  Otherwise, log an error indicating that the HLS player view is null.
     *  If inflation is successful, then we add the HLS Controls based on the parameter
     *  passed from flutter i.e. whether to show controls or not.
     */
    init {

        /**
         * [initializeMethodHandler] initializes the interface object
         * After this we assign the object to [HMSHLSPlayerAction] using the [assignInterfaceObject] method
         */
        initializeMethodHandler()
        HMSHLSPlayerAction.assignInterfaceObject(WeakReference(actions))

        // Inflate the HLS player view using the layout inflater service.
        hlsPlayerView =
            (
                context.getSystemService(
                    Context.LAYOUT_INFLATER_SERVICE,
                ) as LayoutInflater
            ).inflate(R.layout.hms_hls_player, this)?.findViewById(R.id.hlsView)
        hlsPlayerView?.let {

            // Set the HLS player controller visibility based on the showHLSControls flag.
            it.useController = showHLSControls

            // Initialize the HmsHlsPlayer with the provided context and hmssdk instance.
            hlsPlayer = HmsHlsPlayer(context, hmssdkFlutterPlugin?.hmssdk)

            // Set the native player of the HLS player view.
            it.player = hlsPlayer?.getNativePlayer()

            it.player?.addListener(
                object : Player.Listener {
                    override fun onSurfaceSizeChanged(
                        width: Int,
                        height: Int,
                    ) {
                        super.onSurfaceSizeChanged(width, height)
                    }

                    override fun onVideoSizeChanged(videoSize: VideoSize) {
                        super.onVideoSizeChanged(videoSize)

                        if (videoSize.height != 0 && videoSize.width != 0) {
                            val width = videoSize.width
                            val height = videoSize.height

                            /**
                             * This ensures that the stream is fit in case of landscape orientation
                             * If the orientation is landscape i.e. width >= height we set the mode to
                             * FIT else it's ZOOM by default
                             */
                            if (width >= height) {
                                hlsPlayerView?.resizeMode = RESIZE_MODE_FIT
                            } else {
                                hlsPlayerView?.resizeMode = RESIZE_MODE_ZOOM
                            }

                            val hashMap =HashMap<String, Any>()
                            val args = HashMap<String,Any>()
                            hashMap["event_name"] = "on_video_size_changed"
                            args["height"] = height
                            args["width"] = width
                            hashMap["data"] = args
                            CoroutineScope(Dispatchers.Main).launch {
                                hmssdkFlutterPlugin?.hlsPlayerSink?.success(hashMap)
                            }
                        }
                    }

                    override fun onCues(cueGroup: CueGroup) {
                        super.onCues(cueGroup)
                    }
                },
            )
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
        HLSStatsHandler.removeStatsListener(hlsPlayer)
        hlsPlayer = null
        hlsPlayerView = null
    }

    /**
     * An object implementing the HmsHlsPlaybackEvents interface.
     * It handles the events related to HLS playback.
     */
    private val hmsHLSPlaybackEvents =
        object : HmsHlsPlaybackEvents {
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
     * This handles the method call from flutter channel
     * and return the values
     */
    private fun initializeMethodHandler(){
        actions = object : IHLSPlayerActionInterface {

            /**
             * Starts the HLS player with the specified HLS URL.
             * - Parameters:
             * - hlsUrl: The HLS URL to play. If nil, the HLS URL from hmssdkFlutterPlugin will be used.
             */
            override fun start(hlsUrl: String?, result: Result) {
                hlsUrl?.let {
                    hlsPlayer?.play(hlsUrl)
                } ?: run {
                    hmssdkFlutterPlugin?.hlsStreamUrl?.let {
                        hlsPlayer?.play(it)
                    } ?: run {
                        HMSErrorLogger.logError("start", "HLS Stream URL is null", "NULL Error")
                    }
                }
                result.success(null)
            }

            override fun stop(result: Result) {
                hlsPlayer?.stop()
                result.success(null)
            }

            override fun pause(result: Result) {
                hlsPlayer?.pause()
                result.success(null)
            }

            override fun resume(result: Result) {
                hlsPlayer?.resume()
                result.success(null)
            }

            override fun seekToLivePosition(result: Result) {
                hlsPlayer?.seekToLivePosition()
                result.success(null)
            }

            override fun seekForward(seconds: Int, result: Result) {
                hlsPlayer?.seekForward(seconds.toLong(), TimeUnit.SECONDS)
                result.success(null)
            }

            override fun seekBackward(seconds: Int, result: Result) {
                hlsPlayer?.seekBackward(seconds.toLong(), TimeUnit.SECONDS)
                result.success(null)
            }

            override fun setVolume(volume: Int, result: Result) {
                hlsPlayer?.volume = volume
                result.success(null)
            }

            override fun addHLSStatsListener(result: Result) {
                HLSStatsHandler.addHLSStatsListener(hmssdkFlutterPlugin, hlsPlayer)
                result.success(null)
            }

            override fun removeHLSStatsListener(result: Result) {
                HLSStatsHandler.removeStatsListener(hlsPlayer)
                result.success(null)
            }

            override fun areClosedCaptionsSupported(result: Result) {
                val areCaptionsSupported = hlsPlayer?.areClosedCaptionsSupported()
                result.success(areCaptionsSupported)
            }

            override fun enableClosedCaptions(result: Result) {
                TODO("Not yet implemented")
            }

            override fun disableClosedCaptions(result: Result) {
                TODO("Not yet implemented")
            }

        }
    }
    /********************************************/
}
