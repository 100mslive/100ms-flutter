///Dart imports
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[HLSViewerHeader] is the header of the HLS Viewer screen
class HLSViewerHeader extends StatelessWidget {
  const HLSViewerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            HMSThemeColors.backgroundDim.withAlpha(64),
            HMSThemeColors.backgroundDim.withAlpha(0)
          ])),
      child: Padding(
        padding:
            EdgeInsets.only(left: 15, right: 15, top: Platform.isIOS ? 55 : 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ///We render the logo as set in the dashboard
                HMSRoomLayout.roleLayoutData?.logo?.url == null
                    ? Container()
                    : HMSRoomLayout.roleLayoutData!.logo!.url!.contains("svg")
                        ? SvgPicture.network(
                            HMSRoomLayout.roleLayoutData!.logo!.url!)
                        : Image.network(
                            HMSRoomLayout.roleLayoutData!.logo!.url!,
                            height: 30,
                            width: 30,
                          ),
                const SizedBox(
                  width: 12,
                ),

                ///We render the LIVE icon based on the HLS streaming status
                ///If the HLS streaming is started we show the LIVE icon
                ///If the HLS streaming is not started we show nothing
                Selector<MeetingStore, bool>(
                    selector: (_, meetingStore) =>
                        meetingStore.streamingType['hls'] ?? false,
                    builder: (_, isHLSStarted, __) {
                      return isHLSStarted
                          ? Container(
                              height: 24,
                              width: 43,
                              decoration: BoxDecoration(
                                  color: HMSThemeColors.alertErrorDefault,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Center(
                                child: HMSTitleText(
                                    text: "LIVE",
                                    fontSize: 10,
                                    lineHeight: 16,
                                    letterSpacing: 1.5,
                                    textColor:
                                        HMSThemeColors.alertErrorBrighter),
                              ),
                            )
                          : Container();
                    }),
                const SizedBox(
                  width: 8,
                ),

                ///We render the recording icon based on the recording status
                ///If the recording is started we show the recording icon
                ///If the recording is not started we show nothing
                ///
                ///If recording initialising state is true we show the loader
                Selector<MeetingStore, Tuple4<bool, bool, bool, bool>>(
                    selector: (_, meetingStore) => Tuple4(
                        meetingStore.recordingType["browser"] ?? false,
                        meetingStore.recordingType["server"] ?? false,
                        meetingStore.recordingType["hls"] ?? false,
                        meetingStore.isRecordingInInitialisingState),
                    builder: (_, data, __) {
                      return (data.item1 || data.item2 || data.item3)
                          ? SvgPicture.asset(
                              "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.alertErrorDefault,
                                  BlendMode.srcIn),
                            )
                          : data.item4
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: HMSThemeColors.onSurfaceHighEmphasis,
                                  ))
                              : Container();
                    }),
                const SizedBox(
                  width: 8,
                ),

                ///This renders the number of peers
                ///If the HLS streaming is started, we render the number of peers
                ///else we render an empty Container
                Selector<MeetingStore, Tuple2<bool, int>>(
                    selector: (_, meetingStore) => Tuple2(
                        meetingStore.streamingType['hls'] ?? false,
                        meetingStore.peersInRoom),
                    builder: (_, data, __) {
                      return data.item1
                          ? Container(
                              width: 59,
                              height: 24,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: HMSThemeColors.borderBright,
                                      width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color: HMSThemeColors.backgroundDim
                                      .withOpacity(0.64)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/watching.svg",
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    semanticsLabel: "fl_watching",
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  HMSTitleText(
                                      text: Utilities.formatNumber(data.item2),
                                      fontSize: 10,
                                      lineHeight: 10,
                                      letterSpacing: 1.5,
                                      textColor:
                                          HMSThemeColors.onSurfaceHighEmphasis)
                                ],
                              ))
                          : Container();
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
