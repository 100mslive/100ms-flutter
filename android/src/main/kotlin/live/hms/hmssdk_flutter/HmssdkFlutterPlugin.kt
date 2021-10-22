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
import live.hms.hmssdk_flutter.views.HMSVideoViewFactory
import live.hms.video.error.HMSException
import live.hms.video.media.tracks.HMSRemoteAudioTrack
import live.hms.video.media.tracks.HMSTrack
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.sdk.models.enums.HMSPeerUpdate
import live.hms.video.sdk.models.enums.HMSRoomUpdate
import live.hms.video.sdk.models.enums.HMSTrackUpdate
import live.hms.video.sdk.models.role.HMSRole
import live.hms.video.sdk.models.trackchangerequest.HMSChangeTrackStateRequest
import live.hms.video.utils.HMSLogger
import java.lang.Exception


/** HmssdkFlutterPlugin */
class HmssdkFlutterPlugin : FlutterPlugin, MethodCallHandler, HMSUpdateListener, ActivityAware,
    EventChannel.StreamHandler, HMSPreviewListener, HMSAudioListener, HMSActionResultListener,
    HMSMessageResultListener, HMSLogger.Loggable {
    private lateinit var channel: MethodChannel
    private lateinit var meetingEventChannel: EventChannel
    private lateinit var previewChannel: EventChannel
    private lateinit var logsEventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var previewSink: EventChannel.EventSink? = null
    private var logsSink: EventChannel.EventSink? = null
    private lateinit var activity: Activity
    lateinit var hmssdk: HMSSDK
    private lateinit var hmsVideoFactory: HMSVideoViewFactory
    private var requestChange: HMSRoleChangeRequest? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hmssdk_flutter")
        this.meetingEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "meeting_event_channel")
        this.previewChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "preview_event_channel")

        this.logsEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "logs_event_channel")

        this.meetingEventChannel.setStreamHandler(this)
        this.channel.setMethodCallHandler(this)
        this.previewChannel.setStreamHandler(this)
        this.logsEventChannel.setStreamHandler(this)

        this.hmsVideoFactory = HMSVideoViewFactory(this)

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "HMSVideoView",
            hmsVideoFactory
        )

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "join_meeting" -> {
                joinMeeting(call)
                result.success("joining meeting in android")
            }
            "leave_meeting" -> {
                leaveMeeting(result)
            }
            "switch_audio" -> {
                switchAudio(call, result)
            }
            "switch_video" -> {
                switchVideo(call, result)
            }
            "switch_camera" -> {
                switchCamera()
                result.success("switch_camera")
            }
            "is_video_mute" -> {
                result.success(isVideoMute(call))
            }
            "is_audio_mute" -> {
                result.success(isAudioMute(call))
            }
            "stop_capturing" -> {
                stopCapturing()
                result.success("stop_capturing")
            }
            "start_capturing" -> {
                startCapturing()
                result.success("start_capturing")
            }
            "send_message" -> {
                sendBroadCastMessage(call)
                result.success("sent message")
            }
            "send_direct_message" -> {
                sendDirectMessage(call)
                result.success("sent message")
            }
            "send_group_message" -> {
                sendGroupMessage(call)
                result.success("sent message")
            }
            "preview_video" -> {
                previewVideo(call)
                result.success("preview video")
            }
            "change_role" -> {
                changeRole(call)
            }
            "get_roles" -> {
                getRoles(result)
            }
            "accept_role_change" -> {
                acceptRoleRequest()
                result.success("role_accepted")
            }
            "get_peers" -> {
                getPeers(result)
            }
            "on_change_track_state_request" -> {
                changeTrack(call)
            }

            "end_room" -> {
                endRoom(call, result)
            }
            "remove_peer" -> {
                removePeer(call)
            }

            "mute_all" -> {
                muteAll()
                result.success("muted_all")
            }
            "un_mute_all" -> {
                unMuteAll()
                result.success("un_muted_all")
            }

            "get_local_peer" -> {
                localPeer(result)
            }

            "start_hms_logger"->{
                startHMSLogger(call)
            }
            "remove_hms_logger"->{
                removeHMSLogger()
            }
            else -> {
                result.notImplemented()
            }
        }

    private fun getPeers(result: Result) {
        val peersList = hmssdk.getPeers()
        val peersMapList = ArrayList<HashMap<String, Any?>?>()
        peersList.forEach {
            peersMapList.add(HMSPeerExtension.toDictionary(it))
        }
        CoroutineScope(Dispatchers.Main).launch {
            result.success(peersMapList)
        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        meetingEventChannel.setStreamHandler(null)
        previewChannel.setStreamHandler(null)
        logsEventChannel.setStreamHandler(null)
    }

    override fun onChangeTrackStateRequest(details: HMSChangeTrackStateRequest) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_change_track_state_request")
        args.put("data", HMSChangeTrackStateRequestExtension.toDictionary(details)!!)
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }


    override fun onError(error: HMSException) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_error")
        args.put("data", HMSExceptionExtension.toDictionary(error))
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
                previewSink?.success(args)
            }
    }

    override fun onSuccess() {
        Log.i("onSuccess", "success")
    }

    override fun onSuccess(hmsMessage: HMSMessage) {
        Log.i("onSuccessMessage", hmsMessage.message)
    }


    override fun onPreview(room: HMSRoom, localTracks: Array<HMSTrack>) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "preview_video")
        args.put("data", HMSPreviewExtension.toDictionary(room, localTracks))
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                previewSink?.success(args)
            }

    }

    var hasJoined: Boolean = false

    override fun onJoin(room: HMSRoom) {
        this.hasJoined = true
        hmssdk.addAudioObserver(this)
        previewChannel.setStreamHandler(null)
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_join_room")
        val roomArgs = HashMap<String, Any?>()
        roomArgs.put("room", HMSRoomExtension.toDictionary(room))
        args.put("data", roomArgs)
        if (roomArgs["room"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onMessageReceived(message: HMSMessage) {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_message")
        args.put("data", HMSMessageExtension.toDictionary(message))
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_peer_update")
        args.put("data", HMSPeerUpdateExtension.toDictionary(peer, type))
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_update_room")
        args.put("data", hmsRoom.name)
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_track_update")
        args.put("data", HMSTrackUpdateExtension.toDictionary(peer, track, type))
        HMSLogger.i("onTrackUpdate", peer.toString())
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }


    }

    override fun onRemovedFromRoom(notification: HMSRemovedFromRoom) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_removed_from_room")
        args.put("data", HMSRemovedFromRoomExtension.toDictionary(notification))
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onReconnected() {

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_re_connected")
        CoroutineScope(Dispatchers.Main).launch {
            eventSink?.success(args)
        }
    }

    override fun onReconnecting(error: HMSException) {

        val args = HashMap<String, Any>()
        args.put("event_name", "on_re_connecting")
        CoroutineScope(Dispatchers.Main).launch {
            eventSink?.success(args)
        }
    }

    override fun onRoleChangeRequest(request: HMSRoleChangeRequest) {
        val args = HashMap<String, Any?>()
        args.put("event_name", "on_role_change_request")
        args.put("data", HMSRoleChangedExtension.toDictionary(request))
        this.requestChange = request
        if (args["data"] != null)
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        this.hmssdk = HMSSDK.Builder(this.activity).build()
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {

    }

    private fun joinMeeting(@NonNull call: MethodCall) {
        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val isProd = call.argument<Boolean>("is_prod")


        var hmsConfig = HMSConfig(userName = userName!!, authtoken = authToken!!)
        if (!isProd!!)
            hmsConfig = HMSConfig(
                userName = userName,
                authtoken = authToken,
                initEndpoint = "https://qa-init.100ms.live/init"
            )

        hmssdk.join(hmsConfig, this)

    }

    private fun startHMSLogger(call: MethodCall){
        val setWebRtcLogLevel = call.argument<String>("web_rtc_log_level")
        val setLogLevel = call.argument<String>("log_level")

        HMSLogger.webRtcLogLevel = when(setWebRtcLogLevel){
            "verbose"->HMSLogger.LogLevel.VERBOSE
            "info"->HMSLogger.LogLevel.INFO
            "warn"->HMSLogger.LogLevel.WARN
            "error"->HMSLogger.LogLevel.ERROR
            "debug"->HMSLogger.LogLevel.DEBUG
            else -> HMSLogger.LogLevel.OFF
        }
        HMSLogger.level = when(setLogLevel){
            "verbose"->HMSLogger.LogLevel.VERBOSE
            "info"->HMSLogger.LogLevel.INFO
            "warn"->HMSLogger.LogLevel.WARN
            "error"->HMSLogger.LogLevel.ERROR
            "debug"->HMSLogger.LogLevel.DEBUG
            else -> HMSLogger.LogLevel.OFF
        }

        Log.i("startHMSLogger","${HMSLogger.webRtcLogLevel}  ${HMSLogger.level}")
        HMSLogger.injectLoggable(this)
    }

    private fun leaveMeeting(result: Result) {
        if (!hasJoined)return
        try {
            hmssdk?.leave()
            hasJoined = false
            result.success("left meeting successfully")
        } catch (e: Exception) {
            result.success("error in leaving meeting check OnError Update")
        }


    }

    private fun switchAudio(call: MethodCall, result: Result) {
        val argsIsOn = call.argument<Boolean>("is_on")
        val peer = hmssdk.getLocalPeer()
        val audioTrack = peer?.audioTrack

        audioTrack?.setMute(argsIsOn!!)
        result.success("audio_changed")
    }

    private fun switchVideo(call: MethodCall, result: Result) {
        val argsIsOn = call.argument<Boolean>("is_on")
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        if (videoTrack != null) {
            videoTrack.setMute(argsIsOn ?: false)
            result.success("video_changed")
        }
    }

    private fun stopCapturing() {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        videoTrack?.setMute(true)
    }

    private fun startCapturing() {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        videoTrack?.setMute(false)

    }

    private fun switchCamera() {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        CoroutineScope(Dispatchers.Default).launch {
            videoTrack!!.switchCamera()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        val nameOfEventSink = (arguments as HashMap<String, Any>)["name"]
        if (nameOfEventSink!! == "meeting") {
            this.eventSink = events
        } else if (nameOfEventSink == "preview") {
            this.previewSink = events
        } else if (nameOfEventSink == "logs") {
            this.logsSink = events
        }
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    fun getPeerById(id: String): HMSPeer? {
        if (id == "") return getLocalPeer()
        val peers = hmssdk.getPeers()
        peers.forEach {
            if (it.peerID == id) return it
        }

        return null
    }

    private fun isVideoMute(call: MethodCall): Boolean {
        val peerId = call.argument<String>("peer_id")
//        val isLocal = call.argument<Boolean>("is_local")
        if (peerId == "null") {
            return hmssdk.getLocalPeer()?.videoTrack?.isMute?:false
        }
        val peer = getPeerById(peerId!!)
        return peer!!.videoTrack!!.isMute
    }

    private fun isAudioMute(call: MethodCall): Boolean {
        val peerId = call.argument<String>("peer_id")
//        val isLocal = call.argument<Boolean>("is_local")
        if (peerId == "null") {
            return hmssdk.getLocalPeer()?.audioTrack?.isMute!!
        }
        val peer = getPeerById(peerId!!)
        return peer!!.audioTrack!!.isMute
    }

    private fun sendBroadCastMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        hmssdk?.sendBroadcastMessage(message!!, "chat", this)
    }

    private fun sendDirectMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!)
        hmssdk?.sendDirectMessage(message!!, "chat", peer!!, this)

    }

    private fun sendGroupMessage(call: MethodCall) {
        val roleUWant = call.argument<String>("role_name")
        val message = call.argument<String>("message")
        val roles = hmssdk.getRoles()
        val roleToChangeTo: HMSRole = roles.first {
            it.name == roleUWant
        }
        val role = ArrayList<HMSRole>()
        role.add(roleToChangeTo)
        hmssdk?.sendGroupMessage(message!!, "chat", role, this)
    }

    private fun previewVideo(call: MethodCall) {
        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val isProd = call.argument<Boolean>("is_prod")
        val setWebRtcLog = call.argument<Boolean>("set_web_rtc_log")
        HMSLogger.i("previewVideo", "$userName $isProd")
        var hmsConfig = HMSConfig(userName = userName!!, authtoken = authToken!!)
        if (!isProd!!)
            hmsConfig = HMSConfig(
                userName = userName,
                authtoken = authToken,
                initEndpoint = "https://qa-init.100ms.live/init"
            )
        hmssdk.preview(hmsConfig, this)

//        HMSLogger.webRtcLogLevel = if(setWebRtcLog == false) HMSLogger.LogLevel.OFF else HMSLogger.LogLevel.INFO
//        HMSLogger.injectLoggable(this)
    }

    fun getLocalPeer(): HMSLocalPeer {
        return hmssdk.getLocalPeer()!!
    }

    private fun changeRole(call: MethodCall) {
        val roleUWant = call.argument<String>("role_name")
        val peerId = call.argument<String>("peer_id")
        val forceChange = call.argument<Boolean>("force_change")
        val roles = hmssdk.getRoles()
        val roleToChangeTo: HMSRole = roles.first {
            it.name == roleUWant
        }
        val peer = getPeerById(peerId!!) as HMSPeer
        hmssdk.changeRole(peer, roleToChangeTo, forceChange ?: false, this)
    }

    private fun getRoles(result: Result) {
        val args = HashMap<String, Any?>()

        val roles = ArrayList<Any>()
        hmssdk.getRoles().forEach {
            roles.add(HMSRoleExtension.toDictionary(it)!!)
        }
        args["roles"] = roles
        result.success(args)
    }

    private fun acceptRoleRequest() {
        if (this.requestChange != null) {
            hmssdk.acceptChangeRole(this.requestChange!!, this)
        }
    }

    override fun onAudioLevelUpdate(speakers: Array<HMSSpeaker>) {
        val speakersList = ArrayList<HashMap<String, Any?>>()

        HMSLogger.i(
            "onAudioLevelUpdateHMSLogger",
            HMSLogger.level.toString()
        )
        if (speakers.isNotEmpty()) {
            speakers.forEach {
                speakersList.add(HMSSpeakerExtension.toDictionary(it)!!)

            }
            val speakersMap = HashMap<String, Any>()
            speakersMap.put("speakers", speakersList)

            val hashMap = HashMap<String, Any?>()
            hashMap.put("event_name", "on_update_speaker")
            hashMap.put("data", speakersMap)
            HMSLogger.i(
                "onAudioLevelUpdateAndroid2",
                (hashMap.get("data") as HashMap<String, Any>).get("speakers").toString()
            )
            CoroutineScope(Dispatchers.Main).launch {
                eventSink!!.success(hashMap)
            }
        }
    }

    private fun changeTrack(call: MethodCall) {
        val hmsPeerId = call.argument<String>("hms_peer_id")
        val mute = call.argument<Boolean>("mute")
        val muteVideoKind = call.argument<Boolean>("mute_video_kind")
        val peer = getPeerById(hmsPeerId!!)
        val track: HMSTrack =
            if (muteVideoKind == true) peer!!.videoTrack!! else peer!!.audioTrack!!
        hmssdk.changeTrackState(track, mute!!, this)
    }

    private fun removePeer(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!) as HMSRemotePeer

        hmssdk.removePeerRequest(peer = peer, hmsActionResultListener = this, reason = "noise")
    }

    private fun removeHMSLogger(){
        HMSLogger.removeInjectedLoggable()
    }

    private fun endRoom(call: MethodCall, result: Result) {
        if (isAllowedToEndMeeting() && hasJoined) {
            val lock = call.argument<Boolean>("lock")
            hmssdk.endRoom(lock = lock!!, reason = "noise", hmsActionResultListener = this)

            hasJoined = false
            result.success(true)
        } else
            result.success(false)
    }

    private fun isAllowedToEndMeeting(): Boolean {
        return hmssdk.getLocalPeer()!!.hmsRole.permission?.endRoom
    }

    fun isAllowedToMuteOthers(): Boolean {
        return hmssdk.getLocalPeer()!!.hmsRole.permission?.mute
    }

    fun isAllowedToUnMuteOthers(): Boolean {
        return hmssdk.getLocalPeer()!!.hmsRole.permission?.unmute
    }

    private fun localPeer(result: Result) {
        result.success(HMSPeerExtension.toDictionary(getLocalPeer()))
    }

    private fun muteAll() {
        val peersList = hmssdk.getRemotePeers()
        if (isAllowedToMuteOthers())
            peersList.forEach {
                it.audioTrack?.isPlaybackAllowed = false
                it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = false
                    }
                }
            }
    }

    private fun unMuteAll() {
        val peersList = hmssdk.getRemotePeers()
        if (isAllowedToUnMuteOthers())
            peersList.forEach {
                it.audioTrack?.isPlaybackAllowed = true
                it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteAudioTrack) {
                        it.isPlaybackAllowed = true
                    }
                }
            }
    }

    private fun startRtmpOrRecording(call: MethodCall, result: Result) {
        val meetingUrl = call.argument<String>("meeting_url")
        val toRecord = call.argument<Boolean>("to_record")
        val listOfRtmpUrls = call.argument<List<String>>("rtmp_urls")
        hmssdk.startRtmpOrRecording(
            HMSRecordingConfig(meetingUrl!!, listOfRtmpUrls!!, toRecord!!),
            object : HMSActionResultListener {

                override fun onSuccess() {
                    result.success("started successfully")
                }

                override fun onError(error: HMSException) {
                    result.success("on error: ${error.description}")
                }
            })
    }

    private fun stopRtmpOrRecording(result: Result) {
        hmssdk.stopRtmpAndRecording(object : HMSActionResultListener {

            override fun onSuccess() {
                result.success("started successfully")
            }

            override fun onError(error: HMSException) {
                result.success("on error: ${error.description}")
            }
        })
    }

    override fun onLogMessage(
        level: HMSLogger.LogLevel,
        tag: String,
        message: String,
        isWebRtCLog: Boolean
    ) {
        //print("${level.name} ${tag} ${message} ${isWebRtCLog} HMSLOGGERTHATILISTENED")
        if ( isWebRtCLog && level != HMSLogger.webRtcLogLevel )return
        if(level != HMSLogger.level )return

        val args = HashMap<String, Any?>()
        args.put("event_name", "on_logs_update")
        val logArgs = HashMap<String, Any?>()

        logArgs["log"] = HMSLogsExtension.toDictionary(level, tag, message, isWebRtCLog)
        args["data"] = logArgs
        CoroutineScope(Dispatchers.Main).launch {
            logsSink?.success(args)
        }

    }
}