package live.hms.hmssdk_flutter

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
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
import live.hms.hmssdk_flutter.methods.HMSPipAction
import live.hms.hmssdk_flutter.methods.HMSRemoteVideoTrackAction
import live.hms.hmssdk_flutter.methods.HMSSessionMetadataAction
import live.hms.hmssdk_flutter.views.HMSVideoViewFactory
import live.hms.video.audio.HMSAudioManager.*
import live.hms.video.connection.stats.*
import live.hms.video.error.HMSException
import live.hms.video.events.AgentType
import live.hms.video.media.tracks.*
import live.hms.video.sdk.*
import live.hms.video.sdk.models.*
import live.hms.video.sdk.models.enums.AudioMixingMode
import live.hms.video.sdk.models.enums.HMSPeerUpdate
import live.hms.video.sdk.models.enums.HMSRoomUpdate
import live.hms.video.sdk.models.enums.HMSTrackUpdate
import live.hms.video.sdk.models.role.HMSRole
import live.hms.video.sdk.models.trackchangerequest.HMSChangeTrackStateRequest
import live.hms.video.utils.HMSLogger
import live.hms.video.utils.HmsUtilities

/** HmssdkFlutterPlugin */
@SuppressLint("StaticFieldLeak")
class HmssdkFlutterPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware,
    EventChannel.StreamHandler {

    private var channel: MethodChannel? = null
    private var meetingEventChannel: EventChannel? = null
    private var previewChannel: EventChannel? = null
    private var logsEventChannel: EventChannel? = null
    private var rtcStatsChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var previewSink: EventChannel.EventSink? = null
    private var logsSink: EventChannel.EventSink? = null
    private var rtcSink: EventChannel.EventSink? = null
    private lateinit var activity: Activity
    var hmssdk: HMSSDK? = null
    private lateinit var hmsVideoFactory: HMSVideoViewFactory
    private var requestChange: HMSRoleChangeRequest? = null
    companion object {
        var hmssdkFlutterPlugin: HmssdkFlutterPlugin? = null
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        //Channel initialisation is done here
        if (hmssdkFlutterPlugin == null) {
            this.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hmssdk_flutter")
            this.meetingEventChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "meeting_event_channel")
            this.previewChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "preview_event_channel")

            this.logsEventChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "logs_event_channel")

            this.rtcStatsChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "rtc_event_channel")

            this.meetingEventChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Meeting event channel not found")
            this.channel?.setMethodCallHandler(this) ?: Log.e("Channel Error", "Event channel not found")
            this.previewChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Preview channel not found")
            this.logsEventChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Logs event channel not found")
            this.rtcStatsChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "RTC Stats channel not found")
            this.hmsVideoFactory = HMSVideoViewFactory(this)

            flutterPluginBinding.platformViewRegistry.registerViewFactory(
                "HMSVideoView",
                hmsVideoFactory
            )
            hmssdkFlutterPlugin = this
        } else {
            Log.e("Plugin Warning", "hmssdkFlutterPlugin already exists in onAttachedToEngine")
        }
    }

    //All the methods from flutter side are routed here and are navigated to respective handlers
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if(hmssdk != null){
            when (call.method) {
                "getPlatformVersion" -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                }

                // MARK: Build Actions
                "build", "preview", "join", "leave", "destroy" -> {
                    buildActions(call, result)
                }

                // MARK: Room Actions
                "get_room", "get_local_peer", "get_remote_peers", "get_peers" -> {
                    HMSRoomAction.roomActions(call, result, hmssdk!!)
                }

                // MARK: Audio Helpers
                "switch_audio", "is_audio_mute", "mute_room_audio_locally", "un_mute_room_audio_locally", "set_volume", "toggle_mic_mute_state" -> {
                    HMSAudioAction.audioActions(call, result, hmssdk!!)
                }

                // MARK: Video Helpers
                "switch_video", "switch_camera", "is_video_mute", "mute_room_video_locally", "un_mute_room_video_locally", "toggle_camera_mute_state" -> {
                    HMSVideoAction.videoActions(call, result, hmssdk!!)
                }

                // MARK: Messaging
                "send_broadcast_message", "send_direct_message", "send_group_message" -> {
                    HMSMessageAction.messageActions(call, result, hmssdk!!)
                }

                // MARK: Role based Actions
                "get_roles", "change_role", "accept_change_role", "end_room", "remove_peer", "on_change_track_state_request", "change_track_state_for_role", "change_role_of_peers_with_roles", "change_role_of_peer" -> {
                    roleActions(call, result)
                }

                // MARK: Peer Actions
                "change_metadata", "change_name" -> {
                    peerActions(call, result)
                }

                // MARK: Recording
                "start_rtmp_or_recording", "stop_rtmp_and_recording" -> {
                    HMSRecordingAction.recordingActions(call, result, hmssdk!!)
                }

                // MARK: HLS
                "hls_start_streaming", "hls_stop_streaming" -> {
                    HMSHLSAction.hlsActions(call, result, hmssdk!!)
                }

                // MARK: Logger
                "start_hms_logger", "remove_hms_logger" -> {
                    loggerActions(call, result)
                }

                // MARK: Screenshare
                "start_screen_share", "stop_screen_share", "is_screen_share_active" -> {
                    screenshareActions(call, result)
                }

                "get_track_by_id" -> {
                    getTrackById(call, result)
                }
                "get_all_tracks" -> {
                    getAllTracks(call, result)
                }
                "start_stats_listener", "remove_stats_listener" -> {
                    statsListenerAction(call, result)
                }
                "get_audio_devices_list", "get_current_audio_device", "switch_audio_output" -> {
                    HMSAudioDeviceAction.audioDeviceActions(call, result, hmssdk!!)
                }
                "start_audio_share", "stop_audio_share", "set_audio_mixing_mode" -> {
                    audioShare(call, result)
                }

                "get_track_settings" -> {
                    trackSettings(call, result)
                }
                "get_session_metadata", "set_session_metadata" -> {
                    HMSSessionMetadataAction.sessionMetadataActions(call, result, hmssdk!!)
                }
                "set_playback_allowed_for_track" -> {
                    setPlaybackAllowedForTrack(call, result)
                }
                "enter_pip_mode", "is_pip_active", "is_pip_available" -> {
                    HMSPipAction.pipActions(call, result, this.activity)
                }
                "set_simulcast_layer", "get_layer", "get_layer_definition" -> {
                    HMSRemoteVideoTrackAction.remoteVideoTrackActions(call, result, hmssdk!!)
                }
                "capture_snapshot" -> {
                    captureSnapshot(call, result)
                }
                else -> {
                    result.notImplemented()
                }
            }

        }
        else{
            Log.e("HMSSDK Error","${call.method} error: hmssdk is null")
            return
        }
    }

    // MARK: Build Actions
    private fun buildActions(call: MethodCall, result: Result) {
        when (call.method) {
            "build" -> {
                build(this.activity, call, result)
            }
            "preview" -> {
                preview(call, result)
            }
            "join" -> {
                join(call, result)
            }
            "leave" -> {
                leave(result)
            }
            "destroy" -> {
                destroy()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    // MARK: Role based Actions
    private fun roleActions(call: MethodCall, result: Result) {
        when (call.method) {
            "get_roles" -> {
                getRoles(result)
            }
            "change_role" -> {
                changeRole(call, result)
            }
            "accept_change_role" -> {
                acceptChangeRole(result)
            }
            "end_room" -> {
                endRoom(call, result)
            }
            "remove_peer" -> {
                removePeer(call, result)
            }
            "on_change_track_state_request" -> {
                changeTrackState(call, result)
            }
            "change_track_state_for_role" -> {
                changeTrackStateForRole(call, result)
            }
            "change_role_of_peers_with_roles" -> {
                changeRoleOfPeersWithRoles(call, result)
            }
            "change_role_of_peer" -> {
                changeRoleOfPeer(call, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    // MARK: Peer Actions
    private fun peerActions(call: MethodCall, result: Result) {
        when (call.method) {
            "change_metadata" -> {
                changeMetadata(call, result)
            }
            "change_name" -> {
                changeName(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    // MARK: Logger
    private fun loggerActions(call: MethodCall, result: Result) {
        when (call.method) {
            "start_hms_logger" -> {
                startHMSLogger(call)
            }
            "remove_hms_logger" -> {
                removeHMSLogger()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    // MARK: Screenshare
    private fun screenshareActions(call: MethodCall, result: Result) {
        when (call.method) {
            "start_screen_share" -> {
                startScreenShare(result)
            }

            "stop_screen_share" -> {
                stopScreenShare(result)
            }

            "is_screen_share_active" -> {
                if(hmssdk != null){
                    result.success(hmssdk!!.isScreenShared())
                }
                else{
                    Log.e("HMSSDK Error","screenshareActions error: hmssdk is null")
                    result.success(false)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun statsListenerAction(call: MethodCall, result: Result) {
        if(hmssdk != null){
            when (call.method) {
                "start_stats_listener" -> {
                    hmssdk!!.addRtcStatsObserver(this.hmsStatsListener)

                }
                "remove_stats_listener" -> {
                    hmssdk!!.removeRtcStatsObserver()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        else{
            Log.e("HMSSDK Error","statsListenerAction error: hmssdk is null")
        }
    }

    private fun audioShare(call: MethodCall, result: Result) {
        when (call.method) {
            "start_audio_share" -> {
                startAudioShare(call, result)
            }

            "stop_audio_share" -> {
                stopAudioShare(result)
            }
            "set_audio_mixing_mode" -> {
                setAudioMixingMode(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun trackSettings(call: MethodCall, result: Result) {
        if(hmssdk != null){
            when (call.method) {
                "get_track_settings" -> {
                    result.success(HMSTrackSettingsExtension.toDictionary(hmssdk!!))
                }
            }
        }
        else{
            Log.e("HMSSDK Error","trackSettings error: hmssdk is null")
        }
    }

    //Gets called when flutter plugin is removed from engine so setting the channels,sink to null
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        if (hmssdkFlutterPlugin != null) {
            channel?.setMethodCallHandler(null) ?: Log.e("Channel Error", "Event channel not found")
            meetingEventChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Meeting event channel not found")
            previewChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Preview channel not found")
            logsEventChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Logs event channel not found")
            rtcStatsChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "RTC Stats channel not found")
            eventSink = null
            previewSink = null
            rtcSink = null
            logsSink = null
            hmssdkFlutterPlugin = null
        } else {
            Log.e("Plugin Error", "hmssdkFlutterPlugin is null in onDetachedFromEngine")
        }
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
        val config = getConfig(call)
        if(hmssdk != null){
            // Checking that config is not null as it's required to join
            if(config != null){
                hmssdk!!.join(config, this.hmsUpdateListener)
                hmssdk!!.setAudioDeviceChangeListener(audioDeviceChangeListener)
                result.success(null)
            }
            else{
                Log.e("HMSConfig Error","join error: config is null")
            }
        }
        else{
            Log.e("HMSSDK Error","join error: hmssdk is null")
        }
    }

    private fun getConfig(
        call: MethodCall
    ): HMSConfig? {
        //Checking userName and authToken to be not null
        val userName = call.argument<String>("user_name") ?: returnError(
            "getConfig error userName is null"
        )
        val authToken = call.argument<String>("auth_token") ?: returnError(
            "getConfig error authToken is null"
        )
        val metaData = call.argument<String>("meta_data") ?: ""
        val endPoint = call.argument<String>("end_point")
        val captureNetworkQualityInPreview =
            call.argument<Boolean>("capture_network_quality_in_preview") ?: false

        if (userName != null && authToken != null) {
            if (endPoint != null && endPoint.isNotEmpty()) {
                return HMSConfig(
                    userName = userName as String,
                    authtoken = authToken as String,
                    metadata = metaData,
                    initEndpoint = endPoint.trim(),
                    captureNetworkQualityInPreview = captureNetworkQualityInPreview
                )
            }

            return HMSConfig(
                userName = userName as String,
                authtoken = authToken as String,
                metadata = metaData,
                captureNetworkQualityInPreview = captureNetworkQualityInPreview
            )
        }
        else{
            return null
        }
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

    private fun leave(result: Result) {
        if(hmssdk != null){
            hmssdk!!.leave(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        }
        else{
            Log.e("HMSSDK Error","leave error: hmssdk is null")
        }
    }

    private fun destroy() {
        hmssdk = null
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        //To check whether the arguments contain arguments
        if((arguments as HashMap<*, *>).containsKey("name")){
            val nameOfEventSink = (arguments)["name"]
            if(nameOfEventSink != null){
                when (nameOfEventSink) {
                    "meeting" -> {
                        this.eventSink = events
                    }
                    "preview" -> {
                        this.previewSink = events
                    }
                    "logs" -> {
                        this.logsSink = events
                    }
                    "rtc_stats" -> {
                        this.rtcSink = events
                    }
                }
            }
            else{
                Log.e("Sink Error","onListen error: nameOfEventSink is null")
            }
        }
        else{
            Log.e("Arguments Error","onListen error: arguments does not contain key `name`")
        }
    }

    override fun onCancel(arguments: Any?) {}

    private fun getPeerById(id: String): HMSPeer? {
        if (id == "") return getLocalPeer()
        if(hmssdk != null){
            val peers = hmssdk!!.getPeers()
            peers.forEach {
                if (it.peerID == id) return it
            }
        }
        else{
            Log.e("HMSSDK Error","getPeerById error: hmssdk is null")
        }
        return null
    }

    private fun getAllTracks(): ArrayList<HMSTrack>? {
        return if(hmssdk != null){
            val room = hmssdk!!.getRoom()
            val allTracks = ArrayList<HMSTrack>()
            //To check whether room is null or not as it's absurd to look for tracks in a null room
            if (room != null) {
                allTracks.addAll(HmsUtilities.getAllAudioTracks(room))
                allTracks.addAll(HmsUtilities.getAllVideoTracks(room))
            }
            else{
             Log.e("Null Error","getAllTracks error: room is null")
            }
            allTracks
        } else{
            Log.e("HMSSDK Error","getAllTracks error: hmssdk is null")
            null
        }
    }

    private fun preview(call: MethodCall, result: Result) {
        val config = getConfig(call)
        if(hmssdk != null){
            // Checking that config is not null as it's required to preview
            if(config != null){
                hmssdk!!.preview(config, this.hmsPreviewListener)
                hmssdk!!.setAudioDeviceChangeListener(audioPreviewDeviceChangeListener)
                result.success(null)
            }
            else{
                Log.e("HMSConfig Error","preview error: config is null")
            }
        }
        else{
            Log.e("HMSSDK Error","preview error: hmssdk is null")
        }
    }

    private fun getLocalPeer(): HMSLocalPeer? {
        return if(hmssdk != null){
            hmssdk!!.getLocalPeer()
        } else{
            Log.e("HMSSDK Error","getLocalPeer error: hmssdk is null")
            null
        }
    }

    private fun changeRole(call: MethodCall, result: Result) {
        // Checking roleUWant,peerId,forceChange as they are required for changeRole if not logging respective logs
        val roleUWant = call.argument<String>("role_name")?:returnError("changeRole error roleUWant is null")
        val peerId = call.argument<String>("peer_id")?:returnError("changeRole error peerId is null")
        val forceChange = call.argument<Boolean>("force_change")?:returnError("changeRole error forceChange is null")

        if(hmssdk != null){
            val roles = hmssdk!!.getRoles()
            try{
              val roleToChangeTo  = roles.first {
                    it.name == roleUWant
                }
                val peer: HMSPeer? = getPeerById(peerId as String)
                if(peer != null){
                    hmssdk?.changeRole(
                        peer,
                        roleToChangeTo,
                        (forceChange as Boolean),
                        hmsActionResultListener = HMSCommonAction.getActionListener(result)
                    )
                }
                else{
                    Log.e("changeRole Error","changeRole error: peer is null")
                }
            }
            catch (exception:Exception){
                Log.e("Exception Occurred","${exception.message}")
            }
        }
        else{
            Log.e("HMSSDK Error","changeRole error: hmssdk is null")
        }
    }

    private fun changeRoleOfPeer(call: MethodCall, result: Result) {
        // Checking roleUWant,peerId,forceChange as they are required for changeRoleOfPeer if not logging respective logs
        val roleUWant = call.argument<String>("role_name")?:returnError("changeRoleOfPeer error roleUWant is null")
        val peerId = call.argument<String>("peer_id")?:returnError("changeRoleOfPeer error peerId is null")
        val forceChange = call.argument<Boolean>("force_change")?:returnError("changeRoleOfPeer error forceChange is null")
        if(hmssdk != null) {
            val roles = hmssdk!!.getRoles()
            try {
                val roleToChangeTo: HMSRole = roles.first {
                    it.name == roleUWant
                }
                val peer: HMSPeer? = getPeerById(peerId as String)
                if (peer != null) {
                    hmssdk!!.changeRoleOfPeer(
                        peer,
                        roleToChangeTo,
                        forceChange as Boolean,
                        hmsActionResultListener = HMSCommonAction.getActionListener(result)
                    )
                } else {
                    Log.e("changeRole Error", "changeRole error: peer is null")
                }
            }
            catch (exception:Exception){
                Log.e("Exception Occurred","${exception.message}")
            }
        }
        else{
            Log.e("HMSSDK Error","changeRoleOfPeer error: hmssdk is null")
        }
    }

    private fun getRoles(result: Result) {
        val args = HashMap<String, Any?>()
        val roles = ArrayList<Any>()

        if(hmssdk!= null){
            hmssdk!!.getRoles().forEach {
                roles.add(HMSRoleExtension.toDictionary(it)!!)
            }
            args["roles"] = roles
            result.success(args)
        }
        else{
            Log.e("HMSSDK Error","getRoles error: hmssdk is null")
        }
    }

    private fun acceptChangeRole(result: Result) {
        //Checking whether requestChange is null or not to handle the consecutive calls when previous call is not answered
        if (requestChange != null) {
            if(hmssdk != null){
                hmssdk!!.acceptChangeRole(
                    this.requestChange!!,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
                )
                requestChange = null
            }
            else{
                Log.e("HMSSDK Error","acceptChangeRole error: hmssdk is null")
            }
        } else {
            val hmsException = HMSException(
                action = "Resend Role Change Request",
                code = 6004,
                description = "Role Change Request is Expired.",
                message = "Role Change Request is Expired.",
                name = "Role Change Request Error"
            )
            val args = HMSExceptionExtension.toDictionary(hmsException)
            result.success(args)
        }
    }

    var hmsAudioListener = object : HMSAudioListener {
        override fun onAudioLevelUpdate(speakers: Array<HMSSpeaker>) {
            val speakersList = ArrayList<HashMap<String, Any?>>()

            HMSLogger.i(
                "onAudioLevelUpdateHMSLogger",
                HMSLogger.level.toString()
            )

            if (speakers.isNotEmpty()) {
                speakers.forEach {
                    val hmsSpeakerMap = HMSSpeakerExtension.toDictionary(it)
                    if (hmsSpeakerMap != null) {
                        speakersList.add(hmsSpeakerMap)
                    }
                }
            }
            val speakersMap = HashMap<String, Any>()
            speakersMap["speakers"] = speakersList

            val hashMap: HashMap<String, Any?> = HashMap()
            hashMap["event_name"] = "on_update_speaker"
            hashMap["data"] = speakersMap

            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(hashMap)
            }
        }
    }

    private fun changeTrackState(call: MethodCall, result: Result) {
        // Checking trackId, mute as they are required for calling changeTrackState if not present logging respective logs
        val trackId = call.argument<String>("track_id")?:returnError("changeTrackState error trackId is null")
        val mute = call.argument<Boolean>("mute")?:returnError("changeTrackState error mute is null")

        val tracks = getAllTracks()

        try {
            val track = tracks?.first {
                it.trackId == trackId
            }
            if (mute != null) {
                if (hmssdk != null) {
                    hmssdk!!.changeTrackState(
                        track!!,
                        (mute as Boolean),
                        hmsActionResultListener = HMSCommonAction.getActionListener(result)
                    )
                } else {
                    Log.e("HMSSDK Error", "changeTrackState error: hmssdk is null")
                }
            }
            else{
                Log.e("Null error","changeTrackState error: mute is null")
            }
        }
        catch (exception:Exception){
            Log.e("Exception Occurred","${exception.message}")
        }
    }

    private fun removePeer(call: MethodCall, result: Result) {
        // Checking peerId as it is required for calling removePeer if not present logging respective logs
        val peerId = call.argument<String>("peer_id")?:returnError("removePeer error peerId is null")
        val reason = call.argument<String>("reason") ?: "Removed from room"

        if(peerId != null){
            val peer = getPeerById(peerId as String) as HMSRemotePeer?
            if(peer != null){
                if(hmssdk != null){
                    hmssdk?.removePeerRequest(
                        peer = peer,
                        hmsActionResultListener = HMSCommonAction.getActionListener(result),
                        reason = reason
                    )
                }
                else{
                    Log.e("HMSSDK Error", "removePeer error: hmssdk is null")
                }
            }
            else{
                Log.e("Peer Error","removePeer error: no peer found with $peerId")
            }
        }
    }

    private fun removeHMSLogger() {
        HMSLogger.removeInjectedLoggable()
    }

    private fun endRoom(call: MethodCall, result: Result) {
        val lock = call.argument<Boolean>("lock") ?: false
        val reason = call.argument<String>("reason") ?: "End room invoked"
        if(hmssdk != null){
            hmssdk!!.endRoom(
                lock = lock,
                reason = reason,
                hmsActionResultListener = HMSCommonAction.getActionListener(result)
            )
        }
        else{
            Log.e("HMSSDK Error", "endRoom error: hmssdk is null")
        }
    }

    private fun changeTrackStateForRole(call: MethodCall, result: Result) {
        // Checking mute as it is required for calling changeTrackStateForRole if not present logging respective logs
        val mute = call.argument<Boolean>("mute")?:returnError("changeTrackStateForRole error: mute is null")
        val type = call.argument<String>("type")
        val source = call.argument<String>("source")
        val roles: List<String>? = call.argument<List<String>>("roles")
        if(hmssdk != null) {
            val hmsRoles: List<HMSRole>? = if (roles != null) {
                hmssdk!!.getRoles().filter { roles.contains(it.name) }
            } else {
                null
            }
            if(mute != null){
                hmssdk!!.changeTrackState(
                    mute = mute as Boolean,
                    type = HMSTrackExtension.getKindFromString(type),
                    source = source,
                    roles = hmsRoles,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
                )
            }
            else{
                Log.e("Null error","changeTrackState error: mute is null")
            }
        }
        else{
            Log.e("HMSSDK Error", "changeTrackStateForRole error: hmssdk is null")
        }
    }

    private fun changeRoleOfPeersWithRoles(call: MethodCall, result: Result) {
        // Checking roleString as it is required for calling changeRoleOfPeersWithRoles if not present logging respective logs
        val roleString = call.argument<String>("to_role")?:returnError("changeRoleOfPeersWithRoles error: roleString is null")
        val ofRoleString: List<String>? = call.argument<List<String>>("of_roles")

        if(hmssdk != null) {
            val roles = hmssdk!!.getRoles()
            try {
                val toRole: HMSRole = roles.first {
                    it.name == roleString
                }
                if(ofRoleString != null){
                    val ofRoles: List<HMSRole> =
                        hmssdk!!.getRoles().filter { ofRoleString.contains(it.name) }
                    hmssdk!!.changeRoleOfPeersWithRoles(
                        toRole = toRole,
                        ofRoles = ofRoles,
                        hmsActionResultListener = HMSCommonAction.getActionListener(result)
                    )
                }
                else{
                    Log.e("Null Error","changeRoleOfPeersWithRoles error: ofRoleString is null")
                }
            }
            catch (exception:Exception){
                Log.e("Exception Occurred","${exception.message}")
            }
        }
        else{
            Log.e("HMSSDK Error", "changeRoleOfPeersWithRoles error: hmssdk is null")
        }
    }

    private fun build(activity: Activity, call: MethodCall, result: Result) {
        // Checking dartSDKVersion,hmsSDKVersion as they are required for calling build if not present logging respective logs
        val dartSDKVersion = call.argument<String>("dart_sdk_version")?:returnError("build error:dartSDKVersion is null")
        val hmsSDKVersion = call.argument<String>("hmssdk_version")?:returnError("build error:hmsSDKVersion is null")

        if(dartSDKVersion != null && hmsSDKVersion != null ){
            val framework = FrameworkInfo(framework = AgentType.FLUTTER, frameworkVersion = dartSDKVersion as String, frameworkSdkVersion = hmsSDKVersion as String)
            val builder = HMSSDK.Builder(activity).setFrameworkInfo(framework)

            val hmsTrackSettingMap =
                call.argument<HashMap<String, HashMap<String, Any?>?>?>("hms_track_setting")

            if (hmsTrackSettingMap != null) {
                val hmsAudioTrackHashMap: HashMap<String, Any?>? = hmsTrackSettingMap["audio_track_setting"]
                val hmsVideoTrackHashMap: HashMap<String, Any?>? = hmsTrackSettingMap["video_track_setting"]
                val hmsTrackSettings = HMSTrackSettingsExtension.setTrackSettings(hmsAudioTrackHashMap, hmsVideoTrackHashMap)
                builder.setTrackSettings(hmsTrackSettings)
            }

            val hmsLogSettingsMap =
                call.argument<HashMap<String, Any>?>("hms_log_settings")

            if (hmsLogSettingsMap != null) {
                val maxDirSizeInBytes: Double = hmsLogSettingsMap["max_dir_size_in_bytes"] as Double
                val isLogStorageEnabled: Boolean = hmsLogSettingsMap["log_storage_enabled"] as Boolean
                val level: String = hmsLogSettingsMap["log_level"] as String
                val logSettings = HMSLogSettings.setLogSettings(maxDirSizeInBytes, isLogStorageEnabled, level)
                builder.setLogSettings(logSettings)
            }

            hmssdk = builder.build()
            result.success(true)
        }
        else{
            result.success(false)
        }
    }

    private var hasChangedMetadata: Boolean = false

    private fun changeMetadata(call: MethodCall, result: Result) {
        hasChangedMetadata = !hasChangedMetadata
        // Checking metadata as it is required for calling changeMetadata if not present logging respective logs
        val metadata = call.argument<String>("metadata")?:returnError("changeMetadata error:metadata is null")

        if(metadata != null){
            if(hmssdk != null){
                hmssdk!!.changeMetadata(
                    metadata as String,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
                )
            }
            else{
                Log.e("HMSSDK Error", "changeMetadata error: hmssdk is null")
            }
        }
    }

    private val hmsUpdateListener = object : HMSUpdateListener {
        override fun onChangeTrackStateRequest(details: HMSChangeTrackStateRequest) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_change_track_state_request"
            args["data"] = HMSChangeTrackStateRequestExtension.toDictionary(details)!!

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_error"
            args["data"] = HMSExceptionExtension.toDictionary(error)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onJoin(room: HMSRoom) {
            if(hmssdk != null){
                //Adding audio observer for sending audio level updates for each peer
                hmssdk!!.addAudioObserver(hmsAudioListener)
                val args = HashMap<String, Any?>()
                args["event_name"] = "on_join_room"

                val roomArgs = HashMap<String, Any?>()
                roomArgs["room"] = HMSRoomExtension.toDictionary(room)
                args["data"] = roomArgs
                if (roomArgs["room"] != null) {
                    CoroutineScope(Dispatchers.Main).launch {
                        eventSink?.success(args)
                    }
                }
            }
            else{
                Log.e("HMSSDK Error", "onJoin error: hmssdk is null")
            }
        }

        override fun onMessageReceived(message: HMSMessage) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_message"
            args["data"] = HMSMessageExtension.toDictionary(message)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {
            if (type == HMSPeerUpdate.AUDIO_TOGGLED || type == HMSPeerUpdate.VIDEO_TOGGLED ||
                type == HMSPeerUpdate.BECAME_DOMINANT_SPEAKER || type == HMSPeerUpdate.NO_DOMINANT_SPEAKER ||
                type == HMSPeerUpdate.RESIGNED_DOMINANT_SPEAKER || type == HMSPeerUpdate.STARTED_SPEAKING ||
                type == HMSPeerUpdate.STOPPED_SPEAKING
            ) {
                return
            }

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_peer_update"

            args["data"] = HMSPeerUpdateExtension.toDictionary(peer, type)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_room_update"
            args["data"] = HMSRoomUpdateExtension.toDictionary(hmsRoom, type)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_track_update"
            args["data"] = HMSTrackUpdateExtension.toDictionary(peer, track, type)
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onRemovedFromRoom(notification: HMSRemovedFromRoom) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_removed_from_room"
            args["data"] = HMSRemovedFromRoomExtension.toDictionary(notification)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onReconnected() {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_re_connected"
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
        }

        override fun onReconnecting(error: HMSException) {
            val args = HashMap<String, Any>()
            args["event_name"] = "on_re_connecting"
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
        }

        override fun onRoleChangeRequest(request: HMSRoleChangeRequest) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_role_change_request"
            args["data"] = HMSRoleChangedExtension.toDictionary(request)
            requestChange = request
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }
    }

    private val hmsPreviewListener = object : HMSPreviewListener {
        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_error"
            args["data"] = HMSExceptionExtension.toDictionary(error)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }

        override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {
            if (type == HMSPeerUpdate.AUDIO_TOGGLED || type == HMSPeerUpdate.VIDEO_TOGGLED ||
                type == HMSPeerUpdate.BECAME_DOMINANT_SPEAKER || type == HMSPeerUpdate.NO_DOMINANT_SPEAKER ||
                type == HMSPeerUpdate.RESIGNED_DOMINANT_SPEAKER || type == HMSPeerUpdate.STARTED_SPEAKING ||
                type == HMSPeerUpdate.STOPPED_SPEAKING
            ) {
                return
            }

            val args = HashMap<String, Any?>()

            args["event_name"] = "on_peer_update"

            args["data"] = HMSPeerUpdateExtension.toDictionary(peer, type)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }

        override fun onPreview(room: HMSRoom, localTracks: Array<HMSTrack>) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "preview_video"
            args["data"] = HMSPreviewExtension.toDictionary(room, localTracks)
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }

        override fun onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_room_update"
            args["data"] = HMSRoomUpdateExtension.toDictionary(hmsRoom, type)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }
    }

    var finalArgs = mutableListOf<Any?>()
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

            if (finalArgs.size < 1000) {
                finalArgs.add(args)
            } else {
                val copyFinalArgs = mutableListOf<Any?>()
                copyFinalArgs.addAll(finalArgs)
                CoroutineScope(Dispatchers.Main).launch {
                    logsSink?.success(copyFinalArgs)
                }
                finalArgs.clear()
            }
        }
    }

    private fun changeName(call: MethodCall, result: Result) {
        // Checking name as it is required for calling changeName if not present logging respective logs
        val name = call.argument<String>("name")?:returnError("changeName error:name is null")
        if(name != null){
            if(hmssdk != null){
                hmssdk!!.changeName(
                    name = name as String,
                    hmsActionResultListener = HMSCommonAction.getActionListener(result)
                )
            }
            else{
                Log.e("HMSSDK Error", "changeName error: hmssdk is null")
            }
        }
    }

    fun onVideoViewError(args: HashMap<String, Any?>) {
        if (args["data"] != null) {
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
        }
    }

    private var androidScreenshareResult: Result? = null

    private fun startScreenShare(result: Result) {
        androidScreenshareResult = result
        val mediaProjectionManager: MediaProjectionManager = activity.getSystemService(
            Context.MEDIA_PROJECTION_SERVICE
        ) as MediaProjectionManager
        activity.startActivityForResult(
            mediaProjectionManager.createScreenCaptureIntent(),
            Constants.SCREEN_SHARE_INTENT_REQUEST_CODE
        )
    }

    fun requestScreenShare(data: Intent?) {
        if(hmssdk != null){
            hmssdk!!.startScreenshare(
                object : HMSActionResultListener {

                    override fun onError(error: HMSException) {
                        CoroutineScope(Dispatchers.Main).launch {
                            androidScreenshareResult?.success(HMSExceptionExtension.toDictionary(error))
                            androidScreenshareResult = null
                        }
                    }

                    override fun onSuccess() {
                        CoroutineScope(Dispatchers.Main).launch {
                            androidScreenshareResult?.success(null)
                            androidScreenshareResult = null
                        }
                    }
                },
                data
            )
        }
        else{
            Log.e("HMSSDK Error", "requestScreenShare error: hmssdk is null")
        }
    }

    private fun stopScreenShare(result: Result) {
        if(hmssdk != null){
            hmssdk!!.stopScreenshare(HMSCommonAction.getActionListener(result))
        }
        else{
            Log.e("HMSSDK Error", "stopScreenShare error: hmssdk is null")
        }
    }

    private var androidAudioShareResult: Result? = null
    private var mode: String? = "TALK_AND_MUSIC"
    private fun startAudioShare(call: MethodCall, result: Result) {
        androidAudioShareResult = result
        mode = call.argument<String>("audio_mixing_mode")
        val mediaProjectionManager: MediaProjectionManager = activity.getSystemService(
            Context.MEDIA_PROJECTION_SERVICE
        ) as MediaProjectionManager
        activity.startActivityForResult(
            mediaProjectionManager.createScreenCaptureIntent(),
            Constants.AUDIO_SHARE_INTENT_REQUEST_CODE
        )
    }

    fun requestAudioShare(data: Intent?) {
        if(hmssdk != null){
            hmssdk!!.startAudioshare(
                object : HMSActionResultListener {
                    override fun onError(error: HMSException) {
                        CoroutineScope(Dispatchers.Main).launch {
                            androidAudioShareResult?.success(HMSExceptionExtension.toDictionary(error))
                            androidAudioShareResult = null
                        }
                    }

                    override fun onSuccess() {
                        CoroutineScope(Dispatchers.Main).launch {
                            androidAudioShareResult?.success(null)
                            androidAudioShareResult = null
                        }
                    }
                },
                data,
                audioMixingMode = AudioMixingMode.valueOf(mode!!)
            )
        }
        else{
            Log.e("HMSSDK Error", "requestAudioShare error: hmssdk is null")
        }
    }

    private fun stopAudioShare(result: Result) {
        if(hmssdk != null){
            hmssdk!!.stopAudioshare(HMSCommonAction.getActionListener(result))
        }
        else{
            Log.e("HMSSDK Error", "stopAudioShare error: hmssdk is null")
        }
    }

    private fun setAudioMixingMode(call: MethodCall, result: Result) {
        val mode = call.argument<String>("audio_mixing_mode") ?: returnError("setAudioMixingMode error: mode is null")
        if (mode != null) {
            val audioMixingMode: AudioMixingMode = AudioMixingMode.valueOf(mode as String)
            if(hmssdk != null){
                hmssdk!!.setAudioMixingMode(audioMixingMode)
                result.success(null)
            }
            else{
                Log.e("HMSSDK Error", "setAudioMixingMode error: hmssdk is null")
            }
        }
    }

    private fun getAllTracks(call: MethodCall, result: Result) {

        // Checking peerId as it is required for calling getAllTracks if not present logging respective logs
        val peerId = call.argument<String>("peer_id")?:returnError("getAllTracks error: peerId is null")

        if(peerId != null){
            val peer: HMSPeer? = getPeerById(peerId as String)
            if(peer != null){
                val args = ArrayList<Any>()
                //HMSTrackExtension.toDictionary can return null so adding let check
                peer.getAllTracks().forEach {
                    HMSTrackExtension.toDictionary(it)?.let { it1 -> args.add(it1) }
                }
                result.success(args)
            }
            else{
                Log.e("Null Error","getAllTracks error: No peer exists with peerId:$peerId")
            }
        }
        else{
            Log.e("Null Error","getAllTracks error: peerId is null")
        }
    }

    private fun getTrackById(call: MethodCall, result: Result) {

        // Checking peerId,trackId as they are required for calling getTrackById if not present logging respective logs
        val peerId = call.argument<String>("peer_id")?:returnError("getTrackById error: peerId is null")
        val trackId = call.argument<String>("track_id")?: returnError("getTrackById error: trackId is null")
        if(peerId != null && trackId != null){
            val peer: HMSPeer? = getPeerById(peerId as String)
            if(peer != null){
                result.success(HMSTrackExtension.toDictionary(peer.getTrackById(trackId as String)))
            }
            else{
                Log.e("Null Error","getAllTracks error: No peer exists with peerId:$peerId")
            }
        }
    }

    var hmsVideoViewResult: Result? = null
    private fun captureSnapshot(call: MethodCall, result: Result) {

        // Checking trackId as it is required for calling captureSnapshot if not present logging respective logs
        val trackId = call.argument<String>("track_id")?:returnError("captureSnapshot error: trackId is null")
        if (trackId != null) {
            hmsVideoViewResult = result
            activity.sendBroadcast(Intent(trackId as String).putExtra("method_name", "CAPTURE_SNAPSHOT"))
        }
    }

    private fun setPlaybackAllowedForTrack(call: MethodCall, result: Result) {

        // Checking trackId,isPlaybackAllowed,trackKind as they are required for calling captureSnapshot if not present logging respective logs
        val trackId = call.argument<String>("track_id")?:returnError("setPlaybackAllowedForTrack error: trackId is null")
        val isPlaybackAllowed = call.argument<Boolean>("is_playback_allowed")?:returnError("setPlaybackAllowedForTrack error: isPlaybackAllowed is null")
        val trackKind = call.argument<String>("track_kind")?:returnError("setPlaybackAllowedForTrack error: trackKind is null")

        if(trackId != null && isPlaybackAllowed != null && trackKind != null){
            if(hmssdk != null){
                val room: HMSRoom? = hmssdk!!.getRoom()
                if (room != null) {
                    if (HMSTrackExtension.getKindFromString(trackKind as String)!! == HMSTrackType.AUDIO) {
                        val audioTrack: HMSAudioTrack? = HmsUtilities.getAudioTrack(trackId as String, room)
                        if (audioTrack != null && audioTrack is HMSRemoteAudioTrack) {
                            audioTrack.isPlaybackAllowed = isPlaybackAllowed as Boolean
                            result.success(null)
                            return
                        }
                    } else if (HMSTrackExtension.getKindFromString(trackKind)!! == HMSTrackType.VIDEO) {
                        val videoTrack: HMSVideoTrack? = HmsUtilities.getVideoTrack(trackId as String, room)
                        if (videoTrack != null && videoTrack is HMSRemoteVideoTrack) {
                            videoTrack.isPlaybackAllowed = isPlaybackAllowed as Boolean
                            result.success(null)
                            return
                        }
                    }
                }
            }
            else{
                Log.e("HMSSDK Error", "setPlaybackAllowedForTrack error: hmssdk is null")
            }
        }

        val map = HashMap<String, Map<String, String>>()
        val error = HashMap<String, String>()
        error["message"] = "Could not set isPlaybackAllowed for track"
        error["action"] = "NONE"
        error["description"] = "Check logs for more info"
        map["error"] = error
        result.success(map)
    }

    //Function to log if parameter passed to methods are null
    private fun returnError(errorMessage:String):Unit?{
        Log.e("Null Error",errorMessage)
        return null
    }

    private val hmsStatsListener = object : HMSStatsObserver {

        override fun onRemoteVideoStats(
            videoStats: HMSRemoteVideoStats,
            hmsTrack: HMSTrack?,
            hmsPeer: HMSPeer?
        ) {
            if (hmsPeer == null) {
                Log.e("RemoteVideoStats err", "Peer is null")
                return
            }

            if (hmsTrack == null) {
                Log.e("RemoteVideoStats err", "Video Track is null")
                return
            }

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_remote_video_stats"
            args["data"] = HMSRtcStatsExtension.toDictionary(
                hmsRemoteVideoStats = videoStats,
                peer = hmsPeer,
                track = hmsTrack
            )
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    rtcSink?.success(args)
                }
            }
        }

        override fun onRemoteAudioStats(
            audioStats: HMSRemoteAudioStats,
            hmsTrack: HMSTrack?,
            hmsPeer: HMSPeer?
        ) {
            if (hmsPeer == null) {
                Log.e("RemoteAudioStats err", "Peer is null")
                return
            }

            if (hmsTrack == null) {
                Log.e("RemoteAudioStats err", "Audio Track is null")
                return
            }

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_remote_audio_stats"
            args["data"] = HMSRtcStatsExtension.toDictionary(
                hmsRemoteAudioStats = audioStats,
                peer = hmsPeer,
                track = hmsTrack
            )

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    rtcSink?.success(args)
                }
            }
        }

        override fun onLocalVideoStats(
            videoStats: List<HMSLocalVideoStats>,
            hmsTrack: HMSTrack?,
            hmsPeer: HMSPeer?
        ) {
            if (hmsPeer == null) {
                Log.e("LocalVideoStats err", "Peer is null")
                return
            }

            if (hmsTrack == null) {
                Log.e("LocalVideoStats err", "Video Track is null")
                return
            }

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_local_video_stats"
            args["data"] = HMSRtcStatsExtension.toDictionary(
                hmsLocalVideoStats = videoStats,
                peer = hmsPeer,
                track = hmsTrack
            )

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    rtcSink?.success(args)
                }
            }
        }

        override fun onLocalAudioStats(
            audioStats: HMSLocalAudioStats,
            hmsTrack: HMSTrack?,
            hmsPeer: HMSPeer?
        ) {
            if (hmsPeer == null) {
                Log.e("LocalAudioStats err", "Peer is null")
                return
            }

            if (hmsTrack == null) {
                Log.e("LocalAudioStats err", "Audio Track is null")
                return
            }

            val args = HashMap<String, Any?>()
            args["event_name"] = "on_local_audio_stats"
            args["data"] = HMSRtcStatsExtension.toDictionary(
                hmsLocalAudioStats = audioStats,
                peer = hmsPeer,
                track = hmsTrack
            )

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    rtcSink?.success(args)
                }
            }
        }

        override fun onRTCStats(rtcStats: HMSRTCStatsReport) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_rtc_stats"
            val dict = HashMap<String, Any?>()
            dict["bytes_sent"] = rtcStats.combined.bytesSent
            dict["bytes_received"] = rtcStats.combined.bitrateReceived
            dict["bitrate_sent"] = rtcStats.combined.bitrateSent
            dict["packets_received"] = rtcStats.combined.packetsReceived
            dict["packets_lost"] = rtcStats.combined.packetsLost
            dict["bitrate_received"] = rtcStats.combined.bitrateReceived
            dict["round_trip_time"] = rtcStats.combined.roundTripTime

            args["data"] = dict
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    rtcSink?.success(args)
                }
            }
        }
    }

    private val audioPreviewDeviceChangeListener = object : AudioManagerDeviceChangeListener {
        override fun onAudioDeviceChanged(p0: AudioDevice?, p1: Set<AudioDevice>?) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_audio_device_changed"
            val dict = HashMap<String, Any?>()
            if (p0 != null) {
                dict["current_audio_device"] = p0.name
            }
            if (p1 != null) {
                val audioDevicesList = ArrayList<String>()
                for (device in hmssdk!!.getAudioDevicesList()) {
                    audioDevicesList.add(device.name)
                }
                dict["available_audio_device"] = audioDevicesList
            }
            args["data"] = dict
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }

        override fun onError(e: HMSException?) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_error"
            args["data"] = HMSExceptionExtension.toDictionary(e)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }
    }

    private val audioDeviceChangeListener = object : AudioManagerDeviceChangeListener {
        override fun onAudioDeviceChanged(p0: AudioDevice?, p1: Set<AudioDevice>?) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_audio_device_changed"
            val dict = HashMap<String, Any?>()
            if (p0 != null) {
                dict["current_audio_device"] = p0.name
            }
            if (p1 != null) {
                val audioDevicesList = ArrayList<String>()
                for (device in hmssdk!!.getAudioDevicesList()) {
                    audioDevicesList.add(device.name)
                }
                dict["available_audio_device"] = audioDevicesList
            }
            args["data"] = dict
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onError(e: HMSException?) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_error"
            args["data"] = HMSExceptionExtension.toDictionary(e)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }
    }
}
