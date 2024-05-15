//
//  HMSHLSPlayerView.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 23/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSPlayerView: NSObject, FlutterPlatformView {

    private let frame: CGRect
    private let viewIdentifier: Int64
    private let hlsURL: String?
    private let hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?
    private let isHLSStatsRequired: Bool
    private let showPlayerControls: Bool
    private var hlsPlayer: HMSHLSPlayer?
    var statMonitor: HMSHLSStatsMonitor?
    private var hmsHLSStreamViewController: HMSHLSStreamViewController?

    /**
     * Initializes the HLS player view with the specified parameters.
     * - Parameters:
     *   - frame: The CGRect defining the frame of the HLS player view.
     *   - viewIdentifier: The unique identifier for the HLS player view.
     *   - hlsURL: The HLS URL for the media content to be played.
     *   - hmssdkFlutterPlugin: The instance of the SwiftHmssdkFlutterPlugin.
     *   - isHLSStatsRequired: A boolean indicating whether HLS stats are required.
     *   - showPlayerControls: A boolean indicating whether to show player controls.
     */
    init(frame: CGRect, viewIdentifier: Int64, hlsURL: String?, hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?, isHLSStatsRequired: Bool, showPlayerControls: Bool) {
        self.frame = frame
        self.viewIdentifier = viewIdentifier
        self.hlsURL = hlsURL
        self.hmssdkFlutterPlugin = hmssdkFlutterPlugin
        self.isHLSStatsRequired = isHLSStatsRequired
        self.showPlayerControls = showPlayerControls
    }

    func view() -> UIView {
        initialisePlayer()
    }

    /**
     Initializes the HLS player and returns the player's view.
     
     - Returns: The UIView representing the HLS player.
     */
    private func initialisePlayer() -> UIView {

        hlsPlayer = HMSHLSPlayer()
        let playerViewController = hlsPlayer!.videoPlayerViewController(showsPlayerControls: showPlayerControls)
        if #available(iOS 14.2, *) {
            playerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        }
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.view.frame = frame
        guard let hmssdkFlutterPlugin else {
            HMSErrorLogger.logError(#function, "hmssdkFlutterPlugin is null", "NULL_ERROR")
            return playerViewController.view
        }
        playerViewController.videoGravity = .resizeAspectFill

        /**
         * Here we start the player
         * We first check whether the user has passed the streamUrl or not
         * If not, we fetch the URL from SDK
         * else we use the URL sent by the user
         */
        if hlsURL != nil {

            /**
             * Here we play the stream using streamUrl using the stream from
             * url passed by the user
             */
            guard let hlsStreamURL =  URL(string: hlsURL!) else {
                HMSErrorLogger.logError(#function, "Cannot convert hlsURL to URL", "PARSE_ERROR")
                return playerViewController.view
            }

            /**
             * Here we play the stream using streamUrl using the stream from
             * onRoomUpdate or onJoin
             */
            hlsPlayer?.play(hlsStreamURL)
        } else {
            if hmssdkFlutterPlugin.hlsStreamUrl != nil {
                guard let hlsStreamURL =  URL(string: hmssdkFlutterPlugin.hlsStreamUrl!) else {
                    HMSErrorLogger.logError(#function, "hlsStreamURL not found", "NULL_ERROR")
                    return playerViewController.view
                }

                /**
                 * Here we add the event listener to listen to the events
                 * of HLS Player
                 */
                hmsHLSStreamViewController = HMSHLSStreamViewController(hlsPlayer: hlsPlayer, hmssdkFlutterPlugin: hmssdkFlutterPlugin)
                hlsPlayer?.delegate = hmsHLSStreamViewController
                hlsPlayer?.play(hlsStreamURL)
                NotificationCenter.default.addObserver(self, selector: #selector(handleHLSPlayerOperations), name: NSNotification.Name(HMSHLSPlayerAction.HLS_PLAYER_METHOD), object: nil)

                /**
                 * Here we add the stats listener to the
                 * HLS Player
                 */
                if isHLSStatsRequired {
                    HMSHLSStatsHandler.addHLSStatsListener(hlsPlayer, hmssdkFlutterPlugin)
                }
            }
        }

        return playerViewController.view

    }

    /**
     Deinitializes the HLS player and performs necessary cleanup.
     */
    deinit {

        // Remove the HLS stats listener
        HMSHLSStatsHandler.removeHLSStatsListener()

        // Set the hlsPlayer to nil to release its resources
        hlsPlayer = nil
    }

    private func areClosedCaptionsSupported() -> Bool {
        guard let playerItem = hlsPlayer?._nativePlayer.currentItem else {
            return false
        }

        guard let availableSubtitleTracks = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
            return false
        }

        guard let firstOption = availableSubtitleTracks.options.first else {
            return false
        }

        if firstOption.mediaType == .subtitle {
            return true
        } else {
            return false
        }
    }

    /**
     * Below methods handles the HLS Player controller calls
     */
    @objc func handleHLSPlayerOperations(_ notification: Notification) {
        switch notification.userInfo?[HMSHLSPlayerAction.METHOD_CALL] as? String? {
        case "start_hls_player":
            start(notification.userInfo!["hls_url"] as? String)
        case "stop_hls_player":
            hlsPlayer?.stop()

        case "pause_hls_player":
            hlsPlayer?.pause()

        case "resume_hls_player":
            hlsPlayer?.resume()

        case "seek_to_live_position":
            hlsPlayer?.seekToLivePosition()

        case "seek_forward":
            hlsPlayer?.seekForward(seconds: TimeInterval(notification.userInfo!["seconds"] as! Int))

        case "seek_backward":
            hlsPlayer?.seekBackward(seconds: TimeInterval(notification.userInfo!["seconds"] as! Int))

        case "set_hls_player_volume":
            hlsPlayer?.volume = notification.userInfo!["volume"] as! Int

        case "add_hls_stats_listener":
            addHLSStatsListener()

        case "remove_hls_stats_listener":
            removeHLSStatsListener()

        case "are_closed_captions_supported":
            let result = notification.userInfo?["result"] as? FlutterResult
            result?(areClosedCaptionsSupported())

        case "enable_closed_captions":
            let result = notification.userInfo?["result"] as? FlutterResult
            if areClosedCaptionsSupported() {
                let player = hlsPlayer?._nativePlayer
                guard let playerItem = player?.currentItem else {return }

                guard let availableSubtitleTracks = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }

                if let firstSubtitle = availableSubtitleTracks.options.first(where: {$0.mediaType == .subtitle}) {

                    playerItem.select(firstSubtitle, in: availableSubtitleTracks)

                }
            } else {
                HMSErrorLogger.logError("\(#function)", "Closed Captions are not supported", "SUPPORT ERROR")
            }
            result?(nil)
        case "disable_closed_captions":
            let result = notification.userInfo?["result"] as? FlutterResult
            let player = hlsPlayer?._nativePlayer
            guard let playerItem = player?.currentItem else {return }

            guard let availableSubtitleTracks = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }

            if let _ = playerItem.currentMediaSelection.selectedMediaOption(in: availableSubtitleTracks) {
                playerItem.select(nil, in: availableSubtitleTracks)
            }
            result?(nil)
        case "get_stream_properties":
            let result = notification.userInfo?["result"] as? FlutterResult
            let player = hlsPlayer?._nativePlayer
            guard let playerItem = player?.currentItem else {return }

            var map = [String: Any?]()

            let duration = playerItem.duration

            if duration.isIndefinite {
                guard let timeRange = playerItem.seekableTimeRanges.last as? CMTimeRange else { return }

                map["rolling_window_time"] = timeRange.duration.seconds
            } else {
                map["stream_duration"] = duration.seconds
            }
            result?(map)

        case "set_hls_layer":

            let result = notification.userInfo?["result"] as? FlutterResult
            if let bitrate = notification.userInfo?["bitrate"] as? Int {
                hlsPlayer?._nativePlayer.currentItem?.preferredPeakBitRate = Double(bitrate)
                result?(nil)
            } else {
                HMSErrorLogger.logError("setHLSLayer", "bitrate is null", "NULL ERROR")
                result?(nil)
            }

        default:
            return
        }
    }

    /**
     Starts the HLS player with the specified HLS URL.

     - Parameters:
        - hlsUrl: The HLS URL to play. If nil, the HLS URL from hmssdkFlutterPlugin will be used.
     */
    private func start(_ hlsUrl: String?) {

        if hlsUrl != nil {
            guard let hlsStreamURL =  URL(string: hlsUrl!) else {
                HMSErrorLogger.logError(#function, "hlsUrl not found", "NULL_ERROR")
                return
            }
            hlsPlayer?.play(hlsStreamURL)
            return
        } else {
            guard let hmssdkFlutterPlugin else {
                HMSErrorLogger.logError(#function, "hmssdkFlutterPlugin is null", "NULL_ERROR")
                return
            }

            if hmssdkFlutterPlugin.hlsStreamUrl != nil {
                guard let hlsStreamURL =  URL(string: hmssdkFlutterPlugin.hlsStreamUrl!) else {
                    HMSErrorLogger.logError(#function, "hlsStreamURL not found", "NULL_ERROR")
                    return
                }
                hlsPlayer?.play(hlsStreamURL)
            }
        }
    }

    private func addHLSStatsListener() {
        guard let hlsPlayer else {
            HMSErrorLogger.logError(#function, "hlsPlayer is null", "NULL_ERROR")
            return
        }
        HMSHLSStatsHandler.addHLSStatsListener(hlsPlayer, hmssdkFlutterPlugin)
    }

    private func removeHLSStatsListener() {
        HMSHLSStatsHandler.removeHLSStatsListener()
    }
}
