package live.hms.hmssdk_flutter

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import com.google.gson.JsonElement
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
import live.hms.hmssdk_flutter.Constants.Companion.METHOD_CALL
import live.hms.hmssdk_flutter.hls_player.HMSHLSPlayerAction
import live.hms.hmssdk_flutter.methods.*
import live.hms.hmssdk_flutter.views.HMSHLSPlayerFactory
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
import live.hms.video.sessionstore.HMSKeyChangeListener
import live.hms.video.sessionstore.HmsSessionStore
import live.hms.video.signal.init.*
import live.hms.video.utils.HMSLogger
import live.hms.video.utils.HmsUtilities

/** HmssdkFlutterPlugin */
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
    private var sessionStoreChannel: EventChannel? = null
    var hlsPlayerChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var previewSink: EventChannel.EventSink? = null
    private var logsSink: EventChannel.EventSink? = null
    private var rtcSink: EventChannel.EventSink? = null
    private var sessionStoreSink: EventChannel.EventSink? = null
    var hlsPlayerSink: EventChannel.EventSink? = null
    private lateinit var activity: Activity
    var hmssdk: HMSSDK? = null
    private lateinit var hmsVideoFactory: HMSVideoViewFactory
    private lateinit var hmsHLSPlayerFactory: HMSHLSPlayerFactory
    private var requestChange: HMSRoleChangeRequest? = null
    var previewForRoleVideoTrack: HMSLocalVideoTrack? = null
    var previewForRoleAudioTrack: HMSLocalAudioTrack? = null
    var hmssdkFlutterPlugin: HmssdkFlutterPlugin? = null
    private var hmsSessionStore: HmsSessionStore? = null
    private var hmsKeyChangeObserverList = ArrayList<HMSKeyChangeObserver>()
    var hlsStreamUrl: String? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
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

            this.sessionStoreChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "session_event_channel")

            this.hlsPlayerChannel =
                EventChannel(flutterPluginBinding.binaryMessenger, "hls_player_channel")

            this.meetingEventChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Meeting event channel not found")
            this.channel?.setMethodCallHandler(this) ?: Log.e("Channel Error", "Event channel not found")
            this.previewChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Preview channel not found")
            this.logsEventChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Logs event channel not found")
            this.rtcStatsChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "RTC Stats channel not found")
            this.sessionStoreChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "Session Store channel not found")
            this.hlsPlayerChannel?.setStreamHandler(this) ?: Log.e("Channel Error", "HLS Player channel not found")
            this.hmsVideoFactory = HMSVideoViewFactory(this)
            this.hmsHLSPlayerFactory = HMSHLSPlayerFactory(this)

            flutterPluginBinding.platformViewRegistry.registerViewFactory(
                "HMSVideoView",
                hmsVideoFactory,
            )

            flutterPluginBinding.platformViewRegistry.registerViewFactory(
                "HMSHLSPlayer",
                hmsHLSPlayerFactory,
            )
            hmssdkFlutterPlugin = this
        } else {
            Log.e("Plugin Warning", "hmssdkFlutterPlugin already exists in onAttachedToEngine")
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            // MARK: Build Actions
            "build", "preview", "join", "leave", "destroy", "get_auth_token_by_room_code" -> {
                buildActions(call, result)
            }

            // MARK: Room Actions
            "get_room", "get_local_peer", "get_remote_peers", "get_peers" -> {
                HMSRoomAction.roomActions(call, result, hmssdk!!)
            }

            // MARK: Audio Helpers
            "switch_audio", "is_audio_mute", "mute_room_audio_locally", "un_mute_room_audio_locally", "set_volume", "toggle_mic_mute_state" -> {
                HMSAudioAction.audioActions(call, result, hmssdk!!, hmssdkFlutterPlugin)
            }

            // MARK: Video Helpers
            "switch_video", "switch_camera", "is_video_mute", "mute_room_video_locally", "un_mute_room_video_locally", "toggle_camera_mute_state" -> {
                HMSVideoAction.videoActions(call, result, hmssdk!!, hmssdkFlutterPlugin)
            }

            // MARK: Messaging
            "send_broadcast_message", "send_direct_message", "send_group_message" -> {
                HMSMessageAction.messageActions(call, result, hmssdk!!)
            }

            // MARK: Role based Actions
            "get_roles", "change_role", "accept_change_role", "end_room", "remove_peer", "on_change_track_state_request", "change_track_state_for_role", "change_role_of_peers_with_roles", "change_role_of_peer", "preview_for_role", "cancel_preview" -> {
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
            "hls_start_streaming", "hls_stop_streaming", "send_hls_timed_metadata" -> {
                HMSHLSAction.hlsActions(call, result, hmssdk!!)
            }

            // MARK: Logger
            "start_hms_logger", "remove_hms_logger", "get_all_logs" -> {
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

            "set_playback_allowed_for_track" -> {
                setPlaybackAllowedForTrack(call, result)
            }
            "enter_pip_mode", "is_pip_active", "is_pip_available", "setup_pip", "destroy_pip" -> {
                HMSPipAction.pipActions(call, result, this.activity)
            }
            "set_simulcast_layer", "get_layer", "get_layer_definition" -> {
                HMSRemoteVideoTrackAction.remoteVideoTrackActions(call, result, hmssdk!!)
            }
            "capture_snapshot" -> {
                captureSnapshot(call, result)
            }
            "is_tap_to_focus_supported", "capture_image_at_max_supported_resolution", "is_zoom_supported", "is_flash_supported", "toggle_flash" -> {
                HMSCameraControlsAction.cameraControlsAction(call, result, hmssdk!!, activity.applicationContext)
            }
            "get_session_metadata_for_key", "set_session_metadata_for_key" -> {
                HMSSessionStoreAction.sessionStoreActions(call, result, hmsSessionStore)
            }
            "add_key_change_listener" -> {
                addKeyChangeListener(call, result)
            }
            "remove_key_change_listener" -> {
                removeKeyChangeListener(call, result)
            }
            "start_hls_player", "stop_hls_player", "pause_hls_player", "resume_hls_player", "seek_to_live_position", "seek_forward", "seek_backward", "set_hls_player_volume", "add_hls_stats_listener", "remove_hls_stats_listener" -> {
                HMSHLSPlayerAction.hlsPlayerAction(call, result, activity)
            }
            "toggle_always_screen_on" -> {
                toggleAlwaysScreenOn(result)
            }
            "get_room_layout" -> {
                getRoomLayout(call, result)
            }
            else -> {
                result.notImplemented()
            }
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
                destroy(result)
            }
            "get_auth_token_by_room_code" -> {
                getAuthTokenByRoomCode(call, result)
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
            "preview_for_role" -> {
                previewForRole(call, result)
            }
            "cancel_preview" -> {
                cancelPreview(result)
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
            "get_all_logs" -> {
                getAllLogs(result)
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
                result.success(hmssdk!!.isScreenShared())
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun statsListenerAction(call: MethodCall, result: Result) {
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
        when (call.method) {
            "get_track_settings" -> {
                result.success(HMSTrackSettingsExtension.toDictionary(hmssdk!!))
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        if (hmssdkFlutterPlugin != null) {
            channel?.setMethodCallHandler(null) ?: Log.e("Channel Error", "Event channel not found")
            meetingEventChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Meeting event channel not found")
            previewChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Preview channel not found")
            logsEventChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Logs event channel not found")
            rtcStatsChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "RTC Stats channel not found")
            sessionStoreChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "Session Store channel not found")
            hlsPlayerChannel?.setStreamHandler(null) ?: Log.e("Channel Error", "HLS Player channel not found")
            eventSink = null
            previewSink = null
            rtcSink = null
            logsSink = null
            sessionStoreSink = null
            hlsPlayerSink = null
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

        hmssdk!!.join(config, this.hmsUpdateListener)
        hmssdk!!.setAudioDeviceChangeListener(audioDeviceChangeListener)
        result.success(null)
    }

    private fun getConfig(
        call: MethodCall,
    ): HMSConfig {
        val userName = call.argument<String>("user_name")
        val authToken = call.argument<String>("auth_token")
        val metaData = call.argument<String>("meta_data") ?: ""
        val endPoint = call.argument<String>("end_point")
        val captureNetworkQualityInPreview = call.argument<Boolean>("capture_network_quality_in_preview") ?: false

        if (endPoint != null && endPoint.isNotEmpty()) {
            return HMSConfig(
                userName = userName!!,
                authtoken = authToken!!,
                metadata = metaData,
                initEndpoint = endPoint.trim(),
                captureNetworkQualityInPreview = captureNetworkQualityInPreview,
            )
        }

        return HMSConfig(
            userName = userName!!,
            authtoken = authToken!!,
            metadata = metaData,
            captureNetworkQualityInPreview = captureNetworkQualityInPreview,
        )
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
        hmssdk!!.leave(hmsActionResultListener = HMSCommonAction.getActionListener(result))
        HMSPipAction.disposePIP(activity)
        removeAllKeyChangeListener()
    }

    private fun destroy(result: Result) {
        hmssdk = null
        result.success(null)
    }

    /**
     *   [toggleAlwaysScreenOn] provides a way to keep the screen always ON
     *   when enabled.
     */
    private fun toggleAlwaysScreenOn(result: Result) {
        activity.window?.let {
            if ((activity.window.attributes.flags and WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) != 0) {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            } else {
                activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            }
        }
        result.success(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        val nameOfEventSink = (arguments as HashMap<String, Any>)["name"]

        if (nameOfEventSink!! == "meeting") {
            this.eventSink = events
        } else if (nameOfEventSink == "preview") {
            this.previewSink = events
        } else if (nameOfEventSink == "logs") {
            this.logsSink = events
        } else if (nameOfEventSink == "rtc_stats") {
            this.rtcSink = events
        } else if (nameOfEventSink == "session_store") {
            this.sessionStoreSink = events
        } else if (nameOfEventSink == "hls_player") {
            this.hlsPlayerSink = events
        }
    }

    override fun onCancel(arguments: Any?) {}

    fun getPeerById(id: String): HMSPeer? {
        if (id == "") return getLocalPeer()
        val peers = hmssdk!!.getPeers()
        peers.forEach {
            if (it.peerID == id) return it
        }

        return null
    }

    private fun getAllTracks(): ArrayList<HMSTrack> {
        val room = hmssdk!!.getRoom()
        val allTracks = ArrayList<HMSTrack>()
        if (room != null) {
            allTracks.addAll(HmsUtilities.getAllAudioTracks(room))
            allTracks.addAll(HmsUtilities.getAllVideoTracks(room))
        }
        return allTracks
    }

    private fun preview(call: MethodCall, result: Result) {
        val config = getConfig(call)
        hmssdk!!.preview(config, this.hmsPreviewListener)
        hmssdk!!.setAudioDeviceChangeListener(audioPreviewDeviceChangeListener)
        result.success(null)
    }

    private fun getAuthTokenByRoomCode(call: MethodCall, result: Result) {
        val roomCode = call.argument<String>("room_code")
        val userId = call.argument<String?>("user_id")
        val endPoint = call.argument<String?>("end_point")
        if (roomCode != null) {
            val tokenRequest = TokenRequest(roomCode, userId)
            hmssdk?.getAuthTokenByRoomCode(tokenRequest, TokenRequestOptions(endPoint), HMSCommonAction.getTokenListener(result))
        } else {
            val hmsException = HMSException(
                action = "Please send a non-null room-code",
                code = 6004,
                description = "Room code is null",
                message = "Room code is null",
                name = "Room code null error",
            )
            val args = HMSExceptionExtension.toDictionary(hmsException)
            result.success(HMSResultExtension.toDictionary(false, args))
        }
    }

    /**
     * [getRoomLayout]  is used to get the layout themes for the room set in the dashboard.
     */
    private fun getRoomLayout(call: MethodCall, result: Result) {
        val authToken = call.argument<String>("auth_token")
        val endpoint = call.argument<String?>("endpoint")

        val layoutRequestOptions = endpoint?.let {
            LayoutRequestOptions(endpoint = endpoint)
        }

        authToken?.let {
            hmssdk!!.getRoomLayout(
                authToken, layoutRequestOptions,
                object : HMSLayoutListener {
                    override fun onError(error: HMSException) {
                        result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.toDictionary(error)))
                    }

                    override fun onLayoutSuccess(layout: HMSRoomLayout) {
                        result.success(HMSResultExtension.toDictionary(true, layout.toString()))
                    }
                },
            )
        } ?: run {
            HMSErrorLogger.returnArgumentsError("authToken parameter is null")
        }
    }

    fun getLocalPeer(): HMSLocalPeer? {
        return hmssdk!!.getLocalPeer()
    }

    private fun changeRole(call: MethodCall, result: Result) {
        val roleUWant = call.argument<String>("role_name")
        val peerId = call.argument<String>("peer_id")
        val forceChange = call.argument<Boolean>("force_change")
        val roles = hmssdk!!.getRoles()
        val roleToChangeTo: HMSRole = roles.first {
            it.name == roleUWant
        }
        val peer = getPeerById(peerId!!) as HMSPeer
        hmssdk!!.changeRole(
            peer,
            roleToChangeTo,
            forceChange ?: false,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    private fun changeRoleOfPeer(call: MethodCall, result: Result) {
        val roleUWant = call.argument<String>("role_name")
        val peerId = call.argument<String>("peer_id")
        val forceChange = call.argument<Boolean>("force_change")
        val roles = hmssdk!!.getRoles()
        val roleToChangeTo: HMSRole = roles.first {
            it.name == roleUWant
        }
        val peer = getPeerById(peerId!!) as HMSPeer
        hmssdk!!.changeRoleOfPeer(
            peer,
            roleToChangeTo,
            forceChange ?: false,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    private fun previewForRole(call: MethodCall, result: Result) {
        val roleName = call.argument<String>("role_name")
        val role = hmssdk?.getRoles()?.first {
            it.name == roleName
        }

        role?.let { hmsRole ->
            hmssdk
                ?.preview(
                    hmsRole,
                    object : RolePreviewListener {
                        override fun onError(error: HMSException) {
                            result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.toDictionary(error)))
                        }

                        override fun onTracks(localTracks: Array<HMSTrack>) {
                            val tracks = ArrayList<Any>()
                            localTracks.forEach { track ->

                                // /Assigning values to preview for role tracks
                                if (track.type == HMSTrackType.AUDIO) {
                                    previewForRoleAudioTrack = track as HMSLocalAudioTrack
                                } else if (track.type == HMSTrackType.VIDEO && track.source == "regular") {
                                    previewForRoleVideoTrack = track as HMSLocalVideoTrack
                                }
                                HMSTrackExtension.toDictionary(track)?.let { tracks.add(it) }
                            }
                            result.success(HMSResultExtension.toDictionary(true, tracks))
                        }
                    },
                )
        }
    }

    private fun cancelPreview(result: Result) {
        hmssdk?.cancelPreview()
        previewForRoleVideoTrack = null
        previewForRoleAudioTrack = null
        result.success(HMSResultExtension.toDictionary(true))
    }

    private fun getRoles(result: Result) {
        val args = HashMap<String, Any?>()

        val roles = ArrayList<Any>()
        hmssdk!!.getRoles().forEach {
            roles.add(HMSRoleExtension.toDictionary(it)!!)
        }
        args["roles"] = roles
        result.success(args)
    }

    private fun acceptChangeRole(result: Result) {
        if (requestChange != null) {
            hmssdk!!.acceptChangeRole(
                this.requestChange!!,
                hmsActionResultListener = HMSCommonAction.getActionListener(result),
            )
            requestChange = null
            previewForRoleVideoTrack = null
            previewForRoleAudioTrack = null
        } else {
            val hmsException = HMSException(
                action = "Resend Role Change Request",
                code = 6004,
                description = "Role Change Request is Expired.",
                message = "Role Change Request is Expired.",
                name = "Role Change Request Error",
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
                HMSLogger.level.toString(),
            )

            if (speakers.isNotEmpty()) {
                speakers.forEach {
                    val hmsSpeakerMap = HMSSpeakerExtension.toDictionary(it)
                    if (hmsSpeakerMap != null) {
                        speakersList.add(hmsSpeakerMap!!)
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
        val trackId = call.argument<String>("track_id")
        val mute = call.argument<Boolean>("mute")

        val tracks = getAllTracks()

        val track = tracks.first {
            it.trackId == trackId
        }

        hmssdk!!.changeTrackState(
            track,
            mute!!,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    private fun removePeer(call: MethodCall, result: Result) {
        val peerId = call.argument<String>("peer_id")

        val peer = getPeerById(peerId!!) as HMSRemotePeer

        val reason = call.argument<String>("reason") ?: "Removed from room"

        hmssdk!!.removePeerRequest(
            peer = peer,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
            reason = reason,
        )
    }

    private fun removeHMSLogger() {
        logsDump.clear()
        logsBuffer.clear()
        HMSLogger.removeInjectedLoggable()
    }

    private fun endRoom(call: MethodCall, result: Result) {
        val lock = call.argument<Boolean>("lock") ?: false
        val reason = call.argument<String>("reason") ?: "End room invoked"
        hmssdk!!.endRoom(
            lock = lock!!,
            reason = reason,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
        HMSPipAction.disposePIP(activity)
        removeAllKeyChangeListener()
    }

    private fun isAllowedToEndMeeting(): Boolean? {
        return hmssdk!!.getLocalPeer()!!.hmsRole.permission?.endRoom
    }

    private fun changeTrackStateForRole(call: MethodCall, result: Result) {
        val mute = call.argument<Boolean>("mute")
        val type = call.argument<String>("type")
        val source = call.argument<String>("source")
        val roles: List<String>? = call.argument<List<String>>("roles")
        val hmsRoles: List<HMSRole>?
        if (roles != null) {
            hmsRoles = hmssdk!!.getRoles().filter { roles?.contains(it.name)!! }
        } else {
            hmsRoles = null
        }
        hmssdk!!.changeTrackState(
            mute = mute!!,
            type = HMSTrackExtension.getKindFromString(type),
            source = source,
            roles = hmsRoles,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    private fun changeRoleOfPeersWithRoles(call: MethodCall, result: Result) {
        val roleString = call.argument<String>("to_role")
        val ofRoleString: List<String>? = call.argument<List<String>>("of_roles")
        val roles = hmssdk!!.getRoles()
        val toRole: HMSRole = roles.first {
            it.name == roleString
        }
        val ofRoles: List<HMSRole> = hmssdk!!.getRoles().filter { ofRoleString!!.contains(it.name) }
        hmssdk!!.changeRoleOfPeersWithRoles(toRole = toRole, ofRoles = ofRoles, hmsActionResultListener = HMSCommonAction.getActionListener(result))
    }

    fun build(activity: Activity, call: MethodCall, result: Result) {
        val dartSDKVersion = call.argument<String>("dart_sdk_version")
        val hmsSDKVersion = call.argument<String>("hmssdk_version")
        val isPrebuilt = call.argument<Boolean>("is_prebuilt") ?: false
        val framework = FrameworkInfo(framework = AgentType.FLUTTER, frameworkVersion = dartSDKVersion, frameworkSdkVersion = hmsSDKVersion, isPrebuilt = isPrebuilt)
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

    private var hasChangedMetadata: Boolean = false

    private fun changeMetadata(call: MethodCall, result: Result) {
        hasChangedMetadata = !hasChangedMetadata
        val metadata = call.argument<String>("metadata")

        hmssdk!!.changeMetadata(
            metadata!!,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    private val hmsUpdateListener = object : HMSUpdateListener {
        override fun onChangeTrackStateRequest(details: HMSChangeTrackStateRequest) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_change_track_state_request")
            args.put("data", HMSChangeTrackStateRequestExtension.toDictionary(details)!!)

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(error))

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onJoin(room: HMSRoom) {
            hmssdk!!.addAudioObserver(hmsAudioListener)

            /**
             * This sets the [hlsStreamUrl] variable to
             * fetch the stream URL directly from onRoomUpdate
             * This helps to play the HLS Stream even if user doesn't send
             * the stream URL.
             */
            room.hlsStreamingState?.let { streamingState ->
                if (streamingState.running) {
                    streamingState.variants?.let { variants ->
                        if (variants.isNotEmpty()) {
                            hlsStreamUrl = variants[0].hlsStreamUrl
                        }
                    }
                }
            }

            val args = HashMap<String, Any?>()
            args.put("event_name", "on_join_room")

            val roomArgs = HashMap<String, Any?>()
            roomArgs.put("room", HMSRoomExtension.toDictionary(room))
            args.put("data", roomArgs)
            if (roomArgs["room"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onMessageReceived(message: HMSMessage) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_message")
            args.put("data", HMSMessageExtension.toDictionary(message))

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {
            /**
             * Since these methods are not part of HMSPeerUpdate enum in flutter
             * We return the method call and don't send update to flutter layer
             */
            if (type == HMSPeerUpdate.BECAME_DOMINANT_SPEAKER || type == HMSPeerUpdate.NO_DOMINANT_SPEAKER) {
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
            /**
             * This sets the [hlsStreamUrl] variable to
             * fetch the stream URL directly from onRoomUpdate
             * This helps to play the HLS Stream even if user doesn't send
             * the stream URL.
             */
            if (type == HMSRoomUpdate.HLS_STREAMING_STATE_UPDATED) {
                hmsRoom.hlsStreamingState?.let { streamingState ->
                    if (streamingState.running) {
                        streamingState.variants?.let { variants ->
                            if (variants.isNotEmpty()) {
                                hlsStreamUrl = variants[0].hlsStreamUrl
                            }
                        }
                    }
                }
            }
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_room_update")
            args.put("data", HMSRoomUpdateExtension.toDictionary(hmsRoom, type))

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onTrackUpdate(type: HMSTrackUpdate, track: HMSTrack, peer: HMSPeer) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_track_update")
            args.put("data", HMSTrackUpdateExtension.toDictionary(peer, track, type))
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onRemovedFromRoom(notification: HMSRemovedFromRoom) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_removed_from_room")
            args.put("data", HMSRemovedFromRoomExtension.toDictionary(notification))
            if (HMSPipAction.isPIPActive(activity)) {
                activity.moveTaskToBack(true)
                HMSPipAction.disposePIP(activity)
                removeAllKeyChangeListener()
            }
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
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
            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }

        override fun onSessionStoreAvailable(sessionStore: HmsSessionStore) {
            val args = HashMap<String, Any?>()
            args["event_name"] = "on_session_store_available"
            args["data"] = null
            hmsSessionStore = sessionStore
            CoroutineScope(Dispatchers.Main).launch {
                eventSink?.success(args)
            }
        }
    }

    private val hmsPreviewListener = object : HMSPreviewListener {
        override fun onError(error: HMSException) {
            val args = HashMap<String, Any?>()
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(error))

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    previewSink?.success(args)
                }
            }
        }

        override fun onPeerUpdate(type: HMSPeerUpdate, peer: HMSPeer) {
            /**
             * Since these methods are not part of HMSPeerUpdate enum in flutter
             * We return the method call and don't send update to flutter layer
             */
            if (type == HMSPeerUpdate.BECAME_DOMINANT_SPEAKER || type == HMSPeerUpdate.NO_DOMINANT_SPEAKER) {
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

    /***
     *This is used to get the logs from the Native SDK
     * Here to avoid choking of the platform channel we batch the logs in group of 1000
     * and then send the update to the application.
     * If a user requires all the logs at any moment then [getAllLogs] method can be used.
     * Here [logsBuffer] is used to maintain the 512 logs list
     * while [logsDump] contains all the logs of the session if a user calls [getAllLogs] we
     * send the [logsDump] through the platform channel
     * ***/
    var logsBuffer = mutableListOf<Any?>()
    var logsDump = mutableListOf<Any?>()
    private val hmsLoggerListener = object : HMSLogger.Loggable {
        override fun onLogMessage(
            level: HMSLogger.LogLevel,
            tag: String,
            message: String,
            isWebRtCLog: Boolean,
        ) {
            /***
             * Here we filter the logs based on the level we have set
             * while calling [startHMSLogger]
             ***/
            if (isWebRtCLog && level != HMSLogger.webRtcLogLevel) return
            if (level != HMSLogger.level) return

            logsBuffer.add(message)
            logsDump.add(message)
            if (logsBuffer.size >= 512) {
                val copyLogBuffer = mutableListOf<Any?>()
                val args = HashMap<String, Any?>()
                args["event_name"] = "on_logs_update"
                copyLogBuffer.addAll(logsBuffer)
                args["data"] = copyLogBuffer
                CoroutineScope(Dispatchers.Main).launch {
                    logsSink?.success(args)
                    copyLogBuffer.clear()
                    logsBuffer.clear()
                }
            }
        }
    }

    private fun getAllLogs(result: Result) {
        result.success(logsDump)
        logsBuffer.clear()
    }

    private fun changeName(call: MethodCall, result: Result) {
        val name = call.argument<String>("name")
        hmssdk!!.changeName(
            name = name!!,
            hmsActionResultListener = HMSCommonAction.getActionListener(result),
        )
    }

    fun onVideoViewError(methodName: String, error: String, errorMessage: String) {
        val args = HashMap<String, Any?>()
        args["event_name"] = "on_error"
        val hmsException = HMSException(
            action = "Check the logs for more info",
            code = 6004,
            description = error,
            message = errorMessage,
            name = "$methodName Error",
        )
        args["data"] = HMSExceptionExtension.toDictionary(hmsException)
        CoroutineScope(Dispatchers.Main).launch {
            eventSink?.success(args)
        }
    }

    private var androidScreenshareResult: Result? = null
    private fun startScreenShare(result: Result) {
        androidScreenshareResult = result
        activity.applicationContext?.registerReceiver(activityBroadcastReceiver, IntentFilter("ACTIVITY_RECEIVER"))
        val mediaProjectionManager: MediaProjectionManager = activity.getSystemService(
            Context.MEDIA_PROJECTION_SERVICE,
        ) as MediaProjectionManager
        activity.startActivityForResult(
            mediaProjectionManager.createScreenCaptureIntent(),
            Constants.SCREEN_SHARE_INTENT_REQUEST_CODE,
        )
    }

    private val activityBroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "ACTIVITY_RECEIVER") {
                when (intent.extras?.getString("method_name")) {
                    "REQUEST_SCREEN_SHARE" -> {
                        requestScreenShare(intent)
                    }
                    "REQUEST_AUDIO_SHARE" -> {
                        requestAudioShare(intent)
                    }
                }
            }
        }
    }

    private fun requestScreenShare(data: Intent?) {
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
            data,
        )
        activity.applicationContext?.unregisterReceiver(activityBroadcastReceiver)
    }

    private fun stopScreenShare(result: Result) {
        hmssdk!!.stopScreenshare(HMSCommonAction.getActionListener(result))
    }

    private var androidAudioShareResult: Result? = null
    private var mode: String? = "TALK_AND_MUSIC"
    private fun startAudioShare(call: MethodCall, result: Result) {
        androidAudioShareResult = result
        mode = call.argument<String>("audio_mixing_mode")
        activity.applicationContext?.registerReceiver(activityBroadcastReceiver, IntentFilter("ACTIVITY_RECEIVER"))
        val mediaProjectionManager: MediaProjectionManager? = activity.getSystemService(
            Context.MEDIA_PROJECTION_SERVICE,
        ) as MediaProjectionManager
        activity.startActivityForResult(
            mediaProjectionManager?.createScreenCaptureIntent(),
            Constants.AUDIO_SHARE_INTENT_REQUEST_CODE,
        )
    }

    private fun requestAudioShare(data: Intent?) {
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
            audioMixingMode = AudioMixingMode.valueOf(mode!!),
        )
        activity.applicationContext?.unregisterReceiver(activityBroadcastReceiver)
    }

    private fun stopAudioShare(result: Result) {
        hmssdk!!.stopAudioshare(HMSCommonAction.getActionListener(result))
    }

    private fun setAudioMixingMode(call: MethodCall, result: Result) {
        val mode = call.argument<String>("audio_mixing_mode")
        if (mode != null) {
            val audioMixingMode: AudioMixingMode = AudioMixingMode.valueOf(mode)
            hmssdk!!.setAudioMixingMode(audioMixingMode)
        }
    }

    private fun getAllTracks(call: MethodCall, result: Result) {
        val peerId: String? = call.argument<String>("peer_id")
        val peer: HMSPeer? = getPeerById(peerId!!)

        val args = ArrayList<Any>()

        peer?.getAllTracks()?.forEach {
            args.add(HMSTrackExtension.toDictionary(it)!!)
        }
        result.success(args)
    }

    private fun getTrackById(call: MethodCall, result: Result) {
        val peerId: String? = call.argument<String>("peer_id")
        val trackId: String? = call.argument<String>("track_id")
        val peer: HMSPeer? = getPeerById(peerId!!)
        result.success(HMSTrackExtension.toDictionary(peer?.getTrackById(trackId!!)))
    }

    var hmsVideoViewResult: Result? = null
    private fun captureSnapshot(call: MethodCall, result: Result) {
        val trackId: String? = call.argument<String>("track_id")
        if (trackId != null) {
            hmsVideoViewResult = result
            activity.sendBroadcast(Intent(trackId).putExtra(METHOD_CALL, "CAPTURE_SNAPSHOT"))
        }
    }

    private fun setPlaybackAllowedForTrack(call: MethodCall, result: Result) {
        val trackId = call.argument<String>("track_id")
        val isPlaybackAllowed: Boolean = call.argument<String>("is_playback_allowed") as Boolean
        val trackKind = call.argument<String>("track_kind")

        val room: HMSRoom? = hmssdk?.getRoom()

        if (room != null && trackId != null) {
            if (HMSTrackExtension.getKindFromString(trackKind)!! == HMSTrackType.AUDIO) {
                val audioTrack: HMSAudioTrack? = HmsUtilities.getAudioTrack(trackId, room)
                if (audioTrack != null && audioTrack is HMSRemoteAudioTrack) {
                    audioTrack.isPlaybackAllowed = isPlaybackAllowed
                    result.success(null)
                    return
                }
            } else if (HMSTrackExtension.getKindFromString(trackKind)!! == HMSTrackType.VIDEO) {
                val videoTrack: HMSVideoTrack? = HmsUtilities.getVideoTrack(trackId, room)
                if (videoTrack != null && videoTrack is HMSRemoteVideoTrack) {
                    videoTrack.isPlaybackAllowed = isPlaybackAllowed
                    result.success(null)
                    return
                }
            }
        }

        val map = HashMap<String, Map<String, String>>()
        val error = HashMap<String, String>()
        error["message"] = "Could not set isPlaybackAllowed for track"
        error["action"] = "NONE"
        error["description"] = "Track not found to set isPlaybackAllowed"
        map["error"] = error
        result.success(map)
    }

    /**
     *  This method is used to add key change listener for
     *  keys passed while calling this method
     *
     *  Parameters:
     *  - keys: List<String> List of keys for which metadata updates need to be listened.
     *  - keyChangeListener: Instance of HMSKeyChangeListener to listen to the metadata changes for corresponding keys
     *  - hmsActionResultListener: Instance of HMSActionResultListener to notify success or failure of the method call
     */
    private fun addKeyChangeListener(call: MethodCall, result: Result) {
        val keys = call.argument<List<String>>("keys") ?: run {
            HMSErrorLogger.returnArgumentsError("keys parameter is null")
        }

        val uid = call.argument<String>("uid") ?: run {
            HMSErrorLogger.returnArgumentsError("uid is null")
        }

        uid?.let {
            val keyChangeListener = object : HMSKeyChangeListener {
                override fun onKeyChanged(key: String, value: JsonElement?) {
                    val args = HashMap<String, Any?>()
                    args["event_name"] = "on_key_changed"
                    val newData = HashMap<String, String?>()
                    newData["key"] = key

                    /**
                     * Here depending on the value we parse the JsonElement
                     * if it's a JsonPrimitive we parse it as String and then send to flutter
                     * if it's a JsonObject,JsonArray we convert it to String and then send to flutter
                     * if it's a JsonNull we send it as null
                     */

                    value?.let {
                        if (it.isJsonPrimitive) {
                            newData["value"] = value.asString
                        } else if (it.isJsonNull) {
                            newData["value"] = null
                        } else {
                            newData["value"] = value.toString()
                        }
                    } ?: run {
                        newData["value"] = null
                    }

                    newData["uid"] = uid as String
                    args["data"] = newData
                    CoroutineScope(Dispatchers.Main).launch {
                        sessionStoreSink?.success(args)
                    }
                }
            }
            hmsKeyChangeObserverList.add(HMSKeyChangeObserver(uid as String, keyChangeListener))
            keys.let {
                keys as List<String>
                hmsSessionStore?.addKeyChangeListener(keys, keyChangeListener, HMSCommonAction.getActionListener(result))
            }
        }
    }

    /***
     * This method is used to remove the attached key change listeners
     * attached using [addKeyChangeListener] method
     */
    private fun removeKeyChangeListener(call: MethodCall, result: Result) {
        val uid = call.argument<String>("uid") ?: run {
            HMSErrorLogger.returnArgumentsError("uid is null")
        }
        // There is no need to call removeKeyChangeListener since
        // there is no keyChangeListener attached
        if (hmsKeyChangeObserverList.isEmpty()) {
            result.success(HMSResultExtension.toDictionary(true, null))
            return
        }

        uid?.let {
            hmsKeyChangeObserverList.forEach {
                    hmsKeyChangeObserver ->
                if (hmsKeyChangeObserver.uid == uid) {
                    hmsSessionStore?.removeKeyChangeListener(hmsKeyChangeObserver.keyChangeListener)
                    hmsKeyChangeObserverList.remove(hmsKeyChangeObserver)
                    result.success(HMSResultExtension.toDictionary(true, null))
                    return
                }
            }
        } ?: run {
            result.success(HMSResultExtension.toDictionary(false, "keyChangeListener uid is null"))
        }
    }

    /**
     * This method removes all the key change listeners attached during the session
     * This is used while cleaning the room state i.e after calling leave room,
     * onRemovedFromRoom or endRoom
     */
    private fun removeAllKeyChangeListener() {
        hmsKeyChangeObserverList.forEach {
                hmsKeyChangeObserver ->
            hmsSessionStore?.removeKeyChangeListener(hmsKeyChangeObserver.keyChangeListener)
        }
        hmsKeyChangeObserverList.clear()
    }

    private val hmsStatsListener = object : HMSStatsObserver {

        override fun onRemoteVideoStats(
            videoStats: HMSRemoteVideoStats,
            hmsTrack: HMSTrack?,
            hmsPeer: HMSPeer?,
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
                track = hmsTrack,
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
            hmsPeer: HMSPeer?,
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
                track = hmsTrack,
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
            hmsPeer: HMSPeer?,
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
                track = hmsTrack,
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
            hmsPeer: HMSPeer?,
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
                track = hmsTrack,
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
                hmssdk?.getAudioDevicesList()?.let { audioDevices ->
                    audioDevices.forEach { device ->
                        audioDevicesList.add(device.name)
                    }
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
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(e))

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
                hmssdk?.getAudioDevicesList()?.let { audioDevices ->
                    audioDevices.forEach { device ->
                        audioDevicesList.add(device.name)
                    }
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
            args.put("event_name", "on_error")
            args.put("data", HMSExceptionExtension.toDictionary(e))

            if (args["data"] != null) {
                CoroutineScope(Dispatchers.Main).launch {
                    eventSink?.success(args)
                }
            }
        }
    }
}
