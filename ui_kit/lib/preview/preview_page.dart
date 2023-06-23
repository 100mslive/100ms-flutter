import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/preview/preview_device_settings.dart';
import 'package:hmssdk_uikit/preview/preview_participant_sheet.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_page.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String meetingLink;

  const PreviewPage({super.key, required this.name, required this.meetingLink});
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

  void setMeetingStore(PreviewStore previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: previewStore.hmsSDKInteractor,
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
            Navigator.popUntil(context, (route) => route.isFirst);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final previewStore = context.watch<PreviewStore>();
    return WillPopScope(
      onWillPop: () async {
        previewStore.leave();
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
                  (previewStore.peer == null)
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : (previewStore.peer!.role.name.contains("hls-"))
                          ? Container(
                              child: Center(
                                child: CircleAvatar(
                                    backgroundColor: defaultAvatarColor,
                                    radius: 40,
                                    child: Text(
                                      Utilities.getAvatarTitle(
                                          previewStore.peer!.name),
                                      style: GoogleFonts.inter(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            )
                          : (previewStore.localTracks.isEmpty &&
                                  previewStore.isVideoOn)
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox(
                                  height: height,
                                  width: width,
                                  child: (previewStore.isVideoOn)
                                      ? HMSVideoView(
                                          scaleType:
                                              ScaleType.SCALE_ASPECT_FILL,
                                          track: previewStore.localTracks[0],
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
                                                      previewStore.peer!.name),
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
                                          icon:
                                              const Icon(Icons.arrow_back_ios)),
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
                                                        value: previewStore,
                                                        child:
                                                            const PreviewDeviceSettings()),
                                              )
                                            : previewStore.toggleSpeaker(),
                                        offColor: themeHintColor,
                                        onColor: themeScreenBackgroundColor,
                                        isActive: true,
                                        child: SvgPicture.asset(
                                          !previewStore.isRoomMute
                                              ? "assets/icons/speaker_state_on.svg"
                                              : "assets/icons/speaker_state_off.svg",
                                          color: themeDefaultColor,
                                          fit: BoxFit.scaleDown,
                                          semanticsLabel: "fl_mute_room_btn",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      badge.Badge(
                                        badgeAnimation:
                                            const badge.BadgeAnimation.fade(),
                                        badgeStyle: badge.BadgeStyle(
                                            badgeColor: hmsdefaultColor),
                                        badgeContent: Text(
                                            previewStore.peerCount.toString()),
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
                                                        const PreviewParticipantSheet()),
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
                                      const SizedBox(
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
                          child: (previewStore.peer != null)
                              ? Column(
                                  children: [
                                    if (previewStore.peer != null &&
                                        !previewStore.peer!.role.name
                                            .contains("hls-"))
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if (previewStore.peer != null &&
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
                                                      previewStore
                                                          .toggleMicMuteState(),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isAudioOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isAudioOn
                                                        ? "assets/icons/mic_state_on.svg"
                                                        : "assets/icons/mic_state_off.svg",
                                                    color:
                                                        previewStore.isAudioOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "audio_mute_button",
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (previewStore.peer != null &&
                                                  previewStore.peer!.role
                                                      .publishSettings!.allowed
                                                      .contains("video"))
                                                HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async => (previewStore
                                                          .localTracks.isEmpty)
                                                      ? null
                                                      : previewStore
                                                          .toggleCameraMuteState(),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isVideoOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isVideoOn
                                                        ? "assets/icons/cam_state_on.svg"
                                                        : "assets/icons/cam_state_off.svg",
                                                    color:
                                                        previewStore.isVideoOn
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
                                              if (previewStore.networkQuality !=
                                                      null &&
                                                  previewStore.networkQuality !=
                                                      -1)
                                                HMSEmbeddedButton(
                                                    height: 40,
                                                    width: 40,
                                                    onTap: () {
                                                      switch (previewStore
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
                                                      'assets/icons/network_${previewStore.networkQuality}.svg',
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "network_button",
                                                    )),
                                            ],
                                          )
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    HMSButton(
                                      width: width * 0.5,
                                      onPressed: () async => {
                                        context
                                            .read<PreviewStore>()
                                            .removePreviewListener(),
                                        setMeetingStore(previewStore),
                                        _meetingStore.join(
                                            widget.name, widget.meetingLink,
                                            roomConfig:
                                                previewStore.roomConfig),
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ListenableProvider.value(
                                                      value: _meetingStore,
                                                      child: MeetingPage(
                                                          meetingLink: widget
                                                              .meetingLink),
                                                    )))
                                      },
                                      childWidget: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 16, 8, 16),
                                        decoration: const BoxDecoration(
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
                                            const SizedBox(
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
                              : const SizedBox())
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
