import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/constants.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/hms_prebuilt_options.dart';
import 'package:hmssdk_uikit/hmssdk_interactor.dart';
import 'package:hmssdk_uikit/preview/preview_page.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
import 'package:hmssdk_uikit/service/app_debug_config.dart';
import 'package:provider/provider.dart';

class ScreenController extends StatefulWidget {
  final String roomCode;
  final HMSPrebuiltOptions? hmsConfig;

  const ScreenController({super.key, required this.roomCode, this.hmsConfig});
  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  late HMSSDKInteractor _hmsSDKInteractor;
  late PreviewStore _previewStore;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initPreview();
  }

  void initPreview() async {
    //Getting all the required permissions here such as microphone,camera and bluetooth
    var res = await Utilities.getPermissions();

    if (res) {
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
      if (ans != null) {
        UtilityComponents.showErrorDialog(
            context: context,
            errorMessage:
                "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
            errorTitle: ans.message ?? "Join Error",
            actionMessage: "OK",
            action: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            });
      } else {
        setState(() {
          isLoading = false;
        });
        Constant.debugMode = widget.hmsConfig?.debugInfo ?? false;
      }
    }
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
          : ListenableProvider.value(
              value: _previewStore,
              child: PreviewPage(
                meetingLink: widget.roomCode,
                name: "",
              )),
    );
  }
}
