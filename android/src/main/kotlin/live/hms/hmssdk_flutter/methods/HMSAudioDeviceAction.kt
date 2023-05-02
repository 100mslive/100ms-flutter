package live.hms.hmssdk_flutter
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.audio.HMSAudioManager
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*



class HMSAudioDeviceAction {
    companion object {
        fun audioDeviceActions(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            when (call.method) {
                "get_audio_devices_list" -> {
                    getAudioDevicesList(call, result,hmssdk)
                }
                "get_current_audio_device"-> {
                    getCurrentDevice(call,result,hmssdk)
                }
                "switch_audio_output" -> {
                    switchAudioOutput(call,result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun getAudioDevicesList(call: MethodCall, result: Result,hmssdk:HMSSDK){
            val audioDevicesList = ArrayList<String>();
            for (device in hmssdk.getAudioDevicesList()){
                audioDevicesList.add(device.name);
            }
            CoroutineScope(Dispatchers.Main).launch {
                result.success(audioDevicesList)
            }
        }

        private fun getCurrentDevice(call: MethodCall, result: Result,hmssdk:HMSSDK){
            CoroutineScope(Dispatchers.Main).launch {
                result.success(hmssdk.getAudioOutputRouteType().name)
            }
        }

        private fun switchAudioOutput(call: MethodCall, result: Result,hmssdk:HMSSDK){
            var argument:String? = call.argument<String>("audio_device_name")
            if(argument!=null){
                var audioDevice:HMSAudioManager.AudioDevice = HMSAudioManager.AudioDevice.valueOf(argument)
                hmssdk.switchAudioOutput(audioDevice)
            }

        }
    }
}