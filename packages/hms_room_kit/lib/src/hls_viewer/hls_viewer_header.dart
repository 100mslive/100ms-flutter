import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerHeader extends StatelessWidget {
  const HLSViewerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 15, right: 15, top: Platform.isIOS ? 55 : 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              HMSRoomLayout.data?[0].logo?.url == null
                  ? Container()
                  : HMSRoomLayout.data![0].logo!.url!.contains("svg")
                      ? SvgPicture.network(HMSRoomLayout.data![0].logo!.url!)
                      : Image.network(
                          HMSRoomLayout.data![0].logo!.url!,
                          height: 30,
                          width: 30,
                        ),
              const SizedBox(
                width: 12,
              ),
              Selector<MeetingStore, Tuple3<bool, bool, bool>>(
                  selector: (_, meetingStore) => Tuple3(
                        meetingStore.recordingType["browser"] ?? false,
                        meetingStore.recordingType["server"] ?? false,
                        meetingStore.recordingType["hls"] ?? false,
                      ),
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
                        : Container();
                  }),
              const SizedBox(
                width: 8,
              ),
              Selector<MeetingStore, bool>(
                  selector: (_, meetingStore) =>
                      meetingStore.streamingType['hls'] ?? false,
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
              Selector<MeetingStore, Tuple2<bool, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.streamingType['hls'] ?? false,
                      meetingStore.peers.length),
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
                                    text: data.item2.toString(),
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
