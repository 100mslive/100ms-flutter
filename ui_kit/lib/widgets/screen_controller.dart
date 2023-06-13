import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/hms_prebuilt_options.dart';
import 'package:hmssdk_uikit/hmssdk_interactor.dart';
import 'package:hmssdk_uikit/preview/preview_page.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_page.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
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
      // _previewStore.startPreview(
      //     userName: widget.hmsConfig?.userName ?? "Test User",
      //     meetingLink: widget.roomCode);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: themeBottomSheetColor, elevation: 5),
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 13, 107, 184),
          scaffoldBackgroundColor: Colors.black),
      home: isLoading
          ? const Center(
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : ListenableProvider.value(
              value: _previewStore,
              child: PreviewPage(meetingLink: widget.roomCode,name: widget.hmsConfig?.userName??"Test User",)),
    );
  }
}