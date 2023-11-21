// Dart imports:
import 'dart:io' show Platform;
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSVideoView
///
///HMSVideoView used to render video in ios and android devices
///
/// To use,import package:`hmssdk_flutter/ui/meeting/hms_video_view.dart`.
///
/// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
///
/// [HMSVideoView] will render video using trackId from HMSTrack
///
/// **parameters**
///
/// **track** - This will render video with trackId present in the track. Use video track only.
///
/// **matchParent** - To match the size of the parent widget.
///
/// **scaleType** - To set the video scaling. [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
///
/// **setMirror** - To set mirroring of video
///
/// **disableAutoSimulcastLayerSelect** -  To disable auto simulcast (Adaptive Bitrate)
///
/// **key** - [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
/// Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
///
/// **addTrackByDefault** - To call addTrack by default as HMSVideoView is attached to the tree. Default value is [true]
///
/// **controller** - To control the video view, this is useful for custom usecases when you wish to control the addTrack and removeTrack
/// track functionalities on your own.
///
/// Refer [HMSVideoView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
class HMSVideoView extends StatelessWidget {
  /// This will render video with trackId present in the track
  /// [track] - the video track to be displayed
  final HMSVideoTrack track;

  /// [matchParent] - to match the size of the parent widget
  final bool matchParent;

  /// [scaleType] - To set the video scaling.
  ///
  /// ScaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
  final ScaleType scaleType;

  /// [setMirror] - To set mirroring of video
  final bool setMirror;

  /// [disableAutoSimulcastLayerSelect] - To disable auto simulcast (Adaptive Bitrate)
  final bool disableAutoSimulcastLayerSelect;

  /// [addTrackByDefault] - To call addTrack by default as HMSVideoView is attached to the tree. Default value is [true]
  final bool addTrackByDefault;

  /// [controller] - To control the video view, this is useful for custom usecases when you wish to control the addTrack and removeTrack
  /// track functionalities on your own.
  final HMSVideoViewController? controller;

  ///100ms HMSVideoView
  ///
  ///HMSVideoView used to render video in ios and android devices
  ///
  /// To use,import package:`hmssdk_flutter/ui/meeting/hms_video_view.dart`.
  ///
  /// just pass the videotracks of local or remote peer and internally it passes [peer_id], [is_local] and [track_id] to specific views.
  ///
  /// [HMSVideoView] will render video using trackId from HMSTrack
  ///
  /// **parameters**
  ///
  /// **track** - This will render video with trackId present in the track. Use video track only.
  ///
  /// **matchParent** - To match the size of the parent widget.
  ///
  /// **scaleType** - To set the video scaling.`[SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]`
  ///
  /// **setMirror** - To set mirroring of video
  ///
  /// **disableAutoSimulcastLayerSelect** -  To disable auto simulcast (Adaptive Bitrate)
  ///
  /// **key** - [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
  /// Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
  ///
  /// Refer [HMSVideoView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
  HMSVideoView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      @Deprecated(
          "matchParent is not longer necessary and will be removed in future version")
      this.matchParent = true,
      this.scaleType = ScaleType.SCALE_ASPECT_FIT,
      this.disableAutoSimulcastLayerSelect = false,
      this.addTrackByDefault = true,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      track: track,
      matchParent: this.matchParent,
      setMirror: setMirror,
      scaleType: this.scaleType,
      disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect,
      addTrackByDefault: addTrackByDefault,
      controller: controller,
    );
  }
}

class _PlatformView extends StatefulWidget {
  final HMSTrack track;
  final bool setMirror;
  final bool matchParent;
  final ScaleType scaleType;
  final bool disableAutoSimulcastLayerSelect;
  final bool addTrackByDefault;
  final HMSVideoViewController? controller;

  _PlatformView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.matchParent = true,
      required this.scaleType,
      this.disableAutoSimulcastLayerSelect = false,
      this.addTrackByDefault = true,
      this.controller})
      : super(key: key);

  @override
  State<_PlatformView> createState() => _PlatformViewState();
}

class _PlatformViewState extends State<_PlatformView> {
  HMSVideoViewController? viewController;

  void onPlatformViewCreated(int id) {}

  @override
  void initState() {
    if (widget.controller == null) {
      viewController = HMSVideoViewController(
          track: widget.track as HMSVideoTrack, callback: setView);
    } else {
      viewController = widget.controller;
    }
    super.initState();
  }

  void setView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      viewController?.disposeTextureView(callback: setView);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///AndroidView for android it uses surfaceRenderer provided internally by webrtc.
    if (Platform.isAndroid) {
      return viewController?.textureId == null
          ? SizedBox()
          : LayoutBuilder(
              builder: (context, constraints) {
                viewController?.setHeightWidth(
                    constraints.maxHeight, constraints.maxWidth);
                return Center(
                  child: FittedBox(
                    clipBehavior: Clip.hardEdge,
                    fit: widget.scaleType == ScaleType.SCALE_ASPECT_FIT
                        ? BoxFit.contain
                        : BoxFit.cover,
                    child: SizedBox(
                      width: widget.scaleType == ScaleType.SCALE_ASPECT_FIT
                          ? (constraints.maxHeight * (16 / 9))
                          : constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(
                        child: Transform(
                            transform: Matrix4.identity()
                              ..rotateY(widget.setMirror ? -pi : 0.0),
                            alignment: FractionalOffset.center,
                            child:
                                Texture(textureId: viewController!.textureId!)),
                      ),
                    ),
                  ),
                );
              },
            );
    } else if (Platform.isIOS) {
      ///UIKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        viewType: 'HMSFlutterPlatformView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'track_id': widget.track.trackId,
          'set_mirror':
              widget.track.source != "REGULAR" ? false : widget.setMirror,
          'scale_type': widget.scaleType.value,
          'match_parent': widget.matchParent,
          'disable_auto_simulcast_layer_select':
              widget.disableAutoSimulcastLayerSelect
        },
        gestureRecognizers: {},
      );
    } else {
      throw UnimplementedError(
          'Video View is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
