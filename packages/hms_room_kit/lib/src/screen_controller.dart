///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/preview_meeting_flow.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/preview/preview_permissions.dart';

///[ScreenController] is the controller for the preview screen
///It takes following parameters:
///[roomCode] is the room code of the room to join
///[options] is the options for the prebuilt
///For more details checkout the [HMSPrebuiltOptions] class
class ScreenController extends StatefulWidget {
  ///[roomCode] is the room code of the room to join
  final String? roomCode;

  ///[authToken] auth token to join the room
  final String? authToken;

  ///[options] is the options for the prebuilt
  ///For more details checkout the [HMSPrebuiltOptions] class
  final HMSPrebuiltOptions? options;

  ///The callback for the leave room button
  ///This function can be passed if you wish to perform some specific actions
  ///in addition to leaving the room when the leave room button is pressed
  final Function? onLeave;

  const ScreenController(
      {super.key,
      required this.roomCode,
      this.options,
      this.onLeave,
      this.authToken});
  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  bool isPermissionGranted = false;
  late HMSSDKInteractor _hmsSDKInteractor;
  bool isLoading = true;
  HMSConfig? roomConfig;
  dynamic tokenData;

  @override
  void initState() {
    super.initState();

    ///Setting the prebuilt options and roomCode
    Constant.prebuiltOptions = widget.options;
    Constant.roomCode = widget.roomCode;
    Constant.authToken = widget.authToken;
    Constant.onLeave = widget.onLeave;

    ///Here we set the endPoints if it's non-null
    if (widget.options?.endPoints != null) {
      _setEndPoints(widget.options!.endPoints!);
    } else {
      Constant.initEndPoint = null;
      Constant.tokenEndPoint = null;
      Constant.layoutAPIEndPoint = null;
    }
    _checkPermissions();
  }

  ///This function sets the end points for the app
  ///If the endPoints were set from the [HMSPrebuiltOptions]
  void _setEndPoints(Map<String, String> endPoints) {
    Constant.tokenEndPoint = (endPoints.containsKey(Constant.tokenEndPointKey))
        ? endPoints[Constant.tokenEndPointKey]
        : null;
    Constant.initEndPoint = (endPoints.containsKey(Constant.initEndPointKey))
        ? endPoints[Constant.initEndPointKey]
        : null;
    Constant.layoutAPIEndPoint =
        (endPoints.containsKey(Constant.layoutAPIEndPointKey))
            ? endPoints[Constant.layoutAPIEndPointKey]
            : null;
  }

  ///This function checks the permissions for the app
  void _checkPermissions() async {
    isPermissionGranted = await Utilities.checkPermissions();
    if (isPermissionGranted) {
      _initPreview();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  ///[_getAuthTokenAndSetLayout] gets the auth token and set the room layout
  ///using the auth token
  ///If [getAuthTokenByRoomCode] fails it returns HMSException object
  ///else null
  Future<HMSException?> _getAuthTokenAndSetLayout(
      HMSSDKInteractor hmssdkInteractor, String userName) async {
    if (Constant.roomCode != null) {
      tokenData = await hmssdkInteractor.getAuthTokenByRoomCode(
          userId: Constant.prebuiltOptions?.userId,
          roomCode: Constant.roomCode!,
          endPoint: Constant.tokenEndPoint);
    } else {
      tokenData = Constant.authToken;
    }

    if ((tokenData is String?) && tokenData != null) {
      await HMSRoomLayout.getRoomLayout(
          hmsSDKInteractor: hmssdkInteractor,
          authToken: tokenData,
          endPoint: Constant.layoutAPIEndPoint);
      return null;
    } else {
      return tokenData;
    }
  }

  ///This function initializes the preview
  ///- Assign the _hmssdkInteractor an instance of HMSSDKInteractor
  ///- Build the HMSSDK
  ///- Initialize PreviewStore
  ///- Start the preview
  ///  - If preview fails then we show the error dialog
  ///  - If successful we show the preview page
  void _initPreview() async {
    Constant.roomCode = widget.roomCode;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    _hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: widget.options?.iOSScreenshareConfig,
        joinWithMutedAudio: true,
        joinWithMutedVideo: true,
        isSoftwareDecoderDisabled: AppDebugConfig.isSoftwareDecoderDisabled,
        isAudioMixerDisabled: AppDebugConfig.isAudioMixerDisabled,
        isNoiseCancellationEnabled:
            widget.options?.enableNoiseCancellation ?? false,
        isAutomaticGainControlEnabled:
            widget.options?.isAutomaticGainControlEnabled ?? false,
        isNoiseSuppressionEnabled:
            widget.options?.isNoiseSuppressionEnabled ?? false,
        isPrebuilt: true);
    await _hmsSDKInteractor.build();

    var ans = await _getAuthTokenAndSetLayout(
        _hmsSDKInteractor, widget.options?.userName ?? "");

    ///If fetching auth token fails then we show the error dialog
    ///with the error message and description
    if (ans != null && mounted) {
      showGeneralDialog(
          context: context,
          pageBuilder: (_, data, __) {
            return UtilityComponents.showFailureError(ans, context,
                () => Navigator.of(context).popUntil((route) => route.isFirst));
          });
    } else {
      Constant.debugMode = AppDebugConfig.isDebugMode;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  ///This function is called when the permissions are granted
  ///This is called when user grants the permissions from PreviewPermissions widget
  ///Here we initialize the preview if the permissions are granted
  ///and set the [isPermissionGranted] to true
  void _isPermissionGrantedCallback() {
    _initPreview();
    setState(() {
      isPermissionGranted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HMSThemeColors.primaryDefault,
              ),
            )
          : isPermissionGranted
              ? PreviewMeetingFlow(
                  prebuiltOptions: widget.options,
                  hmsSDKInteractor: _hmsSDKInteractor,
                  tokenData: tokenData,
                )
              : PreviewPermissions(
                  options: widget.options,
                  callback: _isPermissionGrantedCallback),
    );
  }
}
