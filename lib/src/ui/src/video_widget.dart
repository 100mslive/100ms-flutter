import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// Callback that is called when the view is created and ready.
typedef ViewCreatedCallback = void Function(VideoViewController controller);

/// Callback that is called when the playback of a video is completed.
typedef CompletionCallback = void Function(VideoViewController controller);

/// Callback that is called when the player had an error trying to load/play
/// the video source. The values [what] and [extra] are Android exclusives and
/// [message] is iOS exclusive.
typedef ErrorCallback = void Function(
    VideoViewController controller, int what, int extra, String? message);

/// Callback that is called when the player finished loading the video
/// source and is prepared to start the playback. The [controller]
/// and [videoInfo] is given as parameters when the function is called.
/// The [videoInfo] parameter contains info related to the file loaded.
typedef PreparedCallback = void Function(
    VideoViewController controller, VideoInfo videoInfo);

/// Callback that indicates the progression of the media being played.
typedef ProgressionCallback = void Function(int elapsedTime, int duration);

/// Callback that indicates that the volume has been changed using the
/// media controller.
typedef VolumeChangedCallback = void Function(double volume);

/// Widget that displays a video player.
/// This widget calls an underlying player in the
/// respective platform, [VideoView] in Android and
/// [AVPlayer] in iOS.
class NativeVideoView extends StatefulWidget {
  /// Wraps the [PlatformView] in an [AspectRatio]
  /// to resize the widget once the video is loaded.
  final bool? keepAspectRatio;

  /// Shows a default media controller to control the player state.
  final bool? showMediaController;

  /// Forces the use of ExoPlayer instead of the native VideoView.
  ///
  /// Only in Android.
  final bool? useExoPlayer;

  /// Determines if the controller should hide automatically.
  final bool? autoHide;

  /// The time after which the controller will automatically hide.
  final Duration? autoHideTime;

  /// Enables the drag gesture over the video to control the volume.
  ///
  /// Default value is false.
  final bool? enableVolumeControl;

  /// Instance of [ViewCreatedCallback] to notify
  /// when the view is finished creating.
  final ViewCreatedCallback onCreated;

  /// Instance of [CompletionCallback] to notify
  /// when a video has finished playing.
  final CompletionCallback onCompletion;

  /// Instance of [ErrorCallback] to notify
  /// when the player had an error loading the video source.
  final ErrorCallback? onError;

  /// Instance of [ProgressionCallback] to notify
  /// when the time progresses while playing.
  final ProgressionCallback? onProgress;

  /// Instance of [PreparedCallback] to notify
  /// when the player is ready to start the playback of a video.
  final PreparedCallback onPrepared;

  /// Constructor of the widget.
  const NativeVideoView({
    Key? key,
    this.keepAspectRatio,
    this.showMediaController,
    this.useExoPlayer,
    this.autoHide,
    this.autoHideTime,
    this.enableVolumeControl,
    required this.onCreated,
    required this.onPrepared,
    required this.onCompletion,
    this.onError,
    this.onProgress,
  }) : super(key: key);

  @override
  NativeVideoViewState createState() => NativeVideoViewState();
}

/// State of the video widget.
class NativeVideoViewState extends State<NativeVideoView> {
  /// Completer that is finished when [onPlatformViewCreated]
  /// is called and the controller created.
  final Completer<VideoViewController> _controller =
      Completer<VideoViewController>();

  /// Value of the aspect ratio. Changes depending of the
  /// loaded file.
  double _aspectRatio = 4 / 3;

  /// Controller of the MediaController widget. This is used
  /// to update the.
  MediaControlsController? _mediaController;

  @override
  void initState() {
    super.initState();
    _mediaController = MediaControlsController();
  }

  /// Disposes the state and remove the temp files created
  /// by the Widget.
  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  /// Builds the view based on the platform that runs the app.
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'useExoPlayer': widget.useExoPlayer ?? false,
    };
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _buildVideoView(
          child: AndroidView(
        viewType: 'native_video_view',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _buildVideoView(
        child: UiKitView(
          viewType: 'native_video_view',
          onPlatformViewCreated: onPlatformViewCreated,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by this plugin.');
  }

  /// Builds the video view depending of the configuration.
  Widget _buildVideoView({required Widget child}) {
    bool keepAspectRatio = widget.keepAspectRatio ?? false;
    bool showMediaController = widget.showMediaController ?? false;
    Widget videoView = keepAspectRatio
        ? AspectRatio(
            child: child,
            aspectRatio: _aspectRatio,
          )
        : child;
    return showMediaController
        ? MediaController(
            child: videoView,
            controller: _mediaController,
            autoHide: widget.autoHide,
            autoHideTime: widget.autoHideTime,
            enableVolumeControl: widget.enableVolumeControl,
            onControlPressed: _onControlPressed,
            onPositionChanged: _onPositionChanged,
            onVolumeChanged: _onVolumeChanged,
          )
        : videoView;
  }

  /// Callback that is called when the view is created in the platform.
  Future<void> onPlatformViewCreated(int id) async {
    final VideoViewController controller =
        await VideoViewController.init(id, this);
    _controller.complete(controller);
    widget.onCreated(controller);
  }

  /// Disposes the controller of the player.
  void _disposeController() async {
    final controller = await _controller.future;
    controller.dispose();
  }

  /// Function that is called when the platform notifies that the video has
  /// finished playing.
  /// This function calls the widget's [CompletionCallback] instance.
  void onCompletion(VideoViewController controller) {
    widget.onCompletion(controller);
  }

  /// Notifies when an action of the player (play, pause & stop) must be
  /// reflected by the media controller view.
  void notifyControlChanged(MediaControl mediaControl) {
    if (_mediaController != null)
      _mediaController!.notifyControlPressed(mediaControl);
  }

  /// Notifies the player position to the media controller view.
  void notifyPlayerPosition(int position, int duration) {
    if (_mediaController != null)
      _mediaController!.notifyPositionChanged(position, duration);
  }

  /// Function that is called when the platform notifies that an error has
  /// occurred during the video source loading.
  /// This function calls the widget's [ErrorCallback] instance.
  void onError(
      VideoViewController controller, int what, int extra, String? message) {
    if (widget.onError != null)
      widget.onError!(controller, what, extra, message);
  }

  /// Function that is called when the platform notifies that the video
  /// source has been loaded and is ready to start playing.
  /// This function calls the widget's [PreparedCallback] instance.
  void onPrepared(VideoViewController controller, VideoInfo videoInfo) {
    setState(() {
      _aspectRatio = videoInfo.aspectRatio;
    });
    notifyPlayerPosition(0, videoInfo.duration ?? 0);
    widget.onPrepared(controller, videoInfo);
  }

  /// Function that is called when the player updates the time played.
  void onProgress(int position, int duration) {
    if (widget.onProgress != null) widget.onProgress!(position, duration);
    notifyPlayerPosition(position, duration);
  }

  /// When a control is pressed in the media controller, the actions are
  /// realized by the [VideoViewController] and then the result is returned
  /// to the media controller to update the view.
  void _onControlPressed(MediaControl mediaControl) async {
    VideoViewController controller = await _controller.future;
    switch (mediaControl) {
      case MediaControl.pause:
        controller.pause();
        break;
      case MediaControl.play:
        controller.play();
        break;
      case MediaControl.stop:
        controller.stop();
        break;
      case MediaControl.fwd:
        int? duration = controller.videoFile?.info?.duration;
        int position = await controller.currentPosition();
        if (duration != null && position != -1) {
          int newPosition =
              position + 3000 > duration ? duration : position + 3000;
          controller.seekTo(newPosition);
          notifyPlayerPosition(newPosition, duration);
        }
        break;
      case MediaControl.rwd:
        int? duration = controller.videoFile?.info?.duration;
        int position = await controller.currentPosition();
        if (duration != null && position != -1) {
          int newPosition = position - 3000 < 0 ? 0 : position - 3000;
          controller.seekTo(newPosition);
          notifyPlayerPosition(newPosition, duration);
        }
        break;
      case MediaControl.toggleSound:
        controller.toggleSound();
        break;
    }
  }

  /// When the position is changed in the media controller, the action is
  /// realized by the [VideoViewController] to change the position of
  /// the video playback.
  void _onPositionChanged(int position, int? duration) async {
    VideoViewController controller = await _controller.future;
    controller.seekTo(position);
  }

  /// When the position is changed in the media controller, the action is
  /// realized by the [VideoViewController] to change the position of
  /// the video playback.
  void _onVolumeChanged(double volume) async {
    VideoViewController controller = await _controller.future;
    controller.setVolume(volume);
  }
}
