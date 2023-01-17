import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hms_listenable_button.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_screen_controller.dart';
import 'package:hmssdk_flutter_example/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/preview/preview_page.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewDetails extends StatefulWidget {
  final String meetingLink;
  final MeetingFlow meetingFlow;
  final bool autofocusField;
  PreviewDetails(
      {required this.meetingLink,
      required this.meetingFlow,
      this.autofocusField = false});
  @override
  State<PreviewDetails> createState() => _PreviewDetailsState();
}

class _PreviewDetailsState extends State<PreviewDetails> {
  TextEditingController nameController = TextEditingController();
  late PreviewStore _previewStore;
  late MeetingStore _meetingStore;
  late HMSSDKInteractor _hmsSDKInteractor;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> setHMSSDKInteractor(
      {required bool joinWithMutedAudio,
      required bool joinWithMutedVideo,
      required bool isSoftwareDecoderDisabled,
      required bool isAudioMixerDisabled}) async {
    /// [iOSScreenshareConfig] of [HMSSDKInteractor] are optional values only required for implementing Screen & Audio Share on iOS. They are not required for Android.
    /// Remove [appGroup] & [preferredExtension] if your app does not implements Screen or Audio Share on iOS.
    /// [joinWithMutedAudio] & [joinWithMutedVideo] are required to set the initial audio/video state i.e what should be camera and mic
    /// state while room is joined.By default both audio and video are kept as mute.

    HMSIOSScreenshareConfig iOSScreenshareConfig =
        Utilities.getIOSScreenshareConfig(
            appGroup: "group.flutterhms",
            preferredExtension:
                "live.100ms.flutter.FlutterBroadcastUploadExtension");

    _hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: iOSScreenshareConfig,
        joinWithMutedAudio: joinWithMutedAudio,
        joinWithMutedVideo: joinWithMutedVideo,
        isSoftwareDecoderDisabled: isSoftwareDecoderDisabled,
        isAudioMixerDisabled: isAudioMixerDisabled);
    //build call should be a blocking call
    await _hmsSDKInteractor.build();
  }

  void loadData() async {
    nameController.text = await Utilities.getStringData(key: "name");
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    setState(() {});
  }

  void showPreview(bool res) async {
    if (nameController.text.isEmpty) {
      Utilities.showToast("Please enter you name");
    } else {
      Utilities.saveStringData(key: "name", value: nameController.text.trim());
      res = await Utilities.getPermissions();
      bool skipPreview =
          await Utilities.getBoolData(key: 'skip-preview') ?? false;
      bool joinWithMutedAudio =
          await Utilities.getBoolData(key: 'join-with-muted-audio') ?? true;
      bool joinWithMutedVideo =
          await Utilities.getBoolData(key: 'join-with-muted-video') ?? true;
      bool isSoftwareDecoderDisabled =
          await Utilities.getBoolData(key: 'software-decoder-disabled') ?? true;
      bool isAudioMixerDisabled =
          await Utilities.getBoolData(key: 'audio-mixer-disabled') ?? true;
      if (res) {
        await setHMSSDKInteractor(
            joinWithMutedAudio: joinWithMutedAudio,
            joinWithMutedVideo: joinWithMutedVideo,
            isSoftwareDecoderDisabled: isSoftwareDecoderDisabled,
            isAudioMixerDisabled: isAudioMixerDisabled);

        if (!skipPreview) {
          _previewStore = PreviewStore(hmsSDKInteractor: _hmsSDKInteractor);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ListenableProvider.value(
                    value: _previewStore,
                    child: PreviewPage(
                        meetingFlow: widget.meetingFlow,
                        name: nameController.text,
                        meetingLink: widget.meetingLink),
                  )));
        } else {
          bool showStats =
              await Utilities.getBoolData(key: 'show-stats') ?? false;
          bool mirrorCamera =
              await Utilities.getBoolData(key: 'mirror-camera') ?? false;
          _meetingStore = MeetingStore(hmsSDKInteractor: _hmsSDKInteractor);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ListenableProvider.value(
                    value: _meetingStore,
                    child: HLSScreenController(
                      isRoomMute: false,
                      isStreamingLink: widget.meetingFlow == MeetingFlow.meeting
                          ? false
                          : true,
                      isAudioOn: true,
                      meetingLink: widget.meetingLink,
                      localPeerNetworkQuality: -1,
                      user: nameController.text.trim(),
                      mirrorCamera: mirrorCamera,
                      showStats: showStats,
                    ),
                  )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool res = false;
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/user-music.svg',
              width: width / 4,
            ),
            SizedBox(
              height: 40,
            ),
            Text("Go live in five!",
                style: GoogleFonts.inter(
                    color: themeDefaultColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 4,
            ),
            Text("Let's get started with your name",
                style: GoogleFonts.inter(
                    color: themeSubHeadingColor,
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width * 0.95,
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  showPreview(res);
                },
                autofocus: widget.autofocusField,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.inter(),
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: nameController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              nameController.text = "";
                              setState(() {});
                            },
                            icon: Icon(Icons.clear),
                          ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    fillColor: themeSurfaceColor,
                    filled: true,
                    hintText: 'Enter your name here',
                    hintStyle: GoogleFonts.inter(
                        color: themeHintColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            HMSListenableButton(
                width: width * 0.5,
                onPressed: () async => {
                      FocusManager.instance.primaryFocus?.unfocus(),
                      showPreview(res),
                    },
                childWidget: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Started',
                          style: GoogleFonts.inter(
                              color: nameController.text.isEmpty
                                  ? themeDisabledTextColor
                                  : enabledTextColor,
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: nameController.text.isEmpty
                            ? themeDisabledTextColor
                            : enabledTextColor,
                        size: 16,
                      )
                    ],
                  ),
                ),
                textController: nameController,
                errorMessage: "Please enter you name")
          ],
        ),
      )),
    );
  }
}
