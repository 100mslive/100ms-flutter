///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/preview/preview_page.dart';
import 'package:hms_room_kit/src/preview/preview_permissions.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

///[ScreenController] is the controller for the preview screen
///It takes following parameters:
///[roomCode] is the room code of the room to join
///[options] is the options for the prebuilt
///For more details checkout the [HMSPrebuiltOptions] class
class ScreenController extends StatefulWidget {
  ///[roomCode] is the room code of the room to join
  final String roomCode;

  ///[options] is the options for the prebuilt
  ///For more details checkout the [HMSPrebuiltOptions] class
  final HMSPrebuiltOptions? options;

  const ScreenController({super.key, required this.roomCode, this.options});
  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  bool isPermissionGranted = false;
  late HMSSDKInteractor _hmsSDKInteractor;
  late PreviewStore _previewStore;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Constant.prebuiltOptions = widget.options;
    Constant.meetingUrl = widget.roomCode;
    _checkPermissions();
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

  ///This function initializes the preview
  ///- Assign the _hmssdkInteractor an instance of HMSSDKInteractor
  ///- Build the HMSSDK
  ///- Initialize PreviewStore
  ///- Start the preview
  ///  - If preview fails then we show the error dialog
  ///  - If successful we show the preview page
  void _initPreview() async {
    setState(() {
      isLoading = true;
    });
    _hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: widget.options?.iOSScreenshareConfig,
        joinWithMutedAudio: AppDebugConfig.joinWithMutedAudio,
        joinWithMutedVideo: AppDebugConfig.joinWithMutedVideo,
        isSoftwareDecoderDisabled: AppDebugConfig.isSoftwareDecoderDisabled,
        isAudioMixerDisabled: AppDebugConfig.isAudioMixerDisabled,
        isPrebuilt: true);
    await _hmsSDKInteractor.build();
    _previewStore = PreviewStore(hmsSDKInteractor: _hmsSDKInteractor);
    HMSException? ans = await _previewStore.startPreview(
        userName: "", meetingLink: widget.roomCode);

    ///If preview fails then we show the error dialog
    ///with the error message and description
    if (ans != null && mounted) {
      showGeneralDialog(
          context: context,
          pageBuilder: (_, data, __) {
            return UtilityComponents.showFailureError(ans, context,
                () => Navigator.of(context).popUntil((route) => route.isFirst));
          });
    } else {
      _hmsSDKInteractor.toggleAlwaysScreenOn();
      setState(() {
        isLoading = false;
      });
      Constant.debugMode = AppDebugConfig.isDebugMode;
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HMSThemeColors.primaryDefault,
              ),
            )
          : isPermissionGranted
              ? ListenableProvider.value(
                  value: _previewStore,
                  child: PreviewPage(
                    meetingLink: widget.roomCode,
                    name: "",
                    options: widget.options,
                  ))
              : PreviewPermissions(
                  roomCode: widget.roomCode,
                  options: widget.options,
                  callback: _isPermissionGrantedCallback),
    );
  }
}
