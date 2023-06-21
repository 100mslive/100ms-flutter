import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_embedded_button.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_button.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/home_screen/screen_controller.dart';
import 'package:hmssdk_flutter_example/preview/preview_device_settings.dart';
import 'package:hmssdk_flutter_example/preview/preview_participant_sheet.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String meetingLink;
  final MeetingFlow meetingFlow;

  PreviewPage(
      {required this.name,
      required this.meetingLink,
      required this.meetingFlow});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late MeetingStore _meetingStore;
  @override
  void initState() {
    super.initState();
    initPreview();
  }

  void setMeetingStore(PreviewStore _previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: _previewStore.hmsSDKInteractor,
    );
  }

  void initPreview() async {
    HMSException? ans = await context
        .read<PreviewStore>()
        .startPreview(userName: widget.name, meetingLink: widget.meetingLink);
    if (ans != null) {
      UtilityComponents.showErrorDialog(
          context: context,
          errorMessage: "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
          errorTitle: ans.message ?? "Join Error",
          actionMessage: "OK",
          action: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final _previewStore = context.watch<PreviewStore>();
    return WillPopScope(
      onWillPop: () async {
        _previewStore.leave();
        return true;
      },
      child: Selector<PreviewStore, HMSException?>(
          selector: (_, previewStore) => previewStore.error,
          builder: (_, error, __) {
            if (error != null) {
              if ((error.code?.errorCode == 1003) ||
                  (error.code?.errorCode == 2000) ||
                  (error.code?.errorCode == 4005)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UtilityComponents.showErrorDialog(
                      context: context,
                      errorMessage:
                          "Error Code: ${error.code?.errorCode ?? ""} ${error.description}",
                      errorTitle: error.message ?? "",
                      actionMessage: "Leave Room",
                      action: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                });
              } else {
                Utilities.showToast(
                    "Error : ${error.code?.errorCode ?? ""} ${error.description} ${error.message}",
                    time: 5);
              }
            }
            return Scaffold(
              body: Stack(
                children: [
                  (_previewStore.peer == null)
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : (_previewStore.peer!.role.name.contains("hls-"))
                          ? Container(
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
                            )
                          : (_previewStore.localTracks.isEmpty &&
                                  _previewStore.isVideoOn)
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
                                          scaleType:
                                              ScaleType.SCALE_ASPECT_FILL,
                                          track: _previewStore.localTracks[0],
                                          setMirror: true,
                                        )
                                      : Container(
                                          child: Center(
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    defaultAvatarColor,
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
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: orientation == Orientation.portrait
                                    ? width * 0.1
                                    : width * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<PreviewStore>()
                                                .leave();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          icon: Icon(Icons.arrow_back_ios)),
                                      TitleText(
                                          text: "Configure",
                                          textColor: themeDefaultColor),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      HMSEmbeddedButton(
                                        height: 40,
                                        width: 40,
                                        onTap: () async => Platform.isAndroid
                                            ? showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    themeBottomSheetColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                context: context,
                                                builder: (ctx) =>
                                                    ChangeNotifierProvider.value(
                                                        value: _previewStore,
                                                        child:
                                                            PreviewDeviceSettings()),
                                              )
                                            : _previewStore.toggleSpeaker(),
                                        offColor: themeHintColor,
                                        onColor: themeScreenBackgroundColor,
                                        isActive: true,
                                        child: SvgPicture.asset(
                                          !_previewStore.isRoomMute
                                              ? "assets/icons/speaker_state_on.svg"
                                              : "assets/icons/speaker_state_off.svg",
                                          color: themeDefaultColor,
                                          fit: BoxFit.scaleDown,
                                          semanticsLabel: "fl_mute_room_btn",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      badge.Badge(
                                        badgeAnimation:
                                            badge.BadgeAnimation.fade(),
                                        badgeStyle: badge.BadgeStyle(
                                            badgeColor: hmsdefaultColor),
                                        badgeContent: Text(
                                            "${_previewStore.peerCount.toString()}"),
                                        child: HMSEmbeddedButton(
                                          height: 40,
                                          width: 40,
                                          onTap: () async =>
                                              showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor:
                                                themeBottomSheetColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            context: context,
                                            builder: (ctx) =>
                                                ChangeNotifierProvider.value(
                                                    value: context
                                                        .read<PreviewStore>(),
                                                    child:
                                                        PreviewParticipantSheet()),
                                          ),
                                          offColor: themeHintColor,
                                          onColor: themeScreenBackgroundColor,
                                          isActive: true,
                                          child: SvgPicture.asset(
                                            "assets/icons/participants.svg",
                                            color: themeDefaultColor,
                                            fit: BoxFit.scaleDown,
                                            semanticsLabel:
                                                "fl_participants_btn",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 8, right: 8),
                          child: (_previewStore.peer != null)
                              ? Column(
                                  children: [
                                    if (_previewStore.peer != null &&
                                        !_previewStore.peer!.role.name
                                            .contains("hls-"))
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async =>
                                                      _previewStore
                                                          .toggleMicMuteState(),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      _previewStore.isAudioOn,
                                                  child: SvgPicture.asset(
                                                    _previewStore.isAudioOn
                                                        ? "assets/icons/mic_state_on.svg"
                                                        : "assets/icons/mic_state_off.svg",
                                                    color:
                                                        _previewStore.isAudioOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "audio_mute_button",
                                                  ),
                                                ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              if (_previewStore.peer != null &&
                                                  _previewStore.peer!.role
                                                      .publishSettings!.allowed
                                                      .contains("video"))
                                                HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async => (_previewStore
                                                          .localTracks.isEmpty)
                                                      ? null
                                                      : _previewStore
                                                          .toggleCameraMuteState(),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      _previewStore.isVideoOn,
                                                  child: SvgPicture.asset(
                                                    _previewStore.isVideoOn
                                                        ? "assets/icons/cam_state_on.svg"
                                                        : "assets/icons/cam_state_off.svg",
                                                    color:
                                                        _previewStore.isVideoOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "video_mute_button",
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (_previewStore
                                                          .networkQuality !=
                                                      null &&
                                                  _previewStore
                                                          .networkQuality !=
                                                      -1)
                                                HMSEmbeddedButton(
                                                    height: 40,
                                                    width: 40,
                                                    onTap: () {
                                                      switch (_previewStore
                                                          .networkQuality) {
                                                        case 0:
                                                          Utilities.showToast(
                                                              "Very Bad network");
                                                          break;
                                                        case 1:
                                                          Utilities.showToast(
                                                              "Poor network");
                                                          break;
                                                        case 2:
                                                          Utilities.showToast(
                                                              "Bad network");
                                                          break;
                                                        case 3:
                                                          Utilities.showToast(
                                                              "Average network");
                                                          break;
                                                        case 4:
                                                          Utilities.showToast(
                                                              "Good network");
                                                          break;
                                                        case 5:
                                                          Utilities.showToast(
                                                              "Best network");
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    offColor: dividerColor,
                                                    onColor: dividerColor,
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/network_${_previewStore.networkQuality}.svg',
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "network_button",
                                                    )),
                                            ],
                                          )
                                        ],
                                      ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    HMSButton(
                                      width: width * 0.5,
                                      onPressed: () async => {
                                        context
                                            .read<PreviewStore>()
                                            .removePreviewListener(),
                                        setMeetingStore(_previewStore),
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ListenableProvider.value(
                                                      value: _meetingStore,
                                                      child: ScreenController(
                                                        isRoomMute:
                                                            _previewStore
                                                                .isRoomMute,
                                                        isStreamingLink:
                                                            widget.meetingFlow ==
                                                                    MeetingFlow
                                                                        .meeting
                                                                ? false
                                                                : true,
                                                        meetingLink:
                                                            widget.meetingLink,
                                                        localPeerNetworkQuality:
                                                            _previewStore
                                                                .networkQuality,
                                                        user: widget.name,
                                                        role: _previewStore
                                                            .peer?.role,
                                                        config: _previewStore
                                                            .roomConfig,
                                                      ),
                                                    )))
                                        // }
                                      },
                                      childWidget: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 16, 8, 16),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Enter Studio',
                                                style: GoogleFonts.inter(
                                                    color: enabledTextColor,
                                                    height: 1,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
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
                                  ],
                                )
                              : SizedBox())
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
