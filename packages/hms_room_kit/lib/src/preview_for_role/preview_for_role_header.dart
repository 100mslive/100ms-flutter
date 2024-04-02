///Dart imports
library;

import 'dart:developer';

///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[PreviewForRoleHeader] is the header of the PreviewForRole screen
///It shows the logo, the LIVE icon and the number of participants
class PreviewForRoleHeader extends StatefulWidget {
  const PreviewForRoleHeader({super.key});

  @override
  State<PreviewForRoleHeader> createState() => _PreviewForRoleHeaderState();
}

class _PreviewForRoleHeaderState extends State<PreviewForRoleHeader> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 24,
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
                          errorBuilder: (context, exception, _) {
                            log('Error is $exception');
                            return const SizedBox(
                              width: 30,
                              height: 30,
                            );
                          },
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
                      meetingStore.streamingType['hls'] ==
                      HMSStreamingState.started,
                  builder: (_, isHLSStrted, __) {
                    return isHLSStrted
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
                                  textColor: HMSThemeColors.alertErrorBrighter),
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
                            HMSRecordingState.none,
                      ),
                  builder: (_, data, __) {
                    return (data.item1 == HMSRecordingState.started ||
                            data.item1 == HMSRecordingState.resumed ||
                            data.item2 == HMSRecordingState.started ||
                            data.item2 == HMSRecordingState.resumed ||
                            data.item3 == HMSRecordingState.started ||
                            data.item3 == HMSRecordingState.resumed)
                        ? SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.alertErrorDefault,
                                BlendMode.srcIn),
                          )
                        : Container();
                  }),
              const SizedBox(
                width: 8,
              ),

              ///This renders the number of peers
              ///If the HLS or RTMP streaming is started, we render the number of peers
              ///else we render an empty Container
              Selector<MeetingStore, Tuple2<bool, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.streamingType['hls'] ==
                              HMSStreamingState.started ||
                          meetingStore.streamingType['rtmp'] ==
                              HMSStreamingState.started,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
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
    );
  }
}
