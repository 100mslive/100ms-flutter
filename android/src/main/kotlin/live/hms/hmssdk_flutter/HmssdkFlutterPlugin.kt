package live.hms.hmssdk_flutter

import android.app.Activity
import android.os.Build
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
import live.hms.hmssdk_flutter.hms_role_components.AudioParamsExtension
import live.hms.hmssdk_flutter.hms_role_components.VideoParamsExtension
import live.hms.hmssdk_flutter.views.HMSVideoViewFactory
import live.hms.video.error.HMSException
import live.hms.video.media.codec.HMSAudioCodec
import live.hms.video.media.codec.HMSVideoCodec
import live.hms.video.media.settings.HMSAudioTrackSettings
import live.hms.video.media.settings.HMSTrackSettings
import live.hms.video.media.settings.HMSVideoTrackSettings
import live.hms.video.media.tracks.*
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
class HmssdkFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    EventChannel.StreamHandler {
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
    private var hmsConfig: HMSConfig? = null
    private var result: Result? = null

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

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "join" -> {
                join(call, result)
            }
            "leave" -> {
                leave()
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
                stopCapturing(result)
            }
            "start_capturing" -> {
                startCapturing()
                result.success("start_capturing")
            }
            "send_broadcast_message" -> {
                sendBroadCastMessage(call)
            }
            "send_direct_message" -> {
                sendDirectMessage(call)
            }
            "send_group_message" -> {
                sendGroupMessage(call)
            }
            "preview" -> {
                preview(call, result)
            }
            "change_role" -> {
                changeRole(call)
            }
            "get_roles" -> {
                getRoles(result)
            }
            "accept_change_role" -> {
                acceptChangeRole()
            }
            "get_remote_peers" -> {
                getRemotePeers(result)
            }
            "get_peers" -> {
                getPeers(result)
            }
            "on_change_track_state_request" -> {
                changeTrackState(call)
            }

            "end_room" -> {
                endRoom(call, result)
            }
            "remove_peer" -> {
                removePeer(call)
            }

            "mute_all" -> {
                muteAll(result)
            }
            "un_mute_all" -> {
                unMuteAll(result)
            }

            "get_local_peer" -> {
                localPeer(result)
            }

            "start_hms_logger" -> {
                startHMSLogger(call)
            }
            "remove_hms_logger" -> {
                removeHMSLogger()
            }
            "change_track_state_for_role" -> {
                changeTrackStateForRole(call)
            }
            "start_rtmp_or_recording" -> {
                startRtmpOrRecording(call)
            }
            "stop_rtmp_and_recording" -> {
                stopRtmpAndRecording()
            }
            "build" -> {
                build(this.activity, call, result)
            }
            "get_room" -> {
                getRoom(result)
            }
            "update_hms_video_track_settings" -> {
                updateHMSLocalTrackSetting(call)
            }
            "change_metadata"->{
                changeMetadata(call)
            }
            "set_playback_allowed"->{
                setPlayBackAllowed(call)
            }
            "set_volume"->{
                setVolume(call, result)
            }
            "change_name"->{
                changeName(call)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

// TODO: check behaviour when room is not joined
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

    private fun getRemotePeers(result: Result) {
        val peersList = hmssdk.getRemotePeers()
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

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity

    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {

    }

    private fun join(call: MethodCall, result: Result) {
        this.hmsConfig = getConfig(call)
    
        hmssdk.join(hmsConfig!!, this.hmsUpdateListener)
        result.success(null)
    }

    private fun getConfig(call: MethodCall): HMSConfig {

        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val metaData = call.argument<String>("meta_data")?: ""
        val endPoint = call.argument<String>("end_point")        

        if (endPoint != null && endPoint!!.isNotEmpty()) {
            return HMSConfig(
                userName = userName!!,
                authtoken = authToken!!,
                metadata = metaData,
                initEndpoint = endPoint.trim()
            )
        }
            
        return HMSConfig(userName = userName!!, authtoken = authToken!!, metadata = metaData)
    }

    private fun startHMSLogger(call: MethodCall) {
        val setWebRtcLogLevel = call.argument<String>("web_rtc_log_level")
        val setLogLevel = call.argument<String>("log_level")

        HMSLogger.webRtcLogLevel = when (setWebRtcLogLevel) {
            "verbose" -> HMSLogger.LogLevel.VERBOSE
            "info" -> HMSLogger.LogLevel.INFO
            "warn" -> HMSLogger.LogLevel.WARN
            "error" -> HMSLogger.LogLevel.ERROR
            "debug" -> HMSLogger.LogLevel.DEBUG
            else -> HMSLogger.LogLevel.OFF
        }
        HMSLogger.level = when (setLogLevel) {
            "verbose" -> HMSLogger.LogLevel.VERBOSE
            "info" -> HMSLogger.LogLevel.INFO
            "warn" -> HMSLogger.LogLevel.WARN
            "error" -> HMSLogger.LogLevel.ERROR
            "debug" -> HMSLogger.LogLevel.DEBUG
            else -> HMSLogger.LogLevel.OFF
        }

        HMSLogger.injectLoggable(hmsLoggerListener)
    }

    
    private fun leave() {
        hmssdk.leave(hmsActionResultListener = this.actionListener)
        this.hmsConfig = null
    }

    private fun switchAudio(call: MethodCall, result: Result) {
        val argsIsOn = call.argument<Boolean>("is_on")
        val peer = hmssdk.getLocalPeer()
        val audioTrack = peer?.audioTrack
        if (audioTrack != null) {
            audioTrack?.setMute(argsIsOn!!)
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun switchVideo(call: MethodCall, result: Result) {
        val argsIsOn = call.argument<Boolean>("is_on")
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        if (videoTrack != null) {
            videoTrack.setMute(argsIsOn ?: false)
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun stopCapturing(result: Result) {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        if (videoTrack != null) {
            videoTrack.setMute(true)
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun startCapturing() {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        if (videoTrack != null) {
            videoTrack.setMute(false)
            result?.success(true)
        } else {
            result?.success(false)
        }
    }

    private fun switchCamera() {
        val peer = hmssdk.getLocalPeer()
        val videoTrack = peer?.videoTrack
        CoroutineScope(Dispatchers.Default).launch {
            videoTrack?.switchCamera()
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
        if (peerId == "null") {
            return hmssdk.getLocalPeer()?.videoTrack?.isMute ?: true
        }
        val peer = getPeerById(peerId!!)
        return peer!!.videoTrack!!.isMute
    }

    private fun isAudioMute(call: MethodCall): Boolean {
        val peerId = call.argument<String>("peer_id")

        if (peerId == "null") {
            return hmssdk.getLocalPeer()?.audioTrack?.isMute?:true
        }
        val peer = getPeerById(peerId!!)
        return peer!!.audioTrack!!.isMute
    }

    private fun sendBroadCastMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        val type = call.argument<String>("type") ?: "chat"
        hmssdk?.sendBroadcastMessage(message!!, type, hmsMessageResultListener)
    }

    private fun sendDirectMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        val peerId = call.argument<String>("peer_id")

        val type = call.argument<String>("type") ?: "chat"
        val peer = getPeerById(peerId!!)
        hmssdk?.sendDirectMessage(message!!, type, peer!!, hmsMessageResultListener)

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

        val type = call.argument<String>("type") ?: "chat"

        hmssdk?.sendGroupMessage(message!!, type, role, this.hmsMessageResultListener)
    }

    private fun preview(call: MethodCall, result: Result) {
        this.hmsConfig = getConfig(call)
      
        hmssdk.preview(this.hmsConfig!!, this.hmsPreviewListener)

        result.success(null)
    }

    fun getLocalPeer(): HMSLocalPeer? {
        return hmssdk.getLocalPeer()
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
        hmssdk.changeRole(
            peer,
            roleToChangeTo,
            forceChange ?: false,
            hmsActionResultListener = this.actionListener
        )
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

    private fun acceptChangeRole() {
        hmssdk.acceptChangeRole(
            this.requestChange!!,
            hmsActionResultListener = acceptChangeRoleListener
        )
    }

    private val acceptChangeRoleListener = object : HMSActionResultListener {
            override fun onError(error: HMSException) {
                CoroutineScope(Dispatchers.Main).launch {
                    result?.success(HMSExceptionExtension.toDictionary(error))
                }
            }

            override fun onSuccess() {
//                this.requestChange = null
                CoroutineScope(Dispatchers.Main).launch {
                    result?.success(null)
                }
            }
        }

    

    var hmsAudioListener = object : HMSAudioListener {
        override fun onAudioLevelUpdate(speakers: Array<HMSSpeaker>) {
            val speakersList = ArrayList<HashMap<String, Any?>>()

            HMSLogger.i(
                "onAudioLevelUpdateHMSLogger",
                HMSLogger.level.toString()
            )

            if(speakers.isNotEmpty()) {
                speakers.forEach {
                    speakersList.add(HMSSpeakerExtension.toDictionary(it)!!)
                }
            }
            val speakersMap = HashMap<String, Any>()
            speakersMap["speakers"] = speakersList

            val hashMap : HashMap<String,Any?> = HashMap()
            hashMap["event_name"] = "on_update_speaker"
            hashMap["data"] = speakersMap

            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(hashMap)
            }
        }
    }


    private fun changeTrackState(call: MethodCall) {
        val hmsPeerId = call.argument<String>("hms_peer_id")
        val mute = call.argument<Boolean>("mute")
        val muteVideoKind = call.argument<Boolean>("mute_video_kind")
        val peer = getPeerById(hmsPeerId!!)
        val track: HMSTrack =
            if (muteVideoKind == true) peer!!.videoTrack!! else peer!!.audioTrack!!
        hmssdk.changeTrackState(track, mute!!, hmsActionResultListener = this.actionListener)
    }

    
    private fun removePeer(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!) as HMSRemotePeer

        val reason = call.argument<String>("reason") ?: "Removed from room"

        hmssdk.removePeerRequest(
            peer = peer,
            hmsActionResultListener = this.actionListener,
            reason = reason
        )
    }

    private fun removeHMSLogger() {
        HMSLogger.removeInjectedLoggable()
    }

    private fun endRoom(call: MethodCall, result: Result) {
        val lock = call.argument<Boolean>("lock") ?: false
        val reason = call.argument<String>("reason") ?: "End room invoked"
        hmssdk.endRoom(
            lock = lock!!,
            reason = reason,
            hmsActionResultListener = this.actionListener
        )
    }

    private fun isAllowedToEndMeeting(): Boolean {
        return hmssdk.getLocalPeer()!!.hmsRole.permission?.endRoom
    }

    private fun localPeer(result: Result) {
        result.success(HMSPeerExtension.toDictionary(getLocalPeer()))
    }

    private fun muteAll(result: Result) {
        val peersList = hmssdk.getRemotePeers()
        
        peersList.forEach {
            it.audioTrack?.isPlaybackAllowed = false
            it.auxiliaryTracks.forEach {
                if (it is HMSRemoteAudioTrack) {
                    it.isPlaybackAllowed = false
                }
            }
        }
//        result(null)
    }

    private fun unMuteAll(result: Result) {
        val peersList = hmssdk.getRemotePeers()
        
        peersList.forEach {
            it.audioTrack?.isPlaybackAllowed = true
            it.auxiliaryTracks.forEach {
                if (it is HMSRemoteAudioTrack) {
                    it.isPlaybackAllowed = true
                }
            }
        }
//        result(null)
    }

    private fun startRtmpOrRecording(call: MethodCall) {
        val meetingUrl = call.argument<String>("meeting_url")
        val toRecord = call.argument<Boolean>("to_record")
        val listOfRtmpUrls: List<String> = call.argument<List<String>>("rtmp_urls") ?: listOf()
        hmssdk.startRtmpOrRecording(
            HMSRecordingConfig(meetingUrl!!, listOfRtmpUrls, toRecord!!),
            hmsActionResultListener = this.actionListener
        )
    }

    private fun stopRtmpAndRecording() {
        hmssdk.stopRtmpAndRecording(hmsActionResultListener = this.actionListener)
    }


    private fun changeTrackStateForRole(call: MethodCall) {
        val mute = call.argument<Boolean>("mute")
        val type = call.argument<String>("type")
        val source = call.argument<String>("source")
        val roles: List<String>? = call.argument<List<String>>("roles")

        val realRoles = hmssdk.getRoles().filter { roles?.contains(it.name)!! }

        hmssdk.changeTrackState(
            mute = mute!!,
            type = HMSTrackExtension.getStringFromKind(type),
            source = source,
            roles = realRoles,
            hmsActionResultListener = this.actionListener
        )
    }

    fun build(activity: Activity, call: MethodCall, result: Result) {
        val hmsTrackSettingMap =
            call.argument<HashMap<String, HashMap<String, Any?>?>?>("hms_track_setting")

        if (hmsTrackSettingMap == null) {
            this.hmssdk = HMSSDK.Builder(activity).build()
            result.success(true)
            return
        }

        val hmsAudioTrackHashMap: HashMap<String, Any?>? = hmsTrackSettingMap["audio_track_setting"]
        var hmsAudioTrackSettings = HMSAudioTrackSettings.Builder()
        if (hmsAudioTrackHashMap != null) {
            val maxBitRate = hmsAudioTrackHashMap["bit_rate"] as Int?
            val volume = hmsAudioTrackHashMap["volume"] as Double?
            val useHardwareAcousticEchoCanceler =
                hmsAudioTrackHashMap["user_hardware_acoustic_echo_canceler"] as Boolean?
            val audioCodec =
                AudioParamsExtension.getValueOfHMSAudioCodecFromString(hmsAudioTrackHashMap["audio_codec"] as String?) as HMSAudioCodec?

            if (maxBitRate != null) {
                hmsAudioTrackSettings = hmsAudioTrackSettings.maxBitrate(maxBitRate)
            }

            if (volume != null) {
                hmsAudioTrackSettings = hmsAudioTrackSettings.volume(volume)
            }

            if (useHardwareAcousticEchoCanceler != null) {
                hmsAudioTrackSettings = hmsAudioTrackSettings.setUseHardwareAcousticEchoCanceler(
                    useHardwareAcousticEchoCanceler
                )
            }

            if (audioCodec != null) {
                hmsAudioTrackSettings = hmsAudioTrackSettings.codec(audioCodec)
            }
        }


        var hmsVideoTrackSettings = HMSVideoTrackSettings.Builder()
        val hmsVideoTrackHashMap: HashMap<String, Any?>? = hmsTrackSettingMap["video_track_setting"]
        if (hmsVideoTrackHashMap != null) {
            val maxBitRate = hmsVideoTrackHashMap["max_bit_rate"] as Int?
            val maxFrameRate = hmsVideoTrackHashMap["max_frame_rate"] as Int?
            val videoCodec =
                VideoParamsExtension.getValueOfHMSAudioCodecFromString(hmsVideoTrackHashMap["video_codec"] as String?) as HMSVideoCodec?


            if (maxBitRate != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.maxBitrate(maxBitRate)
            }

            if (maxFrameRate != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.maxFrameRate(maxFrameRate)
            }
            if (videoCodec != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.codec(videoCodec)
            }
        }

        val hmsTrackSettings = HMSTrackSettings.Builder().audio(hmsAudioTrackSettings.build())
            .video(hmsVideoTrackSettings.build()).build()
        hmssdk = HMSSDK
            .Builder(activity)
            .setTrackSettings(hmsTrackSettings)
            .build()
        result.success(true)
    }

    private fun getRoom(result: Result) {
        result.success(HMSRoomExtension.toDictionary(hmssdk?.getRoom()))
    }

    private fun updateHMSLocalTrackSetting(call: MethodCall) {
        val localPeerVideoTrack = getLocalPeer()!!.videoTrack
        var hmsVideoTrackSettings = localPeerVideoTrack!!.settings.builder()
        val hmsVideoTrackHashMap: HashMap<String, Any?>? = call.argument("video_track_setting")
        if (hmsVideoTrackHashMap != null) {
            val maxBitRate = hmsVideoTrackHashMap["max_bit_rate"] as Int?
            val maxFrameRate = hmsVideoTrackHashMap["max_frame_rate"] as Int?
            val videoCodec =
                VideoParamsExtension.getValueOfHMSAudioCodecFromString(hmsVideoTrackHashMap["video_codec"] as String?) as HMSVideoCodec?


            if (maxBitRate != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.maxBitrate(maxBitRate)
            }

            if (maxFrameRate != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.maxFrameRate(maxFrameRate)
            }
            if (videoCodec != null) {
                hmsVideoTrackSettings = hmsVideoTrackSettings.codec(videoCodec)
            }
        }

        CoroutineScope(Dispatchers.Default).launch {
            localPeerVideoTrack.setSettings(hmsVideoTrackSettings.build())
        }
    }

    private var hasChangedMetadata:Boolean = false

    private fun changeMetadata(call:MethodCall){
        hasChangedMetadata = !hasChangedMetadata
        val metadata = call.argument<String>("metadata")

        hmssdk.changeMetadata(metadata!!, hmsActionResultListener = this.actionListener)
    }


    private val hmsUpdateListener = object : HMSUpdateListener {
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
                }
        }

        override fun onJoin(room: HMSRoom) {
//            hasJoined = true
            hmssdk.addAudioObserver(hmsAudioListener)
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
            args["event_name"] = "on_peer_update"

            args["data"] = HMSPeerUpdateExtension.toDictionary(peer, type)
            
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        
        override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_room_update")
            args.put("data", HMSRoomUpdateExtension.toDictionary(hmsRoom, type))
            
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_track_update")

            args.put("data", HMSTrackUpdateExtension.toDictionary(peer, track, type))
            
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
            requestChange = request
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }
    }

    private val actionListener = object : HMSActionResultListener {
        override fun onError(error: HMSException) {
            CoroutineScope(Dispatchers.Main).launch {
                result?.success(HMSExceptionExtension.toDictionary(error))
            }
        }

        override fun onSuccess() {
            CoroutineScope(Dispatchers.Main).launch {
                result?.success(null)
            }
        }
    }
    private val hmsPreviewListener = object : HMSPreviewListener {
        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(error))

            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
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

    }
    private val hmsMessageResultListener = object : HMSMessageResultListener {
        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_error"
            args["data"] = HMSExceptionExtension.toDictionary(error)
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    result?.success(args)
                }
        }

        override fun onSuccess(hmsMessage: HMSMessage) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_success"
            args["message"] = HMSMessageExtension.toDictionary(hmsMessage)
            if (args["message"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    result?.success(args)
                }
        }
    }

    var finalargs = mutableListOf<Any?>()
    private val hmsLoggerListener = object : HMSLogger.Loggable {
        override fun onLogMessage(
            level: HMSLogger.LogLevel,
            tag: String,
            message: String,
            isWebRtCLog: Boolean
        ) {
            if (isWebRtCLog && level != HMSLogger.webRtcLogLevel) return
            if (level != HMSLogger.level) return

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_logs_update"
            val logArgs = HashMap<String, Any?>()

            logArgs["log"] = HMSLogsExtension.toDictionary(level, tag, message, isWebRtCLog)
            args["data"] = logArgs

            if(finalargs.size < 1000){
                finalargs.add(args)
            }
            else{
                var copyfinalargs = mutableListOf<Any?> ();
                copyfinalargs.addAll(finalargs);
                CoroutineScope(Dispatchers.Main).launch {
                    logsSink?.success(copyfinalargs);
                }
                finalargs.clear()
            }
            
        }

    }

    private fun setPlayBackAllowed(call: MethodCall) {
        val allowed = call.argument<Boolean>("allowed")
        hmssdk.getRemotePeers().forEach {
            it.videoTrack?.isPlaybackAllowed = allowed!!

            it.auxiliaryTracks.forEach {
                    if (it is HMSRemoteVideoTrack) {
                        it.isPlaybackAllowed = allowed!!
                    }
                }
        }
        getLocalPeer()!!.videoTrack?.setMute(!(allowed!!))
        result?.success(null)
    }

    private fun setVolume(call: MethodCall, result: Result){
        val trackId = call.argument<String>("track_id")
        val volume = call.argument<Double>("volume")
       
        hmssdk.getPeers().forEach { it ->
            if(it.audioTrack?.trackId == trackId){
                if(it.audioTrack is HMSRemoteAudioTrack){
                    (it.audioTrack as HMSRemoteAudioTrack).setVolume(volume!!)
                    result.success(null)
                    return
                }
                else if(it.audioTrack is HMSLocalAudioTrack){
                    (it.audioTrack as HMSLocalAudioTrack).volume = volume!!
                    result.success(null)
                    return
                }
            }
            
            it.auxiliaryTracks.forEach {
                if(it.trackId == trackId && it is HMSRemoteAudioTrack){
                    it.setVolume(volume!!.toDouble())
                    result.success(null)
                    return
                }
            }
        }

        var map = HashMap<String,Map<String,String>>()
        var error = HashMap<String, String>()
        error["message"] = "Could not set volume"
        error["action"] = "NONE"
        error["description"] = "Track not found for setting volume"
        map["error"] = error
        result.success(map)
    }

    private fun changeName(call:MethodCall){
        val name = call.argument<String>("name");
        hmssdk.changeName(name=name!!, hmsActionResultListener = this.actionListener);
    }
}
