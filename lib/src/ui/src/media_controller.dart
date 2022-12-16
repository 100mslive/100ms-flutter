import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// Internal callback that notifies when a button of the media control is pressed
/// or when the video controller calls a function related to a controller.
typedef _ControlPressedCallback = void Function(MediaControl control);

/// Media controller widget that draws playback controls over the video widget.
/// This widget controls the visibility of the controls over the widget.
class MediaController extends StatefulWidget {
  /// Widget on which the media controls are drawn.
  final Widget child;

  /// Determines if the controller should hide automatically.
  final bool? autoHide;

  /// The time after which the controller will automatically hide.
  final Duration? autoHideTime;

  /// Enables the control for the volume in the media control.
  final bool? enableVolumeControl;

  /// Controller to update the media controller view when the
  /// video controller is used to call a playback function.
  final MediaControlsController? controller;

  /// Callback to notify when a button is pressed in the controller view.
  final _ControlPressedCallback? onControlPressed;

  /// Progression callback used to notify when the progression slider
  /// is touched.
  final ProgressionCallback? onPositionChanged;

  /// Progression callback used to notify when the progression slider
  /// is touched.
  final VolumeChangedCallback? onVolumeChanged;

  /// Constructor of the widget.
  const MediaController({
    Key? key,
    required this.child,
    this.autoHide,
    this.autoHideTime,
    this.enableVolumeControl,
    this.controller,
    this.onControlPressed,
    this.onPositionChanged,
    this.onVolumeChanged,
  }) : super(key: key);

  @override
  MediaControllerState createState() => MediaControllerState();
}

/// State of the media controller.
class MediaControllerState extends State<MediaController> {
  /// Determinate if the controls are visible or not over the widget.
  bool _visible = true;

  /// Timer to auto hide the controller after a few seconds.
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _setAutoHideTimer();
  }

  @override
  void dispose() {
    _cancelAutoHideTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            widget.child,
            _buildToggleWidget(),
          ],
        ),
        _buildMediaController(),
      ],
    );
  }

  /// Builds the overlay widget that detects the tap gesture to toggle the
  /// media controls.
  Widget _buildToggleWidget() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleController,
        child: Container(),
      ),
    );
  }

  /// Builds the media controls over the widget in the stack.
  ///
  /// Returns a positioned widget with the controls.
  Widget _buildMediaController() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Offstage(
        child: MediaControls(
          controller: widget.controller,
          onControlPressed: widget.onControlPressed,
          onPositionChanged: widget.onPositionChanged,
          enableVolumeControl: widget.enableVolumeControl,
          onVolumeChanged: widget.onVolumeChanged,
          onTapped: _onControllerTapped,
        ),
        offstage: !_visible,
      ),
    );
  }

  /// This callback is called when the media controller is tapped.
  void _onControllerTapped() {
    _setAutoHideTimer();
  }

  /// Changes the state of the visibility of the controls and rebuilds
  /// the widget. If [visibility] is set then is used as a new value of
  /// visibility.
  void _toggleController({bool? visibility}) {
    setState(() {
      _visible = visibility ?? !_visible;
    });
    _resolveAutoHide();
  }

  /// Resolve if the auto hide timer should be set or cancelled.
  void _resolveAutoHide() {
    bool autoHide = widget.autoHide ?? true;
    if (autoHide) {
      if (_visible) {
        _setAutoHideTimer();
      } else {
        _cancelAutoHideTimer();
      }
    }
  }

  /// Sets the auto hide timer.
  void _setAutoHideTimer() {
    _cancelAutoHideTimer();
    int time = widget.autoHideTime?.inMilliseconds ?? 3000;
    _autoHideTimer = Timer(Duration(milliseconds: time), () {
      _toggleController(visibility: false);
    });
  }

  /// Cancels the auto hide timer.
  void _cancelAutoHideTimer() {
    if (_autoHideTimer != null) {
      _autoHideTimer!.cancel();
      _autoHideTimer = null;
    }
  }
}

/// Widget that contains the control buttons of the media controller.
class MediaControls extends StatefulWidget {
  /// Controller to update the media controller view when the
  /// video controller is used to call a playback function.
  final MediaControlsController? controller;

  /// Callback to notify when a button is pressed in the controller view.
  final _ControlPressedCallback? onControlPressed;

  /// Progression callback used to notify when the progression slider
  /// is touched.
  final ProgressionCallback? onPositionChanged;

  /// Enables the control for the volume in the media control.
  final bool? enableVolumeControl;

  /// Progression callback used to notify when the progression slider
  /// is touched.
  final VolumeChangedCallback? onVolumeChanged;

  /// Callback to notify when the widget is tapped.
  final Function? onTapped;

  /// Constructor of the widget.
  const MediaControls({
    Key? key,
    this.controller,
    this.onControlPressed,
    this.onPositionChanged,
    this.enableVolumeControl,
    this.onVolumeChanged,
    this.onTapped,
  }) : super(key: key);

  @override
  MediaControlsState createState() => MediaControlsState();
}

/// State of the control buttons and slider.
class MediaControlsState extends State<MediaControls> {
  /// Determinate if the state is playing and how the play/pause button
  /// is displayed.
  bool _playing = false;

  /// Determinate if the state of volume is muted.
  bool _volumeControlVisible = false;

  /// Determinate if the state of volume is muted.
  bool _muted = false;

  /// Current progress of the slider.
  double _progress = 0;

  /// Current progress of the slider.
  double _volume = 1;

  /// Max duration of the slider.
  double _duration = 1000;

  @override
  void initState() {
    super.initState();
    _initMediaController();
  }

  @override
  void dispose() {
    _disposeMediaController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_volumeControlVisible) _buildVolumeControl(),
          _buildControlButtons(),
          _buildProgressionBar(),
        ],
      ),
    );
  }

  /// Builds the playback control buttons.
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildControlButton(
          iconData: Icons.fast_rewind,
          onPressed: _rewind,
        ),
        _buildControlButton(
          iconData: _playing ? Icons.pause : Icons.play_arrow,
          onPressed: _playPause,
        ),
        _buildControlButton(
          iconData: Icons.stop,
          onPressed: _stop,
        ),
        _buildControlButton(
          iconData: Icons.fast_forward,
          onPressed: _forward,
        ),
        if (_shouldBuildVolumeControl())
          _buildControlButton(
            iconData: Icons.volume_up,
            onPressed: _toggleVolumeControl,
          ),
      ],
    );
  }

  /// Builds the progression bar of the player.
  Widget _buildProgressionBar() {
    return Slider(
      onChanged: _onSliderPositionChanged,
      value: _progress,
      min: 0,
      max: _duration,
    );
  }

  /// Builds a single control button. Requires the [iconData] to display
  /// the icon and a [onPressed] function to call when the button is pressed.
  Widget _buildControlButton(
      {required IconData iconData, required void Function() onPressed}) {
    return IconButton(
      icon: Icon(iconData, color: Colors.white),
      onPressed: onPressed,
    );
  }

  /// Builds the volume control widget.
  Widget _buildVolumeControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildControlButton(
          iconData:
              !_muted && _volume != 0 ? Icons.volume_up : Icons.volume_off,
          onPressed: _mute,
        ),
        Expanded(
          child: Slider(
            onChanged: _onVolumeChanged,
            value: _volume,
            min: 0,
            max: 1,
          ),
        ),
        _buildControlButton(
          iconData: Icons.close,
          onPressed: _toggleVolumeControl,
        ),
      ],
    );
  }

  /// Initializes the media controller if is not null.
  void _initMediaController() {
    if (widget.controller != null) {
      widget.controller!.addControlPressedListener(_onControlPressed);
      widget.controller!.addPositionChangedListener(_onPositionChanged);
    }
  }

  /// Clear callbacks in the media controller when this view is disposed.
  void _disposeMediaController() {
    if (widget.controller != null) {
      widget.controller!.clearControlPressedListener();
      widget.controller!.clearPositionChangedListener();
    }
  }

  /// Callback that is called when the controller calls a function and the
  /// control view needs to be updated.
  void _onControlPressed(MediaControl mediaControl) {
    _resetAutoHideTimer();
    switch (mediaControl) {
      case MediaControl.pause:
        setState(() {
          _playing = false;
        });
        break;
      case MediaControl.play:
        setState(() {
          _playing = true;
        });
        break;
      case MediaControl.stop:
        setState(() {
          _playing = false;
        });
        break;
      case MediaControl.toggleSound:
        setState(() {
          _muted = !_muted;
        });
        break;
      default:
        break;
    }
  }

  /// Callback that is called when the controller notifies that the playback
  /// time has changed and the control view needs to be updated.
  void _onPositionChanged(int position, int duration) {
    setState(() {
      _progress =
          position > 0 && position <= duration ? position.toDouble() : 0;
      _duration = duration > 0 ? duration.toDouble() : 0;
    });
  }

  /// Notifies when the slider in the media controller has been touched
  /// and the playback position needs to be updated through the video controller.
  void _onSliderPositionChanged(double position) {
    _onPositionChanged(position.toInt(), _duration.toInt());
    if (widget.onPositionChanged != null)
      widget.onPositionChanged!(position.toInt(), _duration.toInt());
    _resetAutoHideTimer();
  }

  /// Notifies when the slider in the media controller has been touched
  /// and the playback position needs to be updated through the video controller.
  void _onVolumeChanged(double volume) {
    setState(() {
      _volume = volume;
      _muted = false;
    });
    if (widget.onVolumeChanged != null) widget.onVolumeChanged!(volume);
    _resetAutoHideTimer();
  }

  /// Notifies when the rewind button in the media controller has been pressed
  /// and the playback position needs to be updated through the video controller.
  void _rewind() {
    _notifyControlPressed(MediaControl.rwd);
  }

  /// Notifies when the play/pause button in the media controller has been pressed
  /// and the playback state needs to be updated through the video controller.
  void _playPause() async {
    _notifyControlPressed(_playing ? MediaControl.pause : MediaControl.play);
  }

  /// Notifies when the stop button in the media controller has been pressed
  /// and the playback state needs to be updated through the video controller.
  void _stop() async {
    _onPositionChanged(0, _duration.toInt());
    _notifyControlPressed(MediaControl.stop);
  }

  /// Notifies when the forward button in the media controller has been pressed
  /// and the playback position needs to be updated through the video controller.
  void _forward() {
    _notifyControlPressed(MediaControl.fwd);
  }

  /// Notifies when the mute button in the media controller has been pressed
  /// and the playback position needs to be updated through the video controller.
  void _toggleVolumeControl() {
    setState(() {
      _volumeControlVisible = !_volumeControlVisible;
    });
  }

  /// Notifies when the mute button in the media controller has been pressed
  /// and the playback position needs to be updated through the video controller.
  void _mute() {
    _notifyControlPressed(MediaControl.toggleSound);
  }

  /// Notifies when a control button in pressed.
  void _notifyControlPressed(MediaControl control) {
    if (widget.onControlPressed != null) widget.onControlPressed!(control);
    _resetAutoHideTimer();
  }

  /// Resets the auto-hide timer for this control.
  void _resetAutoHideTimer() {
    if (widget.onTapped != null) widget.onTapped!();
  }

  /// Returns if the volume controls should be build based on the configuration
  /// passed in the widget constructor. If is disabled or has no callback
  /// the volume control will not be built.
  bool _shouldBuildVolumeControl() {
    bool enabled = widget.enableVolumeControl ?? false;
    bool hasCallback = widget.onVolumeChanged != null;
    return enabled && hasCallback;
  }
}

/// Media controller class used to notify when the video controller has
/// changed the playback position/state and the controls view needs to be
/// updated.
class MediaControlsController {
  /// Control callback that is registered and is used to notify
  /// the video controller updates.
  _ControlPressedCallback? _controlPressedCallback;

  /// Position callback that is registered and is used to notify
  /// the video controller updates.
  ProgressionCallback? _positionChangedCallback;

  /// Adds callback that receive notifications when the video controller
  /// updates the state.
  void addControlPressedListener(
      _ControlPressedCallback controlPressedCallback) {
    _controlPressedCallback = controlPressedCallback;
  }

  /// Removes the control pressed callback registered.
  void clearControlPressedListener() {
    _controlPressedCallback = null;
  }

  /// Notifies when the video controller changes the state.
  void notifyControlPressed(MediaControl mediaControl) {
    if (_controlPressedCallback != null) _controlPressedCallback!(mediaControl);
  }

  /// Adds callback that receive notifications when the video controller
  /// updates the position of the playback.
  void addPositionChangedListener(ProgressionCallback positionChangedCallback) {
    _positionChangedCallback = positionChangedCallback;
  }

  /// Removes the position callback registered.
  void clearPositionChangedListener() {
    _positionChangedCallback = null;
  }

  /// Notifies when the video controller changes the playback position.
  void notifyPositionChanged(int position, int duration) {
    if (_positionChangedCallback != null)
      _positionChangedCallback!(position, duration);
  }
}
