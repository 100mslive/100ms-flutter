library;

///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_stream_timer.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[HLSStreamDescription] is a widget that is used to render the description of the HLS Stream
class HLSStreamDescription extends StatelessWidget {
  final bool showDescription;
  final Function toggleDescription;

  HLSStreamDescription(
      {Key? key, this.showDescription = false, required this.toggleDescription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ///If [showDescription] is true, we render the description of the HLS Stream
            ///This widget is only rendered if description is present and it's visibility is true
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///This renders the title
                      ///Only renders this if the title is non null and not empty
                      if (HMSRoomLayout
                              .roleLayoutData
                              ?.screens
                              ?.conferencing
                              ?.hlsLiveStreaming
                              ?.elements
                              ?.header
                              ?.title
                              ?.isNotEmpty ??
                          false)
                        Container(
                          child: HMSSubheadingText(
                            text: HMSRoomLayout
                                    .roleLayoutData
                                    ?.screens
                                    ?.conferencing
                                    ?.hlsLiveStreaming
                                    ?.elements
                                    ?.header
                                    ?.title ??
                                "",
                            maxLines: showDescription ? 5 : 2,
                            textColor: HMSThemeColors.onSecondaryHighEmphasis,
                            textOverflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      Row(
                        children: [
                          ///This renders the number of peers watching the stream
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

                          if (context.read<MeetingStore>().hasHlsStarted)
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

                          ///This renders the timer for the HLS Stream
                          ///This is only rendered if the HLS Stream has started
                          ///This shows for how much time you have been watching stream
                          if (context.read<MeetingStore>().hasHlsStarted)
                            HLSStreamTimer(),

                          ///This renders the recording status
                          ///If the recording is started, we render the recording indicator
                          ///else we render an empty Container
                          ///
                          ///For recording status we use the recordingType map from the [MeetingStore]
                          (HMSRoomLayout
                                          .roleLayoutData
                                          ?.screens
                                          ?.conferencing
                                          ?.hlsLiveStreaming
                                          ?.elements
                                          ?.header
                                          ?.description !=
                                      null &&
                                  !showDescription)
                              ? GestureDetector(
                                  onTap: () {
                                    if ((HMSRoomLayout
                                            .roleLayoutData
                                            ?.screens
                                            ?.conferencing
                                            ?.hlsLiveStreaming
                                            ?.elements
                                            ?.header
                                            ?.description !=
                                        null)) {
                                      toggleDescription();
                                    }
                                  },
                                  child: HMSSubtitleText(
                                    text: "  ...more",
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    letterSpacing: 0.4,
                                  ),
                                )
                              : Selector<
                                      MeetingStore,
                                      Tuple3<
                                          HMSRecordingState,
                                          HMSRecordingState,
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
                                            data.item3 ==
                                                HMSRecordingState.resumed)
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                        : const SizedBox();
                                  }),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),

            ///This renders the description of the HLS Stream
            ///This is only rendered if the description is present and the visibility is true
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

                ///Here we use SelectableLinkify to render the description
                ///so that if there is any link in the description, it can be clicked
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.38),
                    child: SelectableLinkify(
                      text: HMSRoomLayout
                              .roleLayoutData
                              ?.screens
                              ?.conferencing
                              ?.hlsLiveStreaming
                              ?.elements
                              ?.header
                              ?.description ??
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
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
