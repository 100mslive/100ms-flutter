//
//  HMSHLSPlayerAction.swift
//  DKImagePickerController
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSSDK

/**
 * This class is used to send actions from flutter plugin to HLS Player
 * We use notifications to forward the request to HMSHLSPlayer
 */
class HMSHLSPlayerAction {

    static let HLS_PLAYER_METHOD = "HLS_PLAYER"
    static let METHOD_CALL = "method_name"

    static func hlsPlayerAction(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {
        switch call.method {
        case "start_hls_player":
            start(
                call,
                result
            )

        case "stop_hls_player":
            stop(
                result
            )

        case "pause_hls_player":
            pause(
                result
            )

        case "resume_hls_player":
            resume(
                result
            )

        case "seek_to_live_position":
            seekToLivePosition(
                result
            )

        case "seek_forward":
            seekForward(
                call,
                result
            )

        case "seek_backward":
            seekBackward(
                call,
                result
            )

        case "set_hls_player_volume":
            setVolume(
                call,
                result
            )

        case "add_hls_stats_listener":
            addHLSStatsListener(
                result
            )

        case "remove_hls_stats_listener":
            removeHLSStatsListener(
                result
            )

        case "are_closed_captions_supported":
            areClosedCaptionsSupported(
                result
            )

        case "enable_closed_captions":
            enableClosedCaptions(
                result
            )

        case "disable_closed_captions":
            disableClosedCaptions(
                result
            )

        case "get_stream_properties":
            getStreamProperties(
                result
            )

        case "get_hls_layers":
            getHLSLayers(result)

        case "set_hls_layer":
            setHLSLayer(call, result)

        case "get_current_hls_layer":
            getCurrentHLSLayer(result)

        default:
            result(
                FlutterMethodNotImplemented
            )
        }

    }

    /**
     * Starts the HLS player by posting a notification with the specified method call and HLS URL.
     *
     * - Parameters:
     *   - call: The method call object containing the HLS URL as an argument.
     *   - result: The result object to be returned after starting the player.
     */
    static private func start(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {

        guard let arguments = call.arguments as? [AnyHashable: Any] else {
            HMSErrorLogger.logError(
                #function,
                "No arguments found",
                "NULL_ERROR"
            )
            result(
                nil
            )
            return
        }

        let hlsUrl = arguments["hls_url"] as? String

        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "start_hls_player",
                "hls_url": hlsUrl as Any
            ]
        )
        result(
            nil
        )
    }

    /**
     * Stops the HLS player by posting a notification with the specified method call.
     *
     * - Parameter result: The result object to be returned after stopping the player.
     */
    static private func stop(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "stop_hls_player"]
        )
        result(
            nil
        )
    }

    /**
     * Pauses the HLS player by posting a notification with the specified method call.
     *
     * - Parameter result: The result object to be returned after pausing the player.
     */
    static private func pause(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "pause_hls_player"]
        )
        result(
            nil
        )
    }

    /**
     * Resumes the HLS player by posting a notification with the specified method call.
     *
     * - Parameter result: The result object to be returned after resuming the player.
     */
    static private func resume(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "resume_hls_player"]
        )
        result(
            nil
        )
    }

    /**
     * Seeks to the live position in the HLS player by posting a notification with the specified method call.
     *
     * - Parameter result: The result object to be returned after seeking to the live position.
     */
    static private func seekToLivePosition(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "seek_to_live_position"]
        )
        result(
            nil
        )
    }

    /**
     * Seeks forward in the HLS player by the specified number of seconds, posting a notification with the seek duration.
     *
     * - Parameters:
     *   - call: The method call object containing the number of seconds to seek forward as an argument.
     *   - result: The result object to be returned after seeking forward.
     */
    static private func seekForward(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {

        guard let arguments = call.arguments as? [AnyHashable: Any],
              let seconds = arguments["seconds"] as? Int else {
            HMSErrorLogger.logError(
                #function,
                "seconds parameter is null",
                "NULL_ERROR"
            )
            result(
                nil
            )
            return
        }

        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "seek_forward",
                "seconds": seconds
            ]
        )
        result(
            nil
        )
    }

    /**
     * Seeks backward in the HLS player by the specified number of seconds, posting a notification with the seek duration.
     *
     * - Parameters:
     *   - call: The method call object containing the number of seconds to seek backward as an argument.
     *   - result: The result object to be returned after seeking backward.
     */
    static private func seekBackward(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {

        guard let arguments = call.arguments as? [AnyHashable: Any],
              let seconds = arguments["seconds"] as? Int else {
            HMSErrorLogger.logError(
                #function,
                "seconds parameter is null",
                "NULL_ERROR"
            )
            result(
                nil
            )
            return
        }

        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "seek_backward",
                "seconds": seconds
            ]
        )
        result(
            nil
        )
    }

    /**
     * Sets the volume level of the HLS player by posting a notification with the specified volume value.
     *
     * - Parameters:
     *   - call: The method call object containing the volume level as an argument.
     *   - result: The result object to be returned after setting the volume.
     */
    static private func setVolume(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {

        guard let arguments = call.arguments as? [AnyHashable: Any],
              let volume = arguments["volume"] as? Int else {
            HMSErrorLogger.logError(
                #function,
                "volume parameter is null",
                "NULL_ERROR"
            )
            result(
                nil
            )
            return
        }

        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "set_hls_player_volume",
                "volume": volume
            ]
        )
        result(
            nil
        )
    }
    /**
     * Adds a listener to receive HLS player statistics by posting a notification with the corresponding method call.
     *
     * - Parameter result: The result object to be returned after adding the HLS stats listener.
     */
    static private func addHLSStatsListener(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "add_hls_stats_listener"]
        )
        result(
            nil
        )
    }

    /**
     * Removes the listener for HLS player statistics by posting a notification with the corresponding method call.
     *
     * - Parameter result: The result object to be returned after removing the HLS stats listener.
     */
    static private func removeHLSStatsListener(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "remove_hls_stats_listener"]
        )
        result(
            nil
        )
    }

    static private func areClosedCaptionsSupported(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "are_closed_captions_supported",
                "result": result
            ]
        )
    }

    static private func enableClosedCaptions(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "enable_closed_captions"]
        )
        result(
            nil
        )
    }

    static private func disableClosedCaptions(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [METHOD_CALL: "disable_closed_captions"]
        )
        result(
            nil
        )
    }

    static private func getStreamProperties(
        _ result: @escaping FlutterResult
    ) {
        NotificationCenter.default.post(
            name: NSNotification.Name(
                HLS_PLAYER_METHOD
            ),
            object: nil,
            userInfo: [
                METHOD_CALL: "get_stream_properties",
                "result": result
            ]
        )
    }

    static private var layersMap = [

        [
            "resolution": [
                "height": 1080.0,
                "width": 1920.0
            ],
            "bitrate": 4000 * 1000
        ],
        [
            "resolution": [
                "height": 720.0,
                "width": 1280.0
            ],
            "bitrate": 1500 * 1000
        ],
        [
            "resolution": [
                "height": 540.0,
                "width": 960.0
            ],
            "bitrate": 1000 * 1000
        ],
        [
            "resolution": [
                "height": 480.0,
                "width": 852.0
            ],
            "bitrate": 850 * 1000
        ],
        [
            "resolution": [
                "height": 360.0,
                "width": 640.0
            ],
            "bitrate": 450 * 1000
        ],
        [
            "resolution": [
                "height": 240.0,
                "width": 426.0
            ],
            "bitrate": 300 * 1000
        ],
        [
            "resolution": [
                "height": 144.0,
                "width": 256.0
            ],
            "bitrate": 200 * 1000
        ],
        [
            "bitrate": nil
        ]

    ]

    static private var currentBitrate: Any? =  [
        "bitrate": nil
    ]

    static private func getHLSLayers(
        _ result: @escaping FlutterResult
    ) {
        var layers = [String: Any]()
        layers["layers"] = layersMap
        result(layers)
    }

    static private func setHLSLayer(
        _ call: FlutterMethodCall,
        _ result: @escaping FlutterResult
    ) {
        guard let arguments = call.arguments as? [AnyHashable: Any],
              let layer = arguments["layer"] as? [String: Any] else {
                  HMSErrorLogger.returnArgumentsError("hmsHLSLayer parameter is null")
                  return
              }

        /*
         Here if the bitrate is nil
         we set it as zero otherwise the given bitrate is applied
        */
        currentBitrate = layer["bitrate"]
            NotificationCenter.default.post(
                name: NSNotification.Name(
                    HLS_PLAYER_METHOD
                ),
                object: nil,
                userInfo: [
                    METHOD_CALL: "set_hls_layer",
                    "result": result,
                    "bitrate": layer["bitrate"] ?? 0
                ]
            )
    }

    static private func getCurrentHLSLayer(
        _ result: @escaping FlutterResult
    ) {
        if let currentBitrate = currentBitrate as? Int {
            let layer = layersMap.first { $0["bitrate"] as? Int == currentBitrate
            }
            result(layer)
            return
        }
        result(nil)
    }
}
