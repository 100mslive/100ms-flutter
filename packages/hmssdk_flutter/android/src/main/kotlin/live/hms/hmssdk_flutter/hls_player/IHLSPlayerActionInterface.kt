package live.hms.hmssdk_flutter.hls_player

import io.flutter.plugin.common.MethodChannel.Result

/**
 * [IHLSPlayerActionInterface] contains HLS Player methods
 * This is implemented in HMSHLSPlayer view to execute the method calls
 * from flutter
 */
interface IHLSPlayerActionInterface {
    fun start(
        hlsUrl: String?,
        result: Result,
    )

    fun stop(result: Result)

    fun pause(result: Result)

    fun resume(result: Result)

    fun seekToLivePosition(result: Result)

    fun seekForward(
        seconds: Int,
        result: Result,
    )

    fun seekBackward(
        seconds: Int,
        result: Result,
    )

    fun setVolume(
        volume: Int,
        result: Result,
    )

    fun addHLSStatsListener(result: Result)

    fun removeHLSStatsListener(result: Result)

    fun areClosedCaptionsSupported(result: Result)

    fun enableClosedCaptions(result: Result)

    fun disableClosedCaptions(result: Result)

    fun getStreamProperties(result: Result)

    fun getHLSLayers(result: Result)

    fun setHLSLayer(
        hlsLayer: HashMap<Any, Any?>,
        result: Result,
    )

    fun getCurrentHLSLayer(result: Result)
}
