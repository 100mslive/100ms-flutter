package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSExceptionExtension
import live.hms.hmssdk_flutter.HMSSimulcastLayerDefinitionExtension
import live.hms.hmssdk_flutter.HMSSimulcastLayerExtension
import live.hms.video.media.tracks.HMSRemoteVideoTrack
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.models.HMSRoom
import live.hms.video.utils.HmsUtilities

class HMSRemoteVideoTrackAction {

    companion object {
        fun remoteVideoTrackActions(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            when (call.method) {
                "set_simulcast_layer" -> setSimulcastLayer(call, result, hmssdk)
                "get_layer" -> getLayer(call, result, hmssdk)
                "get_layer_definition" -> getLayerDefinition(call, result, hmssdk)
            }
        }

        private fun setSimulcastLayer(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id") ?:
            run {
                HMSErrorLogger.logError("setSimulcastLayer", "trackId is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("trackId is null in setSimulcastLayer"))
                return
            }
            val simulcastLayer = call.argument<String>("layer") ?:
            run {
                HMSErrorLogger.logError("setSimulcastLayer", "simulcastLayer is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("simulcastLayer is null in setSimulcastLayer"))
                return
            }

            val room = hmssdk.getRoom()
            room  ?:
            run{
                HMSErrorLogger.logError("setSimulcastLayer", "room is null", "Null Error")
                result.success(HMSExceptionExtension.getError("room is null in setSimulcastLayer"))
                return
            }
            val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId, room) as HMSRemoteVideoTrack?
            track ?:
            run{
                HMSErrorLogger.logError("setSimulcastLayer", "Can't find track with trackId:$trackId", "Null Error")
                result.success(HMSExceptionExtension.getError("Can't find track with trackId:$trackId in setSimulcastLayer"))
                return
            }
            track.setLayer(HMSSimulcastLayerExtension.getLayerFromString(layer = simulcastLayer))
            result.success(null)
        }

        private fun getLayer(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id") ?:
            run {
                HMSErrorLogger.logError("getLayer", "trackId is null", "Parameter Error")
                result.success(null)
                return
            }
            val room: HMSRoom = hmssdk.getRoom()
                ?: run {
                    HMSErrorLogger.logError("setSimulcastLayer", "room is null", "Null Error")
                    result.success(null)
                    return
                }
            val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId, room) as HMSRemoteVideoTrack?
            if (track != null) {
                result.success(HMSSimulcastLayerExtension.getStringFromLayer(track.getLayer()))
            }
            result.success(null)
        }

        private fun getLayerDefinition(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id") ?:
            run {
                HMSErrorLogger.logError("getLayerDefinition", "trackId is null", "Parameter Error")
                result.success(null)
                return
            }

            val room: HMSRoom = hmssdk.getRoom()
           ?: run{
               HMSErrorLogger.logError("setSimulcastLayer", "room is null", "Null Error")
               result.success(null)
                return
            }
            val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId, room) as HMSRemoteVideoTrack?
            val hashMap = ArrayList<HashMap<String, Any?>>()
            if (track != null) {
                track.getLayerDefinition().forEach {
                    hashMap.add(HMSSimulcastLayerDefinitionExtension.toDictionary(it))
                }
                result.success(hashMap)
            }
            result.success(null)
        }
    }
}
