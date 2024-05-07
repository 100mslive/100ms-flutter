import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerQualitySelectorBottomSheet extends StatefulWidget {
  @override
  State<HLSViewerQualitySelectorBottomSheet> createState() =>
      _HLSViewerQualitySelectorBottomSheetState();
}

class _HLSViewerQualitySelectorBottomSheetState
    extends State<HLSViewerQualitySelectorBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? height * 0.8
            : height * 0.4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: HMSThemeColors.backgroundDefault,
          ),
          child: Selector<HLSPlayerStore,
                  Tuple2<Map<String, HMSHLSLayer>, int>>(
              selector: (_, hlsPlayerStore) => Tuple2(
                  hlsPlayerStore.layerMap, hlsPlayerStore.layerMap.length),
              builder: (context, data, _) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              HMSTitleText(
                                text: "Quality",
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                letterSpacing: 0.15,
                              ),
                            ],
                          ),
                          const Row(
                            children: [HMSCrossButton()],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: HMSThemeColors.borderDefault,
                          height: 5,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: data.item2,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<HLSPlayerStore>().setHLSLayer(
                                      data.item1.entries
                                          .elementAt(index)
                                          .value);
                                  Navigator.pop(context);
                                },
                                child: ListTile(
                                  horizontalTitleGap: 2,
                                  enabled: false,
                                  contentPadding: EdgeInsets.zero,
                                  title: HMSSubtitleText(
                                    text:
                                        data.item1.entries.elementAt(index).key,
                                    fontSize: 14,
                                    lineHeight: 20,
                                    letterSpacing: 0.10,
                                    fontWeight: FontWeight.w600,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                  ),
                                  trailing: context
                                              .read<HLSPlayerStore>()
                                              .selectedLayer ==
                                          data.item1.entries
                                              .elementAt(index)
                                              .value
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: SvgPicture.asset(
                                            "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                            fit: BoxFit.scaleDown,
                                            colorFilter: ColorFilter.mode(
                                                HMSThemeColors
                                                    .onSurfaceHighEmphasis,
                                                BlendMode.srcIn),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 24,
                                          width: 24,
                                        ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
