package live.hms.hmssdk_flutter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.video.audio.HMSAudioManager
import live.hms.video.sdk.*


class HMSAudioDeviceAction {
    companion object {
        fun audioDeviceActions(call: MethodCall, result: Result,hmssdk:HMSSDK) {
            when (call.method) {
                "get_audio_devices_list" -> {
                    getAudioDevicesList(result, hmssdk)
                }
                "get_current_audio_device"-> {
                    getCurrentDevice(result, hmssdk)
                }
                "switch_audio_output" -> {
                    switchAudioOutput(call,result,hmssdk)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        private fun getAudioDevicesList(result: Result, hmssdk: HMSSDK){
            val audioDevicesList = ArrayList<String>()
            for (device in hmssdk.getAudioDevicesList()){
                audioDevicesList.add(device.name)
            }
            result.success(audioDevicesList)
        }

        private fun getCurrentDevice(result: Result, hmssdk: HMSSDK){
                result.success(hmssdk.getAudioOutputRouteType().name)
        }

        private fun switchAudioOutput(call: MethodCall, result: Result,hmssdk:HMSSDK){
            val argument = call.argument<String>("audio_device_name")?:
            run{
                HMSErrorLogger.logError("switchAudioOutput", "argument is null", "Parameter Error")
                result.success(HMSExceptionExtension.getError("argument is null in switchAudioOutput"))
                return
            }
            val audioDevice:HMSAudioManager.AudioDevice = HMSAudioManager.AudioDevice.valueOf(argument)
            hmssdk.switchAudioOutput(audioDevice)
            result.success(null)
        }
    }
}