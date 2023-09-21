package live.hms.hmssdk_flutter.hls_player

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hls_player.HmsHlsPlayer
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.stats.PlayerStatsListener
import live.hms.stats.model.PlayerStatsModel
import live.hms.video.error.HMSException

/**
 * This class handles the HLS Player stats
 */
class HLSStatsHandler {
    companion object {
        /**
         * Adds an HLS stats listener to the HLS player.
         * This listener captures HLS player errors and updates in player stats.
         *
         * @param hmssdkFlutterPlugin The HMSSDK Flutter plugin instance.
         * @param hlsPlayer The HLS player instance.
         */
        fun addHLSStatsListener(
            hmssdkFlutterPlugin: HmssdkFlutterPlugin?,
            hlsPlayer: HmsHlsPlayer?,
        ) {
            hlsPlayer?.setStatsMonitor(
                object : PlayerStatsListener {
                    /**
                     * Callback method triggered when an HLS error occurs during playback.
                     *
                     * @param error The HMSException representing the error.
                     */
                    override fun onError(error: HMSException) {
                        val hashMap: HashMap<String, Any?> = HashMap()
                        hmssdkFlutterPlugin?.let { plugin ->
                            hashMap["event_name"] = "on_hls_error"
                            hashMap["data"] = HMSExceptionExtension.toDictionary(error)
                            if (hashMap["data"] != null) {
                                CoroutineScope(Dispatchers.Main).launch {
                                    plugin.hlsPlayerSink?.success(hashMap)
                                }
                            }
                        }
                    }

                    /**
                     * Callback method triggered when an HLS player event update occurs.
                     *
                     * @param playerStatsModel The PlayerStatsModel containing the updated player statistics.
                     */
                    override fun onEventUpdate(playerStatsModel: PlayerStatsModel) {
                        val hashMap: HashMap<String, Any?> = HashMap()
                        hmssdkFlutterPlugin?.let { plugin ->
                            hashMap["event_name"] = "on_hls_event_update"
                            hashMap["data"] = HMSPlayerStatsExtension.toDictionary(playerStatsModel)
                            if (hashMap["data"] != null) {
                                CoroutineScope(Dispatchers.Main).launch {
                                    plugin.hlsPlayerSink?.success(hashMap)
                                }
                            }
                        }
                    }
                },
            ) ?: run {
                HMSErrorLogger.logError("addHLSStatsListener", "hlsPlayer is null, Consider calling this method after attaching the HMSHLSPlayer or sending isHLSStatsRequired as true to get the stats", "NULL_ERROR")
            }
        }

        /**
         * Removes the HLS stats listener from the HLS player.
         *
         * @param hlsPlayer The HLS player instance.
         */
        fun removeStatsListener(hlsPlayer: HmsHlsPlayer?) {
            hlsPlayer?.setStatsMonitor(null) ?: run {
                HMSErrorLogger.logError("removeStatsListener", "hlsPlayer is null", "NULL_ERROR")
            }
        }
    }
}
