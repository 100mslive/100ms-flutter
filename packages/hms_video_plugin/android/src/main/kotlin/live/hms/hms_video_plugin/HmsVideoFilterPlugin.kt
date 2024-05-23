package live.hms.hms_video_plugin

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import live.hms.hmssdk_flutter.HmssdkFlutterPlugin
import live.hms.video.sdk.HMSSDK

/** HmsVideoFilterPlugin */
class HmsVideoFilterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var hmssdkFlutterPlugin: HmssdkFlutterPlugin? = null
  private var engine : FlutterEngine? = null
  private var hmssdk : HMSSDK? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hms_video_filter")
        channel.setMethodCallHandler(this)
        engine = flutterPluginBinding.flutterEngine
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "enable_virtual_background", "disable_virtual_background", "enable_blur_background", "disable_blur_background", "change_virtual_background", "is_virtual_background_supported" -> {
            if(hmssdk == null){
                Log.i("VKohli", "hmssdk flutter plugin NULL engine ${engine?.plugins?.has(HmssdkFlutterPlugin::class.java)}")
                hmssdkFlutterPlugin = engine?.plugins?.get(HmssdkFlutterPlugin::class.java) as HmssdkFlutterPlugin
                hmssdkFlutterPlugin?.let {
                    it as HmssdkFlutterPlugin
                    Log.i("VKohli", "hmssdk flutter plugin ${it.hmssdk}")
                    hmssdk = it.hmssdk
                }
            }
            HMSVirtualBackgroundAction.virtualBackgroundActions(call, result, hmssdk)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
      hmssdk = null
      hmssdkFlutterPlugin = null
      engine = null
  }


}
