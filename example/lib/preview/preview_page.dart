import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String roomId;
  PreviewPage({required this.name, required this.roomId});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  void initState() {
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PreviewStore())],
    );
    super.initState();
    initPreview();
  }

  void initPreview() async {
    bool ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.name, roomId: widget.roomId);
    if (ans == false) {
      Navigator.of(context).pop();
      UtilityComponents.showErrorDialog(
          context: context,
          errorMessage: "Please enter a valid meeting URL",
          errorTitle: "Invalid Meeting Url");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final _previewStore = context.watch<PreviewStore>();
    return Scaffold(
      body: Stack(
        children: [
          (_previewStore.localTracks.isEmpty)
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Container(
                  height: height,
                  width: width,
                  child: (_previewStore.isVideoOn)
                      ? HMSVideoView(
                          scaleType: ScaleType.SCALE_ASPECT_FILL,
                          track: _previewStore.localTracks[0],
                          setMirror: true,
                          matchParent: false,
                        )
                      : Container(
                          child: Center(
                            child: CircleAvatar(
                                backgroundColor: defaultAvatarColor,
                                radius: 40,
                                child: Text(
                                  Utilities.getAvatarTitle(
                                      _previewStore.peer!.name),
                                  style: GoogleFonts.inter(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: orientation == Orientation.portrait
                          ? width * 0.2
                          : width * 0.05,
                    ),
                    Text(
                        "Let's get you started, ${widget.name.split(' ')[0].substring(0, min(widget.name.split(' ')[0].length, 10))}!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: defaultColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w600)),
                    Text("Set your studio setup in less than 5 minutes",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: disabledTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, left: 8, right: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (_previewStore.peer != null &&
                                context
                                    .read<PreviewStore>()
                                    .peer!
                                    .role
                                    .publishSettings!
                                    .allowed
                                    .contains("audio"))
                              GestureDetector(
                                onTap: () async {
                                  _previewStore.switchAudio();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: _previewStore.isAudioOn
                                          ? buttonColor
                                          : defaultColor),
                                  child: SvgPicture.asset(
                                    _previewStore.isAudioOn
                                        ? "assets/icons/mic_state_on.svg"
                                        : "assets/icons/mic_state_off.svg",
                                    color: _previewStore.isAudioOn
                                        ? defaultColor
                                        : Colors.black,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: 10,
                            ),
                            if (_previewStore.peer != null &&
                                _previewStore
                                    .peer!.role.publishSettings!.allowed
                                    .contains("video"))
                              GestureDetector(
                                onTap: _previewStore.localTracks.isEmpty
                                    ? null
                                    : () async {
                                        _previewStore.switchVideo(
                                            isOn: _previewStore.isVideoOn);
                                      },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: _previewStore.isVideoOn
                                        ? buttonColor
                                        : defaultColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: SvgPicture.asset(
                                    _previewStore.isVideoOn
                                        ? "assets/icons/cam_state_on.svg"
                                        : "assets/icons/cam_state_off.svg",
                                    color: _previewStore.isVideoOn
                                        ? defaultColor
                                        : Colors.black,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (_previewStore.networkQuality != null &&
                                _previewStore.networkQuality != -1)
                              GestureDetector(
                                onTap: () {
                                  switch (_previewStore.networkQuality) {
                                    case 0:
                                      Utilities.showToast("Very Bad network");
                                      break;
                                    case 1:
                                      Utilities.showToast("Poor network");
                                      break;
                                    case 2:
                                      Utilities.showToast("Bad network");
                                      break;
                                    case 3:
                                      Utilities.showToast("Average network");
                                      break;
                                    case 4:
                                      Utilities.showToast("Good network");
                                      break;
                                    case 5:
                                      Utilities.showToast("Best network");
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: dividerColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      border: Border.all(color: borderColor)),
                                  child: SvgPicture.asset(
                                    'assets/icons/network_${_previewStore.networkQuality}.svg',
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(color: borderColor)),
                                child: SvgPicture.asset(
                                  "assets/icons/settings.svg",
                                  color: defaultColor,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: width * 0.5,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(surfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () async {
                          context.read<PreviewStore>().removePreviewListener();
                          _previewStore.hmsSDKInteractor.mirrorCamera = true;
                          _previewStore.hmsSDKInteractor.showStats = false;
                          _previewStore.hmsSDKInteractor.skipPreview = false;
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => ListenableProvider.value(
                                        value: MeetingStore(
                                          hmsSDKInteractor:
                                              _previewStore.hmsSDKInteractor,
                                        ),
                                        child: MeetingPage(
                                          roomId: widget.roomId,
                                          flow: MeetingFlow.join,
                                          user: widget.name,
                                          isAudioOn: _previewStore.isAudioOn,
                                          localPeerNetworkQuality:
                                              _previewStore.networkQuality,
                                        ),
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Enter Studio',
                                  style: GoogleFonts.inter(
                                      color: enabledTextColor,
                                      height: 1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: enabledTextColor,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
