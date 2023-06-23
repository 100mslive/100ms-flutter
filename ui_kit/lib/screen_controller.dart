import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/hms_prebuilt_options.dart';
import 'package:hmssdk_uikit/hmssdk_interactor.dart';
import 'package:hmssdk_uikit/preview/preview_page.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
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
    initMeeting();
    Utilities.initForegroundTask();
  }

  void initMeeting() async {
    var res = await Utilities.getPermissions();
    HMSIOSScreenshareConfig iOSScreenshareConfig = HMSIOSScreenshareConfig(
        appGroup: "group.flutterhms",
        preferredExtension:
            "live.100ms.flutter.FlutterBroadcastUploadExtension");

    if (res) {
      _hmsSDKInteractor = HMSSDKInteractor(
          iOSScreenshareConfig: iOSScreenshareConfig,
          joinWithMutedAudio: true,
          joinWithMutedVideo: true,
          isSoftwareDecoderDisabled: true,
          isAudioMixerDisabled: true);
      await _hmsSDKInteractor.build();
      _previewStore = PreviewStore(hmsSDKInteractor: _hmsSDKInteractor);
      setState(() {
        isLoading = false;
      });
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
