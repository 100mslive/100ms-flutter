import 'package:flutter/material.dart';
import 'package:hms_room_kit/preview/preview_permissions.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/constants.dart';
import 'package:hms_room_kit/common/utility_components.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/hms_prebuilt_options.dart';
import 'package:hms_room_kit/hmssdk_interactor.dart';
import 'package:hms_room_kit/preview/preview_page.dart';
import 'package:hms_room_kit/preview/preview_store.dart';
import 'package:hms_room_kit/service/app_debug_config.dart';
import 'package:provider/provider.dart';

class ScreenController extends StatefulWidget {
  final String roomCode;
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
    _checkPermissions();
  }

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

  void _initPreview() async {
    setState(() {
      isLoading = true;
    });
    _hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: AppDebugConfig.iOSScreenshareConfig,
        joinWithMutedAudio: AppDebugConfig.joinWithMutedAudio,
        joinWithMutedVideo: AppDebugConfig.joinWithMutedVideo,
        isSoftwareDecoderDisabled: AppDebugConfig.isSoftwareDecoderDisabled,
        isAudioMixerDisabled: AppDebugConfig.isAudioMixerDisabled);
    await _hmsSDKInteractor.build();
    _previewStore = PreviewStore(hmsSDKInteractor: _hmsSDKInteractor);
    HMSException? ans = await _previewStore.startPreview(
        userName: "", meetingLink: widget.roomCode);
    if (ans != null && mounted) {
      UtilityComponents.showErrorDialog(
          context: context,
          errorMessage: "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
          errorTitle: ans.message ?? "Join Error",
          actionMessage: "OK",
          action: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          });
    } else {
      setState(() {
        isLoading = false;
      });
      Constant.debugMode = AppDebugConfig.isDebugMode;
    }
  }

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
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : isPermissionGranted
              ? ListenableProvider.value(
                  value: _previewStore,
                  child: PreviewPage(
                    meetingLink: widget.roomCode,
                    name: "",
                  ))
              : PreviewPermissions(
                  roomCode: widget.roomCode,
                  options: widget.options,
                  callback: _isPermissionGrantedCallback,
                ),
    );
  }
}
