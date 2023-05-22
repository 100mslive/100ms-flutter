package live.hms.hmssdk_flutter.hls_player

import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.hls_player.HmsHlsPlayer
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.hmssdk_flutter.views.HMSHLSPlayer
import live.hms.stats.PlayerEventsCollector
import live.hms.stats.PlayerStatsListener
import live.hms.stats.model.InitConfig
import live.hms.stats.model.PlayerStatsModel
import live.hms.video.error.HMSException

class HLSStatsHandler {

    companion object{

        fun addHLSStatsListener(hmssdkFlutterPlugin: HmssdkFlutterPlugin?,hlsPlayer: HmsHlsPlayer?){
            hlsPlayer?.setStatsMonitor(object: PlayerStatsListener {
                override fun onError(error: HMSException) {
                    val hashMap: HashMap<String, Any?> = HashMap()
                    hmssdkFlutterPlugin?.let { plugin ->
                        hashMap["event_name"] = "on_hls_error"
                        hashMap["data"] = HMSExceptionExtension.toDictionary(error)
                        if(hashMap["data"]!= null){
                            CoroutineScope(Dispatchers.Main).launch {
                                plugin.hlsPlayerSink?.success(hashMap)
                            }
                        }
                    }
                }

                override fun onEventUpdate(playerStatsModel: PlayerStatsModel) {
                    val hashMap: HashMap<String, Any?> = HashMap()
                    hmssdkFlutterPlugin?.let {plugin ->
                        hashMap["event_name"] = "on_hls_event_update"
                        hashMap["data"] = HMSPlayerStatsExtension.toDictionary(playerStatsModel)
                        if(hashMap["data"]!= null){
                            Log.v("Vkohli","Sending onEventUpdate $hashMap")
                            CoroutineScope(Dispatchers.Main).launch {
                                plugin.hlsPlayerSink?.success(hashMap)
                            }
                        }
                    }
                }

            })?:run{
                HMSErrorLogger.logError("addHLSStatsListener","hlsPlayer is null, Consider calling this method after attaching the HMSHLSPlayer or sending isHLSStatsRequired as true to get the stats","NULL_ERROR")
            }
        }

        fun removeStatsListener(hlsPlayer:HmsHlsPlayer?){
            hlsPlayer?.setStatsMonitor(null) ?:run {
                HMSErrorLogger.logError("removeStatsListener","hlsPlayer is null","NULL_ERROR")
            }
        }
    }


}