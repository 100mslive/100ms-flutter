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
            "join_meeting" -> {
                joinMeeting(call)
                result.success("joining meeting in android")
            }
            "leave_meeting" -> {
                leaveMeeting()
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
            }
            "send_direct_message" -> {
                sendDirectMessage(call)
            }
            "send_group_message" -> {
                sendGroupMessage(call)
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

            "start_hms_logger" -> {
                startHMSLogger(call)
            }
            "remove_hms_logger" -> {
                removeHMSLogger()
            }
            "change_track_state_for_role" -> {
                changeTrackStateForRole(call, result)
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
            "raise_hand" -> {
                raiseHand()
            }
            "set_playback_allowed" -> {
                setPlayBackAllowed(call)
            }
            "hls_start_streaming" -> {
                hlsStreaming(call)
            }
            "hls_stop_streaming" -> {
                stopHLSStreaming()
            }
            "is_video_playback_allowed"->{
                isVideoPlayBackAllowed(call)
            }
            "is_audio_playback_allowed"->{
                isAudioPlayBackAllowed(call)
            }
            "set_video_playback_allowed"->{
                setVideoPlayBackAllowed(call)
            }
            "set_audio_playback_allowed"->{
                setAudioPlayBackAllowed(call)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    //        Log.i("onMethodCall", "reached")

    var hasJoined: Boolean = false


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

    private fun joinMeeting(@NonNull call: MethodCall) {
        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val endPoint = call.argument<String>("end_point")
        if (this.hmsConfig == null) {
            this.hmsConfig = HMSConfig(userName = userName!!, authtoken = authToken!!)
            if (endPoint!!.isNotEmpty())
                this.hmsConfig = HMSConfig(
                    userName = userName,
                    authtoken = authToken,
                    initEndpoint = endPoint.trim()
                )
        }
        hmssdk.join(hmsConfig!!, this.hmsUpdateListener)
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

//        Log.i("startHMSLogger", "${HMSLogger.webRtcLogLevel}  ${HMSLogger.level}")
        HMSLogger.injectLoggable(hmsLoggerListener)
    }

    private fun leaveMeeting() {
        if (!hasJoined) return
        try {
            hmssdk.leave(hmsActionResultListener = this.actionListener)
            hasJoined = false
            //result.success(true)
        } catch (e: Exception) {
            //result.success(false)
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
//        Log.i("SwitchVideo",argsIsOn!!.toString())
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
            videoTrack?.switchCamera()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

        val nameOfEventSink = (arguments as HashMap<String, Any>)["name"]
//        Log.i("onListen EventChannel", nameOfEventSink.toString())
        if (nameOfEventSink!! == "meeting") {
            this.eventSink = events
//            Log.i("onListen EventChannel", "eventSink")
        } else if (nameOfEventSink == "preview") {
            this.previewSink = events
//            Log.i("onListen EventChannel", "previewSink")
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
//            Log.i("isVideoMute", (hmssdk.getLocalPeer()?.videoTrack?.isMute ?: false).toString())
            return hmssdk.getLocalPeer()?.videoTrack?.isMute ?: true
        }
        val peer = getPeerById(peerId!!)
//        Log.i("isVideoMute", (peer!!.videoTrack!!.isMute).toString())
        return peer!!.videoTrack!!.isMute
    }

    private fun isAudioMute(call: MethodCall): Boolean {
        val peerId = call.argument<String>("peer_id")
//        val isLocal = call.argument<Boolean>("is_local")
        if (peerId == "null") {
//            Log.i("isAudioMute", (hmssdk.getLocalPeer()?.audioTrack?.isMute!!).toString())
            return hmssdk.getLocalPeer()?.audioTrack?.isMute ?: true
        }
        val peer = getPeerById(peerId!!)
//        Log.i("isAudioMute", (peer!!.audioTrack!!.isMute).toString())
        return peer!!.audioTrack!!.isMute
    }

    private fun sendBroadCastMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        hmssdk?.sendBroadcastMessage(message!!, "chat", hmsMessageResultListener)
    }

    private fun sendDirectMessage(call: MethodCall) {
        val message = call.argument<String>("message")
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!)
        hmssdk?.sendDirectMessage(message!!, "chat", peer!!, hmsMessageResultListener)

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
        hmssdk?.sendGroupMessage(message!!, "chat", role, this.hmsMessageResultListener)
    }

    private fun previewVideo(call: MethodCall) {
        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val isProd = call.argument<Boolean>("is_prod")
        val endPoint = call.argument<String>("end_point")
        Log.i("PreviewVideoAndroid", "EndPoint ${endPoint}  ${isProd}")
        HMSLogger.i("previewVideo", "$userName $isProd")
        this.hmsConfig = HMSConfig(userName = userName!!, authtoken = authToken!!)
        if (endPoint!!.isNotEmpty())
            this.hmsConfig = HMSConfig(
                userName = userName,
                authtoken = authToken,
                initEndpoint = endPoint
            )
        hmssdk.preview(this.hmsConfig!!, this.hmsPreviewListener)

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

    private fun acceptRoleRequest() {
        if (this.requestChange != null) {
            hmssdk.acceptChangeRole(
                this.requestChange!!,
                hmsActionResultListener = this.actionListener
            )
//            Log.i("acceptRoleRequest","accept")
        }
    }

    var hmsAudioListener = object : HMSAudioListener {
        override fun onAudioLevelUpdate(speakers: Array<HMSSpeaker>) {
            val speakersList = ArrayList<HashMap<String, Any?>>()
            Log.i("onAudioLevelUpdateAndroid1", speakers.size.toString())

            HMSLogger.i(
                "onAudioLevelUpdateHMSLogger",
                HMSLogger.level.toString()
            )

            if (speakers.isNotEmpty()) {
                speakers.forEach {
                    speakersList.add(HMSSpeakerExtension.toDictionary(it)!!)

                }
            }
            val speakersMap = HashMap<String, Any>()
            speakersMap["speakers"] = speakersList

            val hashMap = HashMap<String, Any?>()
            hashMap["event_name"] = "on_update_speaker"
            hashMap["data"] = speakersMap
//            HMSLogger.i(
//                "onAudioLevelUpdateAndroid2",
//                (hashMap.get("data") as HashMap<String, Any>).get("speakers").toString()
//            )
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
        hmssdk.changeTrackState(track, mute!!, hmsActionResultListener = this.actionListener)
    }

    private fun hlsStreaming(call: MethodCall) {
        val meetingUrl = call.argument<String>("meeting_url")
        val meetingUrlVariant1 = HMSHLSMeetingURLVariant(
            meetingUrl = meetingUrl!!,
            metadata = "tag for reference"
        )

        val hlsConfig = HMSHLSConfig(listOf(meetingUrlVariant1))

        hmssdk.startHLSStreaming(
            hlsConfig,
            hmsActionResultListener = object : HMSActionResultListener {
                override fun onError(error: HMSException) {

                }

                override fun onSuccess() {

                }

            })
    }

    private fun stopHLSStreaming() {
        hmssdk.stopHLSStreaming(null, hmsActionResultListener = object : HMSActionResultListener {
            override fun onError(error: HMSException) {

            }

            override fun onSuccess() {

            }

        })
    }


    private fun removePeer(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!) as HMSRemotePeer

        hmssdk.removePeerRequest(
            peer = peer,
            hmsActionResultListener = this.actionListener,
            reason = "noise"
        )
    }

    private fun removeHMSLogger() {
        HMSLogger.removeInjectedLoggable()
    }

    private fun endRoom(call: MethodCall, result: Result) {
        if (isAllowedToEndMeeting() && hasJoined) {
            val lock = call.argument<Boolean>("lock")
            hmssdk.endRoom(
                lock = lock!!,
                reason = "noise",
                hmsActionResultListener = this.actionListener
            )

            hasJoined = false
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


    private fun changeTrackStateForRole(call: MethodCall, result: Result) {
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
            result.success(false)
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
        result.success(HMSRoomExtension.toDictionary(hmssdk?.getRoom(), null))
    }

    private fun updateHMSLocalTrackSetting(call: MethodCall) {
        val localPeerVideoTrack = getLocalPeer().videoTrack
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

    private var isRaiseHandTrue: Boolean = false
    private fun raiseHand() {
        isRaiseHandTrue = !isRaiseHandTrue
        hmssdk.changeMetadata(
            "{\"isHandRaised\":${isRaiseHandTrue}}",
            hmsActionResultListener = this.actionListener
        )

    }


    private val hmsUpdateListener = object : HMSUpdateListener {
        override fun onChangeTrackStateRequest(details: HMSChangeTrackStateRequest) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_change_track_state_request")
            args.put("data", HMSChangeTrackStateRequestExtension.toDictionary(details)!!)
//        Log.i("androiddata1", args.get("event_name").toString())
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(error))
//        Log.i("onError", args["data"].toString())
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onJoin(room: HMSRoom) {
//        Log.i("onJoin", hmssdk.getRoles().toString());
            hasJoined = true
            hmssdk.addAudioObserver(hmsAudioListener)
            previewChannel.setStreamHandler(null)
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_join_room")
            //Log.i("onjoinAndroidPreviewListener", room.hlsStreamingState?.running.toString())
            val roomArgs = HashMap<String, Any?>()
            roomArgs.put("room", HMSRoomExtension.toDictionary(room, null))
            args.put("data", roomArgs)
//        Log.i("onJoin", args.get("data").toString())
            if (roomArgs["room"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }

        }

        override fun onMessageReceived(message: HMSMessage) {

            val args = HashMap<String, Any?>()
            args.put("event_name", "on_message")
            args.put("data", HMSMessageExtension.toDictionary(message))
//        Log.i("onMessageReceived", args.get("data").toString())
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {

            val args = HashMap<String, Any?>()
            args.put("event_name", "on_peer_update")
//        Log.i("onPeerUpdate1", type.toString())
            args.put("data", HMSPeerUpdateExtension.toDictionary(peer, type))
//        Log.i("onPeerUpdate2", args.get("data").toString())
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_update_room")

            val arg = HashMap<String, Any?>()
            arg["room"] = HMSRoomExtension.toDictionary(hmsRoom, type)
            args.put("data", arg)
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
        }

        override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_track_update")
            Log.i(
                "onTrackUpdate",
                track.isMute.toString() + " " + peer.name + " " + type.toString()
            )

            args.put("data", HMSTrackUpdateExtension.toDictionary(peer, track, type))
            HMSLogger.i("onTrackUpdate", peer.toString())
            //Log.i("onTrackUpdate", args.get("data").toString())
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
            //Log.i("HMSActionListener", "OnSuccess")
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
//        Log.i("onError", args["data"].toString())
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
        }

        override fun onPreview(room: HMSRoom, localTracks: Array<HMSTrack>) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "preview_video")
            args.put("data", HMSPreviewExtension.toDictionary(room, localTracks))
            //Log.i("onPreviewAndroidPreviewListener", room.hlsStreamingState.toString()+room.peerList.size)
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
            args["data"] = HMSMessageExtension.toDictionary(hmsMessage)
            if (args["data"] != null)
                CoroutineScope(Dispatchers.Main).launch {
                    result?.success(args)
                }
        }

    }
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
            CoroutineScope(Dispatchers.Main).launch {
                logsSink?.success(args)
            }
        }

    }

    private fun setPlayBackAllowed(call: MethodCall) {
        val allowed = call.argument<Boolean>("allowed")
        hmssdk.getRemotePeers().forEach {
            it.videoTrack?.isPlaybackAllowed = allowed!!
        }
        getLocalPeer().videoTrack?.setMute(!(allowed!!))
        result?.success("setPlatBackAllowed${allowed!!}")
    }

    private fun isVideoPlayBackAllowed(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")
        val peer : HMSRemotePeer? = hmssdk.getRemotePeers().first { it.peerID == peerId }
        if(peer == null){
            result?.success(false)
        }
        else
            result?.success(peer.videoTrack?.isPlaybackAllowed)
    }

    private fun isAudioPlayBackAllowed(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")
        val peer : HMSRemotePeer? = hmssdk.getRemotePeers().first { it.peerID == peerId }
        if(peer == null){
            result?.success(false)
        }
        else {
            result?.success(peer.audioTrack?.isPlaybackAllowed)
        }
    }

    private fun setVideoPlayBackAllowed(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")
        val setVideo = call.argument<Boolean>("is_playback_allowed")
        val peer : HMSRemotePeer? = hmssdk.getRemotePeers().first { it.peerID == peerId }
        if(peer == null){
            result?.success(false)
        }
        else {
            peer.videoTrack?.isPlaybackAllowed = setVideo!!
            result?.success(true)
        }
    }

    private fun setAudioPlayBackAllowed(call: MethodCall) {
        val peerId = call.argument<String>("peer_id")
        val setAudio = call.argument<Boolean>("is_playback_allowed")
        val peer : HMSRemotePeer? = hmssdk.getRemotePeers().first { it.peerID == peerId }
        if(peer == null){
            result?.success(false)
        }
        else {
            peer.videoTrack?.isPlaybackAllowed = setAudio!!
                result?.success(true)
        }
    }
}