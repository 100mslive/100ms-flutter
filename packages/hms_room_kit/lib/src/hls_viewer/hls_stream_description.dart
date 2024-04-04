import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_stream_timer.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class HLSStreamDescription extends StatefulWidget {
  @override
  State<HLSStreamDescription> createState() => _HLSStreamDescriptionState();
}

class _HLSStreamDescriptionState extends State<HLSStreamDescription> {
  bool showDescription = false;

  void toggleDescription() {
    setState(() {
      showDescription = !showDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (showDescription)
              GestureDetector(
                onTap: () => toggleDescription(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: HMSTitleText(
                          text: "About Session",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          letterSpacing: 0 / 15,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            if (showDescription)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Divider(
                  color: HMSThemeColors.borderBright,
                  height: 2,
                ),
              ),
            Row(
              children: [
                ///This renders the logo
                ///If the logo is null, we render an empty SizedBox
                ///If the logo is an svg, we render the svg
                ///If the logo is an image, we render the image
                HMSRoomLayout.roleLayoutData?.logo?.url == null
                    ? Container()
                    : HMSRoomLayout.roleLayoutData!.logo!.url!.contains("svg")
                        ? SvgPicture.network(
                            HMSRoomLayout.roleLayoutData!.logo!.url!,
                            height: 32,
                            width: 32,
                          )
                        : Image.network(
                            HMSRoomLayout.roleLayoutData!.logo!.url!,
                            errorBuilder: (context, exception, _) {
                              log('Error is $exception');
                              return const SizedBox(
                                width: 32,
                                height: 32,
                              );
                            },
                            height: 32,
                            width: 32,
                          ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    if ((HMSRoomLayout.roleLayoutData?.screens?.conferencing
                            ?.hlsLiveStreaming?.elements?.header?.description !=
                        null)) {
                      toggleDescription();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HMSSubheadingText(
                        text: HMSRoomLayout
                                .roleLayoutData
                                ?.screens
                                ?.conferencing
                                ?.hlsLiveStreaming
                                ?.elements
                                ?.header
                                ?.title ??
                            "",
                        textColor: HMSThemeColors.onSecondaryHighEmphasis,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          ///This renders the number of peers
                          ///If the HLS streaming is started, we render the number of peers
                          ///else we render an empty Container
                          Selector<MeetingStore, int>(
                              selector: (_, meetingStore) =>
                                  meetingStore.peersInRoom,
                              builder: (_, data, __) {
                                return HMSSubtitleText(
                                    text: Utilities.formatNumber(data) +
                                        " watching",
                                    letterSpacing: 0.4,
                                    textColor:
                                        HMSThemeColors.onSurfaceMediumEmphasis);
                              }),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SvgPicture.asset(
                              "packages/hms_room_kit/lib/src/assets/icons/red_dot.svg",
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSurfaceHighEmphasis,
                                  BlendMode.srcIn),
                            ),
                          ),
                          HLSStreamTimer(),

                          ///This renders the recording status
                          ///If the recording is started, we render the recording indicator
                          ///else we render an empty Container
                          ///
                          ///For recording status we use the recordingType map from the [MeetingStore]
                          Selector<
                                  MeetingStore,
                                  Tuple3<HMSRecordingState, HMSRecordingState,
                                      HMSRecordingState>>(
                              selector: (_, meetingStore) => Tuple3(
                                  meetingStore.recordingType["browser"] ??
                                      HMSRecordingState.none,
                                  meetingStore.recordingType["server"] ??
                                      HMSRecordingState.none,
                                  meetingStore.recordingType["hls"] ??
                                      HMSRecordingState.none),
                              builder: (_, data, __) {
                                return (data.item1 ==
                                            HMSRecordingState.started ||
                                        data.item1 ==
                                            HMSRecordingState.resumed ||
                                        data.item2 ==
                                            HMSRecordingState.started ||
                                        data.item2 ==
                                            HMSRecordingState.resumed ||
                                        data.item3 ==
                                            HMSRecordingState.started ||
                                        data.item3 == HMSRecordingState.resumed)
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SvgPicture.asset(
                                              "packages/hms_room_kit/lib/src/assets/icons/red_dot.svg",
                                              colorFilter: ColorFilter.mode(
                                                  HMSThemeColors
                                                      .onSurfaceHighEmphasis,
                                                  BlendMode.srcIn),
                                            ),
                                          ),
                                          HMSSubtitleText(
                                            text: "Recording",
                                            letterSpacing: 0.4,
                                            textColor: HMSThemeColors
                                                .onSurfaceMediumEmphasis,
                                          ),
                                        ],
                                      )
                                    : (HMSRoomLayout
                                                .roleLayoutData
                                                ?.screens
                                                ?.conferencing
                                                ?.hlsLiveStreaming
                                                ?.elements
                                                ?.header
                                                ?.description !=
                                            null)
                                        ? HMSSubtitleText(
                                            text: " ...more",
                                            textColor: HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            letterSpacing: 0.4,
                                          )
                                        : const SizedBox();
                              }),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            if (!showDescription)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Divider(
                  color: HMSThemeColors.borderBright,
                  height: 2,
                ),
              ),
            if (showDescription &&
                (HMSRoomLayout.roleLayoutData?.screens?.conferencing
                        ?.hlsLiveStreaming?.elements?.header?.description !=
                    null))
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                    child: SelectableLinkify(
                  text: HMSRoomLayout.roleLayoutData?.screens?.conferencing
                          ?.hlsLiveStreaming?.elements?.header?.description ??
                      "",
                  style: HMSTextStyle.setTextStyle(
                    fontSize: 14.0,
                    color: HMSThemeColors.onSurfaceMediumEmphasis,
                    letterSpacing: 0.25,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                  ),
                  linkStyle: HMSTextStyle.setTextStyle(
                      fontSize: 14.0,
                      color: HMSThemeColors.primaryBright,
                      letterSpacing: 0.25,
                      height: 20 / 14,
                      fontWeight: FontWeight.w400),
                  onOpen: (link) async {
                    Uri url = Uri.parse(link.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                )),
              )
          ],
        ),
      ),
    );
  }
}
