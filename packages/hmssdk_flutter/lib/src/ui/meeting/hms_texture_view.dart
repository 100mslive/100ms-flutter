// Dart imports:
import 'dart:io' show Platform;
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSTextureView
///
///HMSTextureView is used to render video tracks
///
///In android devices, [HMSTextureView] uses texture to render videos while [HMSVideoView] uses surfaceView to render videos.
///In iOS there is no difference between [HMSTextureView] and [HMSVideoView].
///
/// To use,import package:`hmssdk_flutter/ui/meeting/hms_texture_view.dart`.
///
/// [HMSTextureView] renders video using trackId from HMSTrack
///
/// **parameters**
///
/// **track** - This will render video with trackId present in the track. Use video track only.
///
/// **scaleType** - To set the video scaling. [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
///
/// **setMirror** - To set mirroring of video
///
/// **disableAutoSimulcastLayerSelect** -  To disable auto simulcast (Adaptive Bitrate)
///
/// **key** - [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
/// Similarly to avoid rebuilding the key should be kept the same for particular HMSTextureView.
///
/// **controller** - To control the video view, this is useful for custom usecases when you wish to control the addTrack and removeTrack
/// track functionalities on your own.
///
/// Refer [HMSTextureView guide here](https://www.100ms.live/docs/flutter/v2/features/render-video)
class HMSTextureView extends StatelessWidget {
  /// This will render video with trackId present in the track
  /// [track] - the video track to be displayed
  final HMSVideoTrack track;

  /// [scaleType] - To set the video scaling.
  ///
  /// ScaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]
  /// Default is [ScaleType.SCALE_ASPECT_FIT]
  final ScaleType scaleType;

  /// [setMirror] - To set mirroring of video
  final bool setMirror;

  /// [disableAutoSimulcastLayerSelect] - To disable auto simulcast (Adaptive Bitrate)
  /// Default is [false]
  final bool disableAutoSimulcastLayerSelect;

  /// [controller] - To control the video view, this is useful for custom usecases when you wish to control the addTrack and removeTrack
  /// track functionalities on your own.
  final HMSTextureViewController? controller;

  HMSTextureView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      this.scaleType = ScaleType.SCALE_ASPECT_FIT,
      this.disableAutoSimulcastLayerSelect = false,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformView(
      key: key,
      track: track,
      setMirror: setMirror,
      scaleType: this.scaleType,
      disableAutoSimulcastLayerSelect: disableAutoSimulcastLayerSelect,
      controller: controller,
    );
  }
}

class _PlatformView extends StatefulWidget {
  final HMSTrack track;
  final bool setMirror;
  final ScaleType scaleType;
  final bool disableAutoSimulcastLayerSelect;
  final HMSTextureViewController? controller;

  _PlatformView(
      {Key? key,
      required this.track,
      this.setMirror = false,
      required this.scaleType,
      this.disableAutoSimulcastLayerSelect = false,
      this.controller})
      : super(key: key);

  @override
  State<_PlatformView> createState() => _PlatformViewState();
}

class _PlatformViewState extends State<_PlatformView> {
  HMSTextureViewController? viewController;

  @override
  void initState() {
    ///If controller is null, then we create a new controller
    ///else we use the controller provided by the app.
    /// (Android Only)
    if (Platform.isAndroid) {
      if (widget.controller == null) {
        viewController = HMSTextureViewController(
            track: widget.track as HMSVideoTrack,
            disableAutoSimulcastLayerSelect:
                widget.disableAutoSimulcastLayerSelect);
      } else {
        viewController = widget.controller;

        ///Calling Add Track with new track in case where the addTrack is not called by the app
        if (!widget.track.isMute) {
          viewController?.addTrack(
              track: widget.track as HMSVideoTrack,
              disableAutoSimulcastLayerSelect:
                  widget.disableAutoSimulcastLayerSelect);
        }
      }

      ///Here we set the callback method which gets called to set the view
      viewController?.setCallbackMethod(setView);
    }
    super.initState();
  }

  ///This sets the view whenever any changes are performed in the properties of the view.
  void setView() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    ///Here we dispose the texture view
    ///
    ///Note that if the controller is created from app
    ///then the application needs to call this method explicitly.
    /// (Android Only)
    if (Platform.isAndroid) {
      if (widget.controller == null) {
        viewController?.disposeTextureView();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      ///Here if the textureId is null we render an empty SizedBox
      ///We get the textureId from createTextureView method in HMSTextureViewController
      return viewController?.textureId == null
          ? SizedBox()
          : LayoutBuilder(
              key: widget.key,
              builder: (context, constraints) {
                ///This method sets the height and width of the video based on the
                ///size of video tile.
                viewController?.setHeightWidth(
                    height: constraints.maxHeight, width: constraints.maxWidth);
                return Center(
                  child: widget.scaleType != ScaleType.SCALE_ASPECT_FIT
                      ? Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: TextureView(
                            scaleType: widget.scaleType,
                            viewController: viewController,
                            constraints: constraints,
                            setMirror: widget.setMirror,
                          ),
                        )
                      : TextureView(
                          scaleType: widget.scaleType,
                          viewController: viewController,
                          constraints: constraints,
                          setMirror: widget.setMirror,
                        ),
                );
              },
            );
    } else if (Platform.isIOS) {
      ///UIKitView for ios it uses VideoView provided by 100ms ios_sdk internally.
      return UiKitView(
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        viewType: 'HMSFlutterPlatformView',
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {
          'track_id': widget.track.trackId,
          'set_mirror':
              widget.track.source != "REGULAR" ? false : widget.setMirror,
          'scale_type': widget.scaleType.value,
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

///[TextureView] returns a Texture surface to render the video
class TextureView extends StatelessWidget {
  const TextureView(
      {Key? key,
      required this.scaleType,
      required this.viewController,
      required this.constraints,
      required this.setMirror})
      : super(key: key);

  final ScaleType scaleType;
  final HMSTextureViewController? viewController;
  final BoxConstraints constraints;
  final bool setMirror;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      clipBehavior: Clip.hardEdge,
      fit: scaleType == ScaleType.SCALE_ASPECT_FIT
          ? BoxFit.contain
          : BoxFit.cover,
      child: SizedBox(
        width: (constraints.maxHeight *
            ((viewController != null) ? viewController!.aspectRatio : 1)),
        height: constraints.maxHeight,
        child: Center(
          child: Transform(
              transform: Matrix4.identity()..rotateY(setMirror ? -pi : 0.0),
              alignment: FractionalOffset.center,
              child: Texture(textureId: viewController!.textureId!)),
        ),
      ),
    );
  }
}
