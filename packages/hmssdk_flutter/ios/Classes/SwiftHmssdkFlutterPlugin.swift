import Flutter
import UIKit
import HMSSDK
import ReplayKit
import AVKit
import MediaPlayer
import SwiftUI
import HMSAnalyticsSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener, FlutterStreamHandler, HMSPreviewListener, HMSLogger {

    var channel: FlutterMethodChannel?
    var meetingEventChannel: FlutterEventChannel?
    var previewEventChannel: FlutterEventChannel?
    var logsEventChannel: FlutterEventChannel?
    var rtcStatsEventChannel: FlutterEventChannel?
    var sessionEventChannel: FlutterEventChannel?
    var hlsPlayerChannel: FlutterEventChannel?
    var pollsEventChannel: FlutterEventChannel?
    var whiteboardEventChannel: FlutterEventChannel?

    var eventSink: FlutterEventSink?
    var previewSink: FlutterEventSink?
    var logsSink: FlutterEventSink?
    var rtcSink: FlutterEventSink?
    var sessionSink: FlutterEventSink?
    var hlsPlayerSink: FlutterEventSink?
    var pollsEventSink: FlutterEventSink?
    var whiteboardEventSink: FlutterEventSink?

    var roleChangeRequest: HMSRoleChangeRequest?

    var previewForRoleVideoTrack: HMSLocalVideoTrack?

    var previewForRoleAudioTrack: HMSLocalAudioTrack?

    internal var hmsSDK: HMSSDK?

    private var isStatsActive = false

    internal var sessionStore: HMSSessionStore?

    private var sessionStoreChangeObservers = [HMSSessionStoreKeyChangeListener]()

    var hlsStreamUrl: String?

    private var isRoomAudioUnmutedLocally = true
    

    // MARK: - Flutter Setup

    public static func register(with registrar: FlutterPluginRegistrar) {

        let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())

        let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
        let previewChannel = FlutterEventChannel(name: "preview_event_channel", binaryMessenger: registrar.messenger())
        let logsChannel = FlutterEventChannel(name: "logs_event_channel", binaryMessenger: registrar.messenger())
        let rtcChannel = FlutterEventChannel(name: "rtc_event_channel", binaryMessenger: registrar.messenger())
        let sessionChannel = FlutterEventChannel(name: "session_event_channel", binaryMessenger: registrar.messenger())
        let hlsChannel = FlutterEventChannel(name: "hls_player_channel", binaryMessenger: registrar.messenger())
        let pollsChannel = FlutterEventChannel(name: "polls_event_channel", binaryMessenger: registrar.messenger())
        let whiteboardChannel = FlutterEventChannel(name: "whiteboard_event_channel", binaryMessenger: registrar.messenger())

        let instance = SwiftHmssdkFlutterPlugin(channel: channel,
                                                meetingEventChannel: eventChannel,
                                                previewEventChannel: previewChannel,
                                                logsEventChannel: logsChannel,
                                                rtcStatsEventChannel: rtcChannel,
                                                sessionEventChannel: sessionChannel,
                                                hlsPlayerChannel: hlsChannel,
                                                pollsEventChannel: pollsChannel,
                                                whiteboardEventChannel: whiteboardChannel)

        let videoViewFactory = HMSFlutterPlatformViewFactory(plugin: instance)
        registrar.register(videoViewFactory, withId: "HMSFlutterPlatformView")

        let hlsPlayerFactory = HMSHLSPlayerViewFactory(plugin: instance)
        registrar.register(hlsPlayerFactory, withId: "HMSHLSPlayer")

        eventChannel.setStreamHandler(instance)
        previewChannel.setStreamHandler(instance)
        logsChannel.setStreamHandler(instance)
        rtcChannel.setStreamHandler(instance)
        sessionChannel.setStreamHandler(instance)
        hlsChannel.setStreamHandler(instance)
        pollsChannel.setStreamHandler(instance)
        whiteboardChannel.setStreamHandler(instance)

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public init(channel: FlutterMethodChannel,
                meetingEventChannel: FlutterEventChannel,
                previewEventChannel: FlutterEventChannel,
                logsEventChannel: FlutterEventChannel,
                rtcStatsEventChannel: FlutterEventChannel,
                sessionEventChannel: FlutterEventChannel,
                hlsPlayerChannel: FlutterEventChannel,
                pollsEventChannel: FlutterEventChannel,
                whiteboardEventChannel: FlutterEventChannel) {

        self.channel = channel
        self.meetingEventChannel = meetingEventChannel
        self.previewEventChannel = previewEventChannel
        self.logsEventChannel = logsEventChannel
        self.rtcStatsEventChannel = rtcStatsEventChannel
        self.sessionEventChannel = sessionEventChannel
        self.hlsPlayerChannel = hlsPlayerChannel
        self.pollsEventChannel = pollsEventChannel
        self.whiteboardEventChannel = whiteboardEventChannel
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {

        guard let tempArg = arguments as? [AnyHashable: Any],
              let name =  tempArg["name"] as? String else {
            return FlutterError(code: #function, message: "invalid event sink name", details: arguments)
        }

        switch name {
        case "meeting":
            eventSink = events
        case "preview":
            previewSink = events
        case "logs":
            logsSink = events
        case "rtc_stats":
            rtcSink = events
        case "session_store":
            sessionSink = events
        case "hls_player":
            hlsPlayerSink = events
        case "polls":
            pollsEventSink = events
        case "whiteboard":
            whiteboardEventSink = events
        default:
            return FlutterError(code: #function, message: "invalid event sink name", details: arguments)
        }

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        if meetingEventChannel != nil {
            meetingEventChannel!.setStreamHandler(nil)
            eventSink = nil
        } else {
            print(#function, "meetingEventChannel not found")
        }
        if previewEventChannel != nil {
            previewEventChannel!.setStreamHandler(nil)
            previewSink = nil
        } else {
            print(#function, "previewEventChannel not found")
        }
        if logsEventChannel != nil {
            logsEventChannel!.setStreamHandler(nil)
            logsSink = nil
        } else {
            print(#function, "logsEventChannel not found")
        }
        if rtcStatsEventChannel != nil {
            rtcStatsEventChannel!.setStreamHandler(nil)
            rtcSink = nil
        } else {
            print(#function, "rtcStatsEventChannel not found")
        }
        if sessionEventChannel != nil {
            sessionEventChannel!.setStreamHandler(nil)
            sessionSink = nil
        } else {
            print(#function, "sessionEventChannel not found")
        }
        if hlsPlayerChannel != nil {
            hlsPlayerChannel!.setStreamHandler(nil)
            hlsPlayerSink = nil
        } else {
            print(#function, "hlsPlayerChannel not found")
        }
        if pollsEventChannel != nil {
            pollsEventChannel!.setStreamHandler(nil)
            pollsEventSink = nil
        } else {
            print(#function, "pollsEventChannel not found")
        }
        if whiteboardEventChannel != nil {
            whiteboardEventChannel!.setStreamHandler(nil)
            whiteboardEventSink = nil
        } else {
            print(#function, "whiteboardEventChannel not found")
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        switch call.method {

            // MARK: Room Actions

        case "build", "preview", "join", "leave", "destroy", "get_auth_token_by_room_code":
            buildActions(call, result)

            // MARK: Room Actions

        case "get_room", "get_local_peer", "get_remote_peers", "get_peers":
            HMSRoomAction.roomActions(call, result, hmsSDK)

            // MARK: - Audio Helpers

        case "switch_audio", "is_audio_mute", "mute_room_audio_locally", "un_mute_room_audio_locally", "set_volume", "toggle_mic_mute_state":
            HMSAudioAction.audioActions(call, result, hmsSDK, self)

        case "set_playback_allowed_for_track":
            setPlaybackAllowedForTrack(call, result)

            // MARK: - Video Helpers

        case "switch_video", "switch_camera", "is_video_mute", "mute_room_video_locally", "un_mute_room_video_locally", "toggle_camera_mute_state":
            HMSVideoAction.videoActions(call, result, hmsSDK, self)

            // MARK: - Messaging

        case "send_broadcast_message", "send_direct_message", "send_group_message":
            HMSMessageAction.messageActions(call, result, hmsSDK)

            // MARK: - Role based Actions

        case "get_roles", "change_role", "accept_change_role", "end_room", "remove_peer", "on_change_track_state_request", "change_track_state_for_role", "change_role_of_peers_with_roles", "change_role_of_peer", "preview_for_role", "cancel_preview":
            roleActions(call, result)

            // MARK: - Peer Action
        case "change_metadata", "change_name", "raise_local_peer_hand", "lower_local_peer_hand", "lower_remote_peer_hand":
            HMSPeerAction.peerActions(call, result, hmsSDK)

            // MARK: - RTMP

        case "start_rtmp_or_recording", "stop_rtmp_and_recording":
            HMSRecordingAction.recordingActions(call, result, hmsSDK)

            // MARK: - HLS

        case "hls_start_streaming", "hls_stop_streaming", "send_hls_timed_metadata":
            HMSHLSAction.hlsActions(call, result, hmsSDK)

            // MARK: - Logging

        case "start_hms_logger", "remove_hms_logger", "get_all_logs":
            loggingActions(call, result)

            // MARK: - Stats Listener

        case "start_stats_listener", "remove_stats_listener":
            statsListenerAction(call, result)

            // MARK: - Screen Share

        case "start_screen_share", "stop_screen_share", "is_screen_share_active":
            screenShareActions(call, result)

            // MARK: - Track Settings

        case "get_track_settings":
            trackSettingsAction(call, result)
            break

            // MARK: - Local Audio Share

        case "play_audio_share", "stop_audio_share", "pause_audio_share", "resume_audio_share", "set_audio_share_volume", "audio_share_playing", "audio_share_current_time", "audio_share_duration":
            audioShareAction(call, result)

            // MARK: - Switch Audio Output

        case "switch_audio_output", "get_audio_devices_list", "switch_audio_output_using_ios_ui":
            HMSAudioDeviceAction.audioActions(call, result, hmsSDK)

            // MARK: - Simulcast

        case "set_simulcast_layer", "get_layer", "get_layer_definition":
            HMSRemoteVideoTrackExtension.remoteVideoTrackActions(call, result, hmsSDK!)

            // MARK: - PIP Mode

        case "setup_pip", "start_pip", "stop_pip", "is_pip_available", "is_pip_active", "change_track_pip", "change_text_pip", "destroy_pip":
            guard #available(iOS 15.0, *) else {
                print(#function, HMSErrorExtension.getError("iOS 15 or above is required"))
                        result(HMSErrorExtension.getError("iOS 15 or above is required"))
                        return }
            HMSPIPAction.pipAction(call, result, hmsSDK, self)

            // MARK: - Capture HMSVideoView Snapshot

        case "capture_snapshot":
            captureSnapshot(call, result)

            // MARK: - Advanced Camera Controls

        case "capture_image_at_max_supported_resolution", "is_tap_to_focus_supported", "is_zoom_supported", "is_flash_supported", "toggle_flash":
            HMSCameraControlsAction.cameraControlsAction(call, result, hmsSDK)

            // MARK: - Session Store

        case "get_session_metadata_for_key", "set_session_metadata_for_key":
            HMSSessionStoreAction.sessionStoreActions(call, result, self)

        case "add_key_change_listener":
            addKeyChangeListener(call, result)

        case "remove_key_change_listener":
            removeKeyChangeListener(call, result)

            // MARK: - HLS Player

        case "start_hls_player", "stop_hls_player", "pause_hls_player", "resume_hls_player", "seek_to_live_position", "seek_forward", "seek_backward", "set_hls_player_volume", "add_hls_stats_listener", "remove_hls_stats_listener", "are_closed_captions_supported", "enable_closed_captions", "disable_closed_captions", "get_stream_properties",
            "get_hls_layers", "set_hls_layer", "get_current_hls_layer":
            HMSHLSPlayerAction.hlsPlayerAction(call, result)

        case "toggle_always_screen_on":
            toggleAlwaysScreenOn(result)

        case "get_room_layout":
            getRoomLayout(call, result)

           // MARK: - Large room APIs
        case "get_peer_list_iterator", "peer_list_iterator_has_next", "peer_list_iterator_next":
            HMSPeerListIteratorAction.peerListIteratorAction(call, result, hmsSDK)

           // MARK: - Polls

        case "add_poll_update_listener", "remove_poll_update_listener", "quick_start_poll", "add_single_choice_poll_response", "add_multi_choice_poll_response", "stop_poll", "fetch_leaderboard", "fetch_poll_list", "fetch_poll_questions", "get_poll_results":
            pollsAction(call, result)

          // MARK: - Noise Cancellation
        case "enable_noise_cancellation", "disable_noise_cancellation", "is_noise_cancellation_enabled", "is_noise_cancellation_available":
            HMSNoiseCancellationController.noiseCancellationActions(call, result)

        case "start_whiteboard", "stop_whiteboard", "add_whiteboard_update_listener", "remove_whiteboard_update_listener":
            whiteboardActions(call, result)

        case "enable_virtual_background", "disable_virtual_background", "enable_blur_background", "disable_blur_background", "change_virtual_background", "is_virtual_background_supported":
            vbAction.performActions(call, result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private lazy var vbAction: HMSVirtualBackgroundAction = {
       HMSVirtualBackgroundAction()
    }()

    // MARK: - Build Actions
    private func buildActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "build":
            build(call, result)

        case "preview":
            preview(call, result)

        case "join":
            join(call, result)

        case "leave":
            leave(result)

        case "destroy":
            destroy(result)

        case "get_auth_token_by_room_code":
            getAuthTokenByRoomCode(call, result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Role based Actions
    private func roleActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "get_roles":
            getRoles(call, result)

        case "change_role":
            changeRole(call, result)

        case "accept_change_role":
            acceptChangeRole(result)

        case "end_room":
            endRoom(call, result)

        case "remove_peer":
            removePeer(call, result)

        case "on_change_track_state_request":
            changeTrackState(call, result)

        case "change_track_state_for_role":
            changeTrackStateForRole(call, result)

        case "change_role_of_peers_with_roles":
            changeRoleOfPeersWithRoles(call, result)

        case "change_role_of_peer":
            changeRole(call, result)

        case "preview_for_role":
            previewForRole(call, result)

        case "cancel_preview":
            cancelPreview(result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Logging
    private func loggingActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "start_hms_logger":
            startHMSLogger(call)

        case "remove_hms_logger":
            removeHMSLogger()

        case "get_all_logs":
            getAllLogs(result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Stats Listener

    private func statsListenerAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {

        case "start_stats_listener":
            isStatsActive = true

        case "remove_stats_listener":
            isStatsActive = false

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    var currentPolls = [HMSPoll]()
    private func pollsAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "add_poll_update_listener":
            let listener: HMSInteractivityCenter.HMSPollListener = { [weak self] hmsPoll, hmsPollUpdateType in

                guard let self = self else { return }

                let map = ["event_name": "on_poll_update",
                "data": [
                    "poll": HMSPollExtension.toDictionary(poll: hmsPoll),
                    "poll_update_type": HMSPollExtension.getPollUpdateType(updateType: hmsPollUpdateType)
                    ]
                ] as [String: Any]
                if hmsPollUpdateType == .started {
                    currentPolls.append(hmsPoll)
                } else if hmsPollUpdateType == .stopped {
                    currentPolls.removeAll(where: {
                        $0.pollID == hmsPoll.pollID
                    })
                } else if hmsPollUpdateType == .resultsUpdated {
                    if let index = currentPolls.firstIndex(where: {$0.pollID == hmsPoll.pollID}) {
                        currentPolls[index] = hmsPoll
                    }
                }
                self.pollsEventSink?(map)
            }
            hmsSDK?.interactivityCenter.addPollUpdateListner(listener)
            break
        case "remove_poll_update_listener":
            break
        default:
            HMSPollAction.pollActions(call, result, hmsSDK, currentPolls)
        }
    }

    private func whiteboardActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "add_whiteboard_update_listener":

            let whiteboardListener: HMSInteractivityCenter.HMSWhiteboardUpdateListener = { [weak self] hmsWhiteboard, hmsWhiteBoardUpdateType in

                guard let self = self else {return}

                switch hmsWhiteBoardUpdateType {

                case .started:
                    let args = [
                        "event_name": "on_whiteboard_start",
                        "data": HMSWhiteboardExtension.toDictionary(hmsWhiteboard: hmsWhiteboard, hmsSDK: hmsSDK)
                    ]
                    self.whiteboardEventSink?(args)
                    break
                case .stopped:
                    let args = [
                        "event_name": "on_whiteboard_stop",
                        "data": HMSWhiteboardExtension.toDictionary(hmsWhiteboard: hmsWhiteboard, hmsSDK: hmsSDK)
                    ]
                    self.whiteboardEventSink?(args)
                    break
                default:
                    break
                }
            }
            hmsSDK?.interactivityCenter.addWhiteboardUpdateListener(whiteboardListener)
        case "remove_whiteboard_update_listener":
            break
        default:
            HMSWhiteboardAction.whiteboardActions(call, result, hmsSDK)
        }
    }

    // MARK: - Track Setting
    var audioMixerSourceMap = [String: HMSAudioNode]()
    private func trackSettingsAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "get_track_settings":
            result(HMSTrackSettingsExtension.toDictionary(hmsSDK!, audioMixerSourceMap))
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Audio Share

    private func audioShareAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        if let audioNode = audioMixerSourceMap[arguments["name"] as! String] {
            switch call.method {
            case "play_audio_share":
                HMSAudioFilePlayerNodeExtension.play(arguments, audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "stop_audio_share":
                HMSAudioFilePlayerNodeExtension.stop(audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "pause_audio_share":
                HMSAudioFilePlayerNodeExtension.pause(audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "resume_audio_share":
                HMSAudioFilePlayerNodeExtension.resume(audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "set_audio_share_volume":
                if arguments["name"] as! String != "mic_node" {
                    HMSAudioFilePlayerNodeExtension.setVolume(arguments, audioNode as! HMSAudioFilePlayerNode, result)
                } else {
                    HMSMicNodeExtension.setVolume(arguments, audioNode as! HMSMicNode)
                }
                break
            case "audio_share_playing":
                HMSAudioFilePlayerNodeExtension.isPlaying(audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "audio_share_current_time":
                HMSAudioFilePlayerNodeExtension.currentDuration(audioNode as! HMSAudioFilePlayerNode, result)
                break
            case "audio_share_duration":
                HMSAudioFilePlayerNodeExtension.duration(audioNode as! HMSAudioFilePlayerNode, result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - Screen Share
    var isScreenShareOn = false {
        didSet {
            screenShareActionResult?(nil)
            screenShareActionResult = nil
        }
    }
    var preferredExtension: String?
    var systemBroadcastPicker: RPSystemBroadcastPickerView?
    var screenShareActionResult: FlutterResult?

    private func screenShareActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        switch call.method {
        case "start_screen_share", "stop_screen_share":
            guard let preferredExtension = preferredExtension else {
                result(HMSErrorExtension.getError("Could not start Screen share, preferredExtension not passed in Build Method in \(#function)"))
                screenShareActionResult = nil
                return
            }

            screenShareActionResult = result

            if systemBroadcastPicker == nil {
                systemBroadcastPicker = RPSystemBroadcastPickerView()
                systemBroadcastPicker!.preferredExtension = preferredExtension
                systemBroadcastPicker!.showsMicrophoneButton = false
            }

            for view in systemBroadcastPicker!.subviews {
                if let button = view as? UIButton {
                    button.sendActions(for: .allEvents)
                }
            }

        case "is_screen_share_active":
            result(isScreenShareOn)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Session Store

    /**
     *  This method is used to add key change listener for
     *  keys passed while calling this method
     *
     *  Parameters:
     *  - keys: List<String> List of keys for which metadata updates need to be listened.
     *  - keyChangeListener: Instance of HMSKeyChangeListener to listen to the metadata changes for corresponding keys
     */
    private func addKeyChangeListener(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let store = sessionStore
        else {
            HMSErrorLogger.logError(#function, "Session Store is null", "NULL ERROR")
            result(HMSErrorExtension.getError("Session Store is null"))
            return
        }

        guard let arguments = call.arguments as? [AnyHashable: Any]
        else {
            HMSErrorLogger.returnArgumentsError("keys is null")
            result(HMSErrorExtension.getError("No arguments passed which can be attached to Key Change Listener on the Session Store."))
            return
        }

        guard let keys = arguments["keys"] as? [String]
        else {
            HMSErrorLogger.logError(#function, "No keys passed which can be attached to Key Change Listener on the Session Store. Available arguments: \(arguments)", "NULL ERROR")
            result(HMSErrorExtension.getError("No keys passed which can be attached to Key Change Listener on the Session Store. Available arguments: \(arguments)"))
            return
        }

        guard let uid = arguments["uid"] as? String
        else {
                HMSErrorLogger.logError(#function, "No uid passed for key change listener Available arguments: \(arguments)", "NULL ERROR")
                result(HMSErrorExtension.getError("No uid passed for key change listener Available arguments: \(arguments)"))
            return
        }

        store.observeChanges(forKeys: keys, changeObserver: { [weak self] key, value in

            var data = [String: Any]()

            data["event_name"] = "on_key_changed"

            var dict: [String: Any] = ["key": key]

            do {
                let isValid = try JSONSerialization.isValidJSONObject(value)
                if isValid {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        dict["value"] = jsonString
                    } else {
                        HMSErrorLogger.logError(#function, "Session metadata type is not compatible, Please use String? type while setting metadata", "Type Incompatibility Error")
                        dict["value"] = nil
                    }
                } else {
                    if let intValue = value as? Int {
                        let stringValue = String(intValue)
                        dict["value"] = stringValue
                    } else if let doubleValue = value as? Double {
                        let doubleValue = String(doubleValue)
                        dict["value"] = doubleValue
                    } else if let stringValue = value as? String {
                        dict["value"] = stringValue
                    } else if let boolValue = value as? Bool {
                        dict["value"] = String(boolValue)
                    } else if value == nil || value is NSNull {
                        dict["value"] = nil
                    } else {
                        HMSErrorLogger.logError(#function, "Session metadata type is not compatible, Please use compatible type while setting metadata", "Type Incompatibility Error")
                        dict["value"] = nil
                    }
                }
            } catch {
                HMSErrorLogger.logError(#function, "Session metadata type is not compatible, JSON parsing failed", "Type Incompatibility Error")
                dict["value"] = nil
            }

            dict["uid"] = uid
            data["data"] = dict

            self?.sessionSink?(data)

        }) { [weak self] observer, error in

            if let error = error {
                HMSErrorLogger.logError(#function, "Error in observing changes for key: \(keys) in the Session Store. Error: \(error.localizedDescription)", "KEY CHANGE ERROR")
                result(HMSErrorExtension.getError("Error in observing changes for key: \(keys) in the Session Store. Error: \(error.localizedDescription)"))
                return
            }

            guard let observer = observer
            else {
                HMSErrorLogger.logError(#function, "Unknown Error in observing changes for key: \(keys) in the Session Store.", "KEY CHANGE ERROR")
                result(HMSErrorExtension.getError("Unknown Error in observing changes for key: \(keys) in the Session Store."))
                return
            }

            guard let self = self
            else {
                HMSErrorLogger.logError(#function, "Could not find self instance while observing changes for key: \(keys) in the Session Store.", "KEY CHANGE ERROR")
                result(HMSErrorExtension.getError("Could not find self instance while observing changes for key: \(keys) in the Session Store."))
                return
            }

            self.sessionStoreChangeObservers.append(HMSSessionStoreKeyChangeListener(uid, observer))

            result(nil)
        }
    }

    /***
     * This method is used to remove the attached key change listeners
     * attached using [addKeyChangeListener] method
     */
    private func removeKeyChangeListener(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

//        There is no need to call removeKeyChangeListener is
//        there is no keyChangeListener attached
        if sessionStoreChangeObservers.isEmpty {
            result(HMSResultExtension.toDictionary(true, nil))
            return
        }

        guard let store = sessionStore
        else {
            HMSErrorLogger.returnHMSException(#function, "Session Store is null", "NULL ERROR", result)
            return
        }

        guard let arguments = call.arguments as? [AnyHashable: Any]
        else {
            HMSErrorLogger.returnHMSException(#function, "No arguments to identify which Key Change Listener should be removed from the Session Store.", "Remove Key Error", result)
            return
        }

        guard let uid = arguments["uid"] as? String
        else {
            HMSErrorLogger.returnHMSException(#function, "No identifier passed which can be used. Available arguments: \(arguments)", "Unique Id Error", result)
            return
        }

        guard let keyChangeListenersToBeRemovedIndex = sessionStoreChangeObservers.firstIndex(where: {
            $0.uid == uid
        })
        else {
            HMSErrorLogger.returnHMSException(#function, "No listener found to remove", "Listener Error", result)
            return
        }

        store.removeObserver(sessionStoreChangeObservers[keyChangeListenersToBeRemovedIndex].observer)

        sessionStoreChangeObservers.remove(at: keyChangeListenersToBeRemovedIndex)

        result(HMSResultExtension.toDictionary(true, nil))
    }

    /**
            This takes care of removing all the key change listeners attached during the session
            This is used while cleaning the room state i.e after calling leave room,
            onRemovedFromRoom or endRoom
     */
    private func removeAllKeyChangeListener() {
        sessionStoreChangeObservers.forEach {[weak self] observer in
            self?.sessionStore?.removeObserver(observer.observer)
        }
        sessionStoreCleanup()
    }

    private func sessionStoreCleanup() {
        sessionStore = nil
        sessionStoreChangeObservers = []
    }

    // MARK: - Room Actions

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? [AnyHashable: Any]

        // TODO: add checks for 100ms Extension Target
        if let prefExtension = arguments?["preferred_extension"] as? String {
            preferredExtension = prefExtension
        }

        if let iOSScreenshareConfig = arguments?["ios_screenshare_config"] as? [String: String] {
            if let prefExtension = iOSScreenshareConfig["preferred_extension"] {
                preferredExtension = prefExtension
            } else {
                print(#function, "preferredExtension Not found in iOSScreenshareConfig")
                result(false)
            }
        }

        var setLogger = false
        if let hmsLogSettings = arguments?["hms_log_settings"] as? [AnyHashable: Any] {
            let level = hmsLogSettings["log_level"] as! String
            logLevel = getLogLevel(from: level)
            setLogger = true
        }
        let dartSDKVersion = arguments?["dart_sdk_version"] as! String
        let hmsSDKVersion = arguments?["hmssdk_version"] as! String
        let isPrebuilt = arguments?["is_prebuilt"] as? Bool ?? false

        let framework = HMSFrameworkInfo(type: .flutter, version: dartSDKVersion, sdkVersion: hmsSDKVersion, isPrebuilt: isPrebuilt)
        audioMixerSourceMap = [:]

        hmsSDK = HMSSDK.build { [weak self] sdk in
            guard let self = self else {
                print(#function, "Failed to build HMSSDK")
                result(false)
                return
            }
            if let appGroup = arguments?["app_group"] as? String {
                sdk.appGroup = appGroup
            }

            if let iOSScreenshareConfig = arguments?["ios_screenshare_config"] as? [String: String] {
                if let appGroup = iOSScreenshareConfig["app_group"] {
                    sdk.appGroup = appGroup
                } else {
                    print(#function, "AppGroup Not found in iOSScreenshareConfig")
                    result(false)
                }
            }

            sdk.frameworkInfo = framework

            var trackSettings: HMSTrackSettings?
            if let settingsDict = arguments?["hms_track_setting"] as? [AnyHashable: Any] {
                self.audioMixerSourceInit(settingsDict, sdk, result)
                trackSettings = HMSTrackSettingsExtension.setTrackSetting(settingsDict, self.audioMixerSourceMap, vbAction, result)
            }

            if let settings = trackSettings {
                sdk.trackSettings = settings
            }

            if setLogger {
                sdk.logger = self
            }

            result(true)
        }
    }

    private func preview(_ call: FlutterMethodCall, _ result: FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let config = getConfig(from: arguments) else {
            result(HMSErrorExtension.getError("Could not join room, invalid parameters passed in \(#function)"))
            return
        }

        hmsSDK?.preview(config: config, delegate: self)

        result(nil)
    }

    private func previewForRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let arguments = call.arguments as? [AnyHashable: Any],
              let roleString = arguments["role_name"] as? String,
              let role = HMSCommonAction.getRole(by: roleString, hmsSDK: hmsSDK)
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("Invalid role parameters for role in \(#function)")))
            return
        }

        hmsSDK?.preview(role: role) { tracks, error in

            if let error = error {
                print(#function, error)
                result(HMSResultExtension.toDictionary(false, error))
                return
            }

            if let tracks = tracks {

                var dict = [[AnyHashable: Any]]()

                for track in tracks {
                    if track.kind == HMSTrackKind.video {
                        previewForRoleVideoTrack = track as? HMSLocalVideoTrack
                    } else if track.kind == HMSTrackKind.audio {
                        previewForRoleAudioTrack = track as? HMSLocalAudioTrack
                    }
                    dict.append(HMSTrackExtension.toDictionary(track))
                }

                result(HMSResultExtension.toDictionary(true, dict))
            }
        }
    }

    private func cancelPreview(_ result: FlutterResult) {
        self.previewForRoleAudioTrack = nil
        self.previewForRoleVideoTrack = nil
        hmsSDK?.cancelPreview()
        result(HMSResultExtension.toDictionary(true))
    }

    private func join(_ call: FlutterMethodCall, _ result: FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let config = getConfig(from: arguments) else {
            result(HMSErrorExtension.getError("Could not join room, invalid parameters passed in \(#function)"))
            return
        }

        hmsSDK?.join(config: config, delegate: self)

        result(nil)
    }

    private func leave(_ result: @escaping FlutterResult) {
        hmsSDK?.leave { [weak self] _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                self?.performCleanupOnLeavingRoom()
                result(nil)
            }
        }
    }

    private func destroy(_ result: @escaping FlutterResult) {
        hmsSDK = nil
        result(nil)
    }

    /**
    [toggleAlwaysScreenOn] provides a way to keep the screen always ON when enabled.
     */
    private func toggleAlwaysScreenOn(_ result: @escaping FlutterResult) {
        UIApplication.shared.isIdleTimerDisabled = !UIApplication.shared.isIdleTimerDisabled
        result(nil)
    }

    // MARK: - Role based Actions

    private func getRoles(_ call: FlutterMethodCall, _ result: FlutterResult) {

        var roles = [[String: Any]]()

        hmsSDK?.roles.forEach { roles.append(HMSRoleExtension.toDictionary($0)) }

        result(["roles": roles])
    }

    private func getAuthTokenByRoomCode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        guard let arguments = call.arguments as? [AnyHashable: Any]
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("Invalid parameters for getAuthToken in \(#function)")))
            return
        }

        guard let roomCode = arguments["room_code"] as? String
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("Invalid parameters for getAuthToken in \(#function)")))
            return
        }

        let userId = arguments["user_id"] as? String? ?? nil
        let endPoint = arguments["end_point"] as? String? ?? nil

        // This is to make the QA links work
        if endPoint != nil && endPoint!.contains("nonprod") {
                UserDefaults.standard.set(endPoint, forKey: "HMSAuthTokenEndpointOverride")
        } else {
            UserDefaults.standard.removeObject(forKey: "HMSAuthTokenEndpointOverride")
        }

        hmsSDK?.getAuthTokenByRoomCode(roomCode, userID: userId, completion: { authToken, error in
            if let error = error {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
            } else {
                result(HMSResultExtension.toDictionary(true, authToken))
            }
        })
    }

    /**
     * [getRoomLayout]  is used to get the layout themes for the room set in the dashboard.
     */

    private func getRoomLayout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let authToken = arguments["auth_token"] as? String?

        else {
            result(HMSErrorExtension.getError("Invalid parameters for getRoomLayout in \(#function)"))
            return
        }

        let endPoint = arguments["endpoint"] as? String

        // This is to make the mock API links work
        if endPoint != nil && (endPoint!.contains("mockable") || endPoint!.contains("nonprod")) {
            UserDefaults.standard.set(endPoint, forKey: "HMSRoomLayoutEndpointOverride")
        }
        // This is to make the QA API work
        else {
            UserDefaults.standard.removeObject(forKey: "HMSRoomLayoutEndpointOverride")
        }

        hmsSDK?.getRoomLayout(using: authToken!) { layout, error in
            if let error = error {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
            } else {
                if let rawData = layout?.rawData {
                    let jsonString = String(decoding: rawData, as: UTF8.self)
                    result(HMSResultExtension.toDictionary(true, jsonString))
                    return
                }
            }
        }
    }

    private func changeRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let peerID = arguments["peer_id"] as? String,
              let peer = HMSCommonAction.getPeer(by: peerID, hmsSDK: hmsSDK),
              let roleString = arguments["role_name"] as? String,
              let role = HMSCommonAction.getRole(by: roleString, hmsSDK: hmsSDK)
        else {
            result(HMSErrorExtension.getError("Invalid parameters for change role in \(#function)"))
            return
        }

        let force = arguments["force_change"] as? Bool ?? false

        hmsSDK?.changeRole(for: peer, to: role, force: force) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    private func acceptChangeRole(_ result: @escaping FlutterResult) {
        if let request = roleChangeRequest {
            hmsSDK?.accept(changeRole: request) { [weak self] _, error in
                if let error = error {
                    result(HMSErrorExtension.toDictionary(error))
                } else {
                    self?.roleChangeRequest = nil
                    self?.previewForRoleAudioTrack = nil
                    self?.previewForRoleVideoTrack = nil
                    result(nil)
                }
            }
        } else {
            result(HMSErrorExtension.getError("Role Change Request is Expired."))
        }
    }

    private func endRoom(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        let lock = arguments["lock"] as? Bool ?? false
        let reason = arguments["reason"] as? String ?? "End room invoked"

        hmsSDK?.endRoom(lock: lock, reason: reason) { [weak self] _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                self?.performCleanupOnLeavingRoom()
                result(nil)
            }
        }
    }

    private func removePeer(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let peerID = arguments["peer_id"] as? String,
              let peer = HMSCommonAction.getPeer(by: peerID, hmsSDK: hmsSDK)
        else {
            result(HMSErrorExtension.getError("Peer not found in \(#function)"))
            return
        }

        let reason = (arguments["reason"] as? String) ?? "Removed from room"

        hmsSDK?.removePeer(peer, reason: reason) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    private func changeTrackState(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getTrack(for: trackID, in: hmsSDK!.room!)
        else {
            result(HMSErrorExtension.getError("Could not find track to change track in \(#function)"))
            return
        }

        let mute = arguments["mute"] as? Bool ?? false

        hmsSDK?.changeTrackState(for: track, mute: mute) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
                return
            }
            result(nil)
        }
    }

    private func changeTrackStateForRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let mute = arguments?["mute"] as? Bool else {
            result(HMSErrorExtension.getError("Could not find track to change track in \(#function)"))
            return
        }

        var trackKind: HMSTrackKind?
        if let kindStr = arguments?["type"] as? String {
            trackKind = kind(from: kindStr)
        }

        let source = arguments?["source"] as? String

        var roles: [HMSRole]?
        if let rolesString = arguments?["roles"] as? [String] {
            roles = hmsSDK?.roles.filter { rolesString.contains($0.name) }
        }

        hmsSDK?.changeTrackState(mute: mute, for: trackKind, source: source, roles: roles) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    private func changeRoleOfPeersWithRoles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        guard let roleString = arguments["to_role"] as? String,
              let role = HMSCommonAction.getRole(by: roleString, hmsSDK: hmsSDK) else {
            result(HMSErrorExtension.getError("Could not find role in \(#function)"))
            return
        }

        var ofRoles = [HMSRole]()
        if let ofRolesString = arguments["of_roles"] as? [String] {
            ofRoles = hmsSDK?.roles.filter { ofRolesString.contains($0.name) } ?? []
        }

        hmsSDK?.changeRolesOfAllPeers(to: role, limitToRoles: ofRoles) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }

    /**
     * This acts as a setter for [isRoomAudioUnmutedLocally] variable
     */
    func setIsRoomAudioUnmutedLocally(isRoomAudioUnmuted: Bool) {
        isRoomAudioUnmutedLocally = isRoomAudioUnmuted
    }

    // MARK: - Logging

    private var logLevel = HMSLogLevel.off

    private func startHMSLogger(_ call: FlutterMethodCall) {
        let arguments = call.arguments as? [AnyHashable: Any]

        guard let level = arguments?["log_level"] as? String else {
            return
        }

        logLevel = getLogLevel(from: level)

        hmsSDK?.logger = self
    }

    private func getLogLevel(from level: String) -> HMSLogLevel {
        switch level {
        case "verbose":
            return .verbose
        case "warn":
            return .warning
        case "error":
            return .error
        case "off":
            return .off
        default:
            return .off
        }
    }

    /**
     * This is used to get the logs from the Native SDK
     * Here to avoid choking of the platform channel we batch the logs in group of 1000
     * and then send the update to the application.
     * If a user requires all the logs at any moment then [getAllLogs] method can be used.
     * Here [logsBuffer] is used to maintain the 512 logs list
     * while [logsDump] contains all the logs of the session if a user calls [getAllLogs] we
     * send the [logsDump] through the platform channel
     **/
    var logsBuffer = [Any]()
    var logsDump = [Any]()
    public func log(_ message: String, _ level: HMSLogLevel) {
        /**
        * Here we filter the logs based on the level we have set
        * while calling [startHMSLogger]
        **/
        guard level.rawValue <= logLevel.rawValue else { return }

        logsBuffer.append(message)
        logsDump.append(message)

        if logsBuffer.count >= 512 {
            var args = [String: Any]()
            args["event_name"] = "on_logs_update"
            args["data"] = logsBuffer
            logsSink?(args)
            logsBuffer = []
        }
    }

    private func getAllLogs(_ result: @escaping FlutterResult) {
        result(logsDump)
        logsBuffer = []
    }

    private func removeHMSLogger() {
        logLevel = .off
        logsDump.removeAll()
        logsBuffer.removeAll()
        hmsSDK?.logger = nil
    }

    private func setPlaybackAllowedForTrack(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let isPlaybackAllowed = arguments["is_playback_allowed"] as? Bool,
              let trackID = arguments["track_id"] as? String,
              let trackKind = arguments["track_kind"] as? String
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }

        let room = hmsSDK?.room
        if room != nil {
            if kind(from: trackKind) == HMSTrackKind.audio {
                let audioTrack = HMSUtilities.getAudioTrack(for: trackID, in: room!) as HMSAudioTrack?
                if audioTrack != nil && audioTrack is HMSRemoteAudioTrack {
                    (audioTrack as! HMSRemoteAudioTrack).setPlaybackAllowed(isPlaybackAllowed)
                    result(nil)
                    return
                }
            } else if kind(from: trackKind) == HMSTrackKind.video {
                let videoTrack = HMSUtilities.getVideoTrack(for: trackID, in: room!) as HMSVideoTrack?
                if videoTrack != nil && videoTrack is HMSRemoteVideoTrack {
                    (videoTrack as! HMSRemoteVideoTrack).setPlaybackAllowed(isPlaybackAllowed)
                    result(nil)
                    return
                }
            }
        }
        result(HMSErrorExtension.getError("Could not set isPlaybackAllowed for track in \(#function)"))
    }

    private func captureSnapshot(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? [AnyHashable: Any]

        guard let trackID = arguments?["track_id"] as? String
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(trackID), object: nil, userInfo: ["result": result])
    }

    // MARK: - 100ms SDK Delegate Callbacks

    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {

        var tracks = [[String: Any]]()
        localTracks.forEach { tracks.append(HMSTrackExtension.toDictionary($0)) }

        let data = [
            "event_name": "preview_video",
            "data": [
                "room": HMSRoomExtension.toDictionary(room),
                "local_tracks": tracks
            ] as [String: Any]
        ] as [String: Any]
        previewEnded = false
        previewSink?(data)
    }

    var previewEnded = false
    public func on(join room: HMSRoom) {
        previewEnded = true

        /**
         * This sets the [hlsStreamUrl] variable to
         * fetch the stream URL directly from onRoomUpdate
         * This helps to play the HLS Stream even if user doesn't send
         * the stream URL.
         */

        if room.hlsStreamingState.state == HMSStreamingState.started {
            if !room.hlsStreamingState.variants.isEmpty {
                hlsStreamUrl = room.hlsStreamingState.variants.first?.url?.absoluteString
            }
        }

        /**
         `willTerminateNotification` is not fired in all cases. When app is in background & then app is force closed then this notification is not fired resulting in `leave` method not being invoked.
         */
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            if self?.hmsSDK?.room != nil {
                self?.hmsSDK?.leave()
            }
        }

        let data = [
            "event_name": "on_join_room",
            "data": [
                "room": HMSRoomExtension.toDictionary(room)
            ]
        ] as [String: Any]

        eventSink?(data)
    }

    public func on(room: HMSRoom, update: HMSRoomUpdate) {

        /**
         * This sets the [hlsStreamUrl] variable to
         * fetch the stream URL directly from onRoomUpdate
         * This helps to play the HLS Stream even if user doesn't send
         * the stream URL.
         */

        if room.hlsStreamingState.state == HMSStreamingState.started {
            if !room.hlsStreamingState.variants.isEmpty {
                hlsStreamUrl = room.hlsStreamingState.variants.first?.url?.absoluteString
            }
        }

        let data = [
            "event_name": "on_room_update",
            "data": [
                "room": HMSRoomExtension.toDictionary(room),
                "update": HMSRoomExtension.getValueOf(update)
            ] as [String: Any]
        ] as [String: Any]
        if previewEnded {
            eventSink?(data)
        } else {
            previewSink?(data)
        }
    }

    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        guard peer.peerID != "" else {
            return
        }
        let data = [
            "event_name": "on_peer_update",
            "data": [
                "peer": HMSPeerExtension.toDictionary(peer),
                "update": HMSPeerExtension.getValueOf(update)
            ] as [String: Any]
        ] as [String: Any]

        if previewEnded {
            eventSink?(data)
        } else {
            previewSink?(data)
        }
    }

    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {

        /**
         * Here we set the playback of the audio to false if the room is muted locally
         */
        if track is HMSRemoteAudioTrack  && update == .trackAdded && !isRoomAudioUnmutedLocally {
            (track as! HMSRemoteAudioTrack).setPlaybackAllowed(false)
        }

        let data = [
            "event_name": "on_track_update",
            "data": [
                "peer": HMSPeerExtension.toDictionary(peer),
                "track": HMSTrackExtension.toDictionary(track),
                "update": HMSTrackExtension.getValueOf(update)
            ] as [String: Any]
        ] as [String: Any]
        if peer.isLocal && track.source.uppercased() == "SCREEN" {
            if update == .trackAdded {
                isScreenShareOn = true
            } else if update == .trackRemoved {
                isScreenShareOn = false
            }
        }
        eventSink?(data)
    }

    public func on(error: Error) {

        let data = [
            "event_name": "on_error",
            "data": HMSErrorExtension.toDictionary(error)
        ] as [String: Any]

        eventSink?(data)
    }

    public func on(updated speakers: [HMSSpeaker]) {

        var speakersDict = [[String: Any]]()
        speakers.forEach { speakersDict.append(HMSSpeakerExtension.toDictionary($0)) }

        let data = [
            "event_name": "on_update_speaker",
            "data": [
                "speakers": speakersDict
            ]
        ] as [String: Any]

        eventSink?(data)
    }

    public func on(message: HMSMessage) {

        let data = [
            "event_name": "on_message",
            "data": [
                "message": HMSMessageExtension.toDictionary(message)
            ]
        ] as [String: Any]

        eventSink?(data)
    }

    public func on(roleChangeRequest: HMSRoleChangeRequest) {

        self.roleChangeRequest = roleChangeRequest

        var dict = ["event_name": "on_role_change_request"] as [String: Any]
        var request = ["suggested_role": HMSRoleExtension.toDictionary(roleChangeRequest.suggestedRole)] as [String: Any]

        if let peer = roleChangeRequest.requestedBy {
            request["requested_by"] = HMSPeerExtension.toDictionary(peer)
        }

        dict["data"] = ["role_change_request": request]

        eventSink?(dict)
    }

    public func on(changeTrackStateRequest: HMSChangeTrackStateRequest) {

        let data = [
            "event_name": "on_change_track_state_request",
            "data": [
                "track_change_request": HMSChangeTrackStateRequestExtension.toDictionary(changeTrackStateRequest)
            ]
        ] as [String: Any]

        eventSink?(data)
    }

    public func on(removedFromRoom notification: HMSRemovedFromRoomNotification) {

        let data = [
            "event_name": "on_removed_from_room",
            "data": [
                "removed_from_room": HMSRemovedFromRoomExtension.toDictionary(notification)
            ]
        ] as [String: Any]

        performCleanupOnLeavingRoom()
        eventSink?(data)
    }

    public func onReconnecting() {
        let data = [ "event_name": "on_re_connecting" ]
        eventSink?(data)
    }

    public func onReconnected() {
        let data = [ "event_name": "on_re_connected" ]
        eventSink?(data)
    }

    public func onPeerListUpdate(added: [HMSPeer], removed: [HMSPeer]) {
        var parameters = [String: Any]()

        var addedPeers = [Any]()
        var removedPeers = [Any]()

        added.forEach {
            addedPeers.append(HMSPeerExtension.toDictionary($0))
        }

        removed.forEach {
            removedPeers.append(HMSPeerExtension.toDictionary($0))
        }

        parameters["added_peers"] = addedPeers
        parameters["removed_peers"] = removedPeers

        let data = ["event_name": "on_peer_list_update", "data": parameters] as [String: Any]

        if previewEnded {
            eventSink?(data)
        } else {
            previewSink?(data)
        }
    }

    // MARK: - RTC Stats Listeners

    public func on(localAudioStats: HMSLocalAudioStats, track: HMSAudioTrack, peer: HMSPeer) {
        if isStatsActive {
            let data = [
                "event_name": "on_local_audio_stats",
                "data": [
                    "local_audio_stats": HMSStatsExtension.toDictionary(localAudioStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]

            rtcSink?(data)
        }
    }

    public func on(localVideoStats: [HMSLocalVideoStats], track: HMSVideoTrack, peer: HMSPeer) {

        if isStatsActive {
            let data = [
                "event_name": "on_local_video_stats",
                "data": [
                    "local_video_stats": HMSStatsExtension.toDictionary(localVideoStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ] as [String: Any]
            ] as [String: Any]

            rtcSink?(data)
        }
    }

    public func on(remoteAudioStats: HMSRemoteAudioStats, track: HMSAudioTrack, peer: HMSPeer) {
        if isStatsActive {
            let data = [
                "event_name": "on_remote_audio_stats",
                "data": [
                    "remote_audio_stats": HMSStatsExtension.toDictionary(remoteAudioStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]

            rtcSink?(data)
        }
    }

    public func on(remoteVideoStats: HMSRemoteVideoStats, track: HMSVideoTrack, peer: HMSPeer) {
        if isStatsActive {
            let data = [
                "event_name": "on_remote_video_stats",
                "data": [
                    "remote_video_stats": HMSStatsExtension.toDictionary(remoteVideoStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]

            rtcSink?(data)
        }
    }

    public func on(rtcStats: HMSRTCStatsReport) {
        if isStatsActive {
            let data = [
                "event_name": "on_rtc_stats_report",
                "data": [
                    "rtc_stats_report": HMSStatsExtension.toDictionary(rtcStats)
                ]
            ] as [String: Any]

            rtcSink?(data)
        }
    }

    public func on(sessionStoreAvailable store: HMSSessionStore) {
        sessionStore = store

        let data = ["event_name": "on_session_store_available"]

        eventSink?(data)
    }

    // MARK: - Helper Functions

    private func getConfig(from arguments: [AnyHashable: Any]) -> HMSConfig? {
        guard let authToken = arguments["auth_token"] as? String,
              let userName = arguments["user_name"] as? String
        else {
            return nil
        }

        let shouldSkipPIIEvents = arguments["should_skip_pii_events"] as? Bool ?? false
        let captureNetworkQualityInPreview = arguments["capture_network_quality_in_preview"] as? Bool ?? false
        let metaData = arguments["meta_data"] as? String

        var endPoint: String?
        if let endPointStr = arguments["end_point"] as? String, !endPointStr.isEmpty {
            endPoint = endPointStr
        }

        return HMSConfig(userName: userName,
                         authToken: authToken,
                         shouldSkipPIIEvents: shouldSkipPIIEvents,
                         metadata: metaData,
                         endpoint: endPoint,
                         captureNetworkQualityInPreview: captureNetworkQualityInPreview)
    }

    private func kind(from string: String) -> HMSTrackKind {
        switch string {
        case "KHmsTrackAudio":
            return .audio
        case "KHmsTrackVideo":
            return .video
        default:
            return .audio
        }
    }

    private func getCodec(from string: String) -> HMSCodec {
        if string.lowercased().contains("h264") {
            return HMSCodec.H264
        }
        return HMSCodec.VP8
    }

    private func audioMixerSourceInit(_ settingsDict: [AnyHashable: Any], _ sdk: HMSSDK, _ result: FlutterResult) {
        if let audioTrackSetting = settingsDict["audio_track_setting"] as? [AnyHashable: Any] {
            if let playerNode = audioTrackSetting["audio_source"] as? [String] {
                for node in playerNode {
                    if self.audioMixerSourceMap[node] == nil {
                        if node=="mic_node" {
                            self.audioMixerSourceMap["mic_node"] = HMSMicNode()
                        } else if node == "screen_broadcast_audio_receiver_node" && sdk.appGroup != nil {
                            do {
                                self.audioMixerSourceMap["screen_broadcast_audio_receiver_node"] = try sdk.screenBroadcastAudioReceiverNode()
                            } catch {
                                print(#function, HMSErrorExtension.toDictionary(error))
                                result(false)
                            }
                        } else {
                            self.audioMixerSourceMap[node] = HMSAudioFilePlayerNode()
                        }
                    }
                }
            }
        }
    }

    func sendCustomError(_ errorDict: [String: Any]) {

        let data = [
            "event_name": "on_error",
            "data": errorDict
        ] as [String: Any]

        eventSink?(data)
    }

    private func destroyPIPController() {
        if #available(iOS 15.0, *) {
            if HMSPIPAction.pipController != nil {
                HMSPIPAction.disposePIP(nil)
            }
        }
    }

    private func performCleanupOnLeavingRoom() {
        destroyPIPController()
        removeAllKeyChangeListener()
        removeHMSLogger()
        HMSPeerListIteratorAction.clearIteratorMap()
        setIsRoomAudioUnmutedLocally(isRoomAudioUnmuted: true)
        NotificationCenter.default.removeObserver(self)
    }
}
