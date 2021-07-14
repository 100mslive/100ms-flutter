package live.hms.hmssdk_flutter

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import live.hms.video.error.HMSException
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.HMSSDK
import live.hms.video.sdk.HMSUpdateListener
import live.hms.video.sdk.models.HMSConfig
import live.hms.video.sdk.models.HMSMessage
import live.hms.video.sdk.models.HMSPeer
import live.hms.video.sdk.models.HMSRoom
import live.hms.video.sdk.models.enums.HMSPeerUpdate
import live.hms.video.sdk.models.enums.HMSRoomUpdate
import live.hms.video.sdk.models.enums.HMSTrackUpdate

/** HmssdkFlutterPlugin */
class HmssdkFlutterPlugin: FlutterPlugin, MethodCallHandler, HMSUpdateListener,ActivityAware,EventChannel.StreamHandler {
  private lateinit var channel : MethodChannel
  private lateinit var meetingEventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private lateinit var activity: Activity
  private lateinit var hmssdk: HMSSDK

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hmssdk_flutter")
    this.meetingEventChannel= EventChannel(flutterPluginBinding.binaryMessenger,"meeting_event_channel")
    this.meetingEventChannel.setStreamHandler(this)
    this.channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when(call.method){
      "getPlatformVersion"->{
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "join_meeting"->{
        joinMeeting(call)
        result.success("joining meeting in android")
      }
      "leave_meeting"->{
        leaveMeeting()
        result.success("Leaving meeting")
      }
      "switch_audio"->{
        switchAudio(call,result)
      }
      "switch_video"->{
        switchVideo(call,result)
      }
      else->{
        result.notImplemented()
      }
    }

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    meetingEventChannel.setStreamHandler(null)
  }



  override fun onError(error: HMSException) {

    val args=HashMap<String,Any>()
    args.put("event_name","on_error")
    val args1=HashMap<String,Any>()
    args1.put("name","arun")
    args.put("data",args1)
    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onJoin(room: HMSRoom) {
    Log.i("OnJoin",room.toString()+"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHAAA")
    val args=HashMap<String,Any>()
    args.put("event_name","on_join_room")
    val args1=HashMap<String,Any>()
    args1.put("name",room.name)
    args.put("data",args1)
    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }

  }

  override fun onMessageReceived(message: HMSMessage) {

    val args=HashMap<String,Any>()
    args.put("event_name","on_message")
    val args1=HashMap<String,Any>()
    args1.put("name","arun")
    args.put("data",args1)

    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {

    val args=HashMap<String,Any>()
    args.put("event_name","on_peer_update")
    args.put("data",HMSPeerExtension.toDictionary(peer,type))

    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
    val args=HashMap<String,Any>()
    args.put("event_name","on_update_room")
    args.put("data",hmsRoom.name)

    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {

    val args=HashMap<String,Any>()
    args.put("event_name","on_track_update")

    val args1=HashMap<String,Any>()
    args1.put("name",peer.name)
    args.put("data",args1)

    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onReconnected() {
    super.onReconnected()
    val args=HashMap<String,Any>()
    args.put("event_name","on_re_connected")
    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onReconnecting(error: HMSException) {
    super.onReconnecting(error)

    val args=HashMap<String,Any>()
    args.put("event_name","on_re_connecting")
    CoroutineScope(Dispatchers.Main).launch {
      eventSink!!.success(args)
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity=binding.activity
    this.hmssdk=HMSSDK.Builder(this.activity).build()
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity=binding.activity
  }

  override fun onDetachedFromActivity() {

  }

  fun joinMeeting(@NonNull call: MethodCall){
    val userName=call.argument<String>("user_name")
    val authToken= call.argument<String>("auth_token")
    val shouldSkipPiiEvents=call.argument<Boolean>("should_skip_pii_events")
    Log.i("userName",authToken!!)
    val hmsConfig= HMSConfig(userName = userName!!,authtoken = authToken!!)
    hmssdk.join(hmsConfig,this)
    meetingEventChannel.setStreamHandler(this)

  }

  fun leaveMeeting(){
    if (hmssdk!=null)
      hmssdk.leave()
    else
      Log.e("error","not initialized")
  }

  fun switchAudio(call: MethodCall,result: Result){
    val argsIsOn=call.argument<Boolean>("is_on")
    val peer=hmssdk.getLocalPeer()
    val audioTrack=peer.audioTrack
    audioTrack!!.setMute(argsIsOn!!)
    result.success("audio_changed")
  }

  fun switchVideo(call: MethodCall,result: Result){
    val argsIsOn=call.argument<Boolean>("is_on")
    val peer=hmssdk.getLocalPeer()
    val videoTrack=peer.videoTrack
    videoTrack!!.setMute(argsIsOn!!)
    result.success("video_changed")
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    this.eventSink=events
  }

  override fun onCancel(arguments: Any?) {
    this.eventSink=null
  }
}