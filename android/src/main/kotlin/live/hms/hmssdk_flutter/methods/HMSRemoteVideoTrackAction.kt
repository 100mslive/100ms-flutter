package live.hms.hmssdk_flutter.methods

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import live.hms.hmssdk_flutter.HMSErrorLogger
import live.hms.hmssdk_flutter.HMSErrorLogger.Companion.returnError
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
            val trackId = call.argument<String>("track_id") ?: returnError("setSimulcastLayer error trackId is null")
            val simulcastLayer = call.argument<String>("layer") ?: returnError("setSimulcastLayer error simulcastLayer is null")

            if (trackId == null || simulcastLayer == null) {
                val map = HashMap<String, Map<String, String>>()
                val error = HashMap<String, String>()
                error["message"] = "Could not set simulcast layer for track"
                error["action"] = "NONE"
                error["description"] = "Either trackId or simulcastLayer is null"
                map["error"] = error
                result.success(map)
            }

            val room = hmssdk.getRoom()
            if (room != null) {
                val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId as String, room) as HMSRemoteVideoTrack?
                if (track != null) {
                    track.setLayer(HMSSimulcastLayerExtension.getLayerFromString(layer = simulcastLayer as String))
                    result.success(null)
                } else {
                    val map = HashMap<String, Map<String, String>>()
                    val error = HashMap<String, String>()
                    error["message"] = "Could not set simulcast layer for track"
                    error["action"] = "NONE"
                    error["description"] = "No track found for corresponding trackId"
                    map["error"] = error
                    result.success(map)
                }
            }
        }

        private fun getLayer(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id") ?: returnError("getLayer error trackId is null")
            val room: HMSRoom? = hmssdk.getRoom()
            if (trackId == null || room == null) {
                result.success(null)
                return
            }
            val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId as String, room) as HMSRemoteVideoTrack?
            if (track != null) {
                result.success(HMSSimulcastLayerExtension.getStringFromLayer(track.getLayer()))
            }
            result.success(null)
        }

        private fun getLayerDefinition(call: MethodCall, result: MethodChannel.Result, hmssdk: HMSSDK) {
            val trackId = call.argument<String>("track_id") ?: returnError("getLayerDefinition error trackId is null")
            val room: HMSRoom? = hmssdk.getRoom()
            if (trackId == null || room == null) {
                result.success(null)
                return
            }
            val track: HMSRemoteVideoTrack? = HmsUtilities.getVideoTrack(trackId as String, room) as HMSRemoteVideoTrack?
            var hashMap = ArrayList<HashMap<String, Any?>>()
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
