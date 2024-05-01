library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/hls_viewer_quality_selector_bottom_sheet.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:tuple/tuple.dart';

///[HLSViewerHeader] is the header of the HLS Viewer screen
class HLSViewerHeader extends StatelessWidget {
  final bool hasHLSStarted;
  const HLSViewerHeader({super.key, required this.hasHLSStarted});

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
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Selector<HLSPlayerStore, bool>(
            selector: (_, hlsPlayerStore) =>
                hlsPlayerStore.areStreamControlsVisible,
            builder: (_, areStreamControlsVisible, __) {
              return areStreamControlsVisible
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ///This renders the [Close Button] and is always visible iff the controls are visible
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: HMSThemeColors.onSurfaceHighEmphasis,
                                size: 24,
                              ),
                              onPressed: () {
                                UtilityComponents.onBackPressed(context);
                              },
                            )
                          ],
                        ),

                        ///This renders the [Caption Button] and [Settings Button] only if the controls are visible
                        ///and the HLS has started
                        if (hasHLSStarted)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ///The caption button is only rendered when closed captions are supported
                              ///and the HLS has started
                              Selector<HLSPlayerStore, Tuple2<bool, bool>>(
                                  selector: (_, hlsPlayerStore) => Tuple2(
                                      hlsPlayerStore.isCaptionEnabled,
                                      hlsPlayerStore.areCaptionsSupported),
                                  builder: (_, captionsData, __) {
                                    return captionsData.item2
                                        ? InkWell(
                                            onTap: () {
                                              context
                                                  .read<HLSPlayerStore>()
                                                  .toggleCaptions();
                                            },
                                            child: SvgPicture.asset(
                                              "packages/hms_room_kit/lib/src/assets/icons/caption_${captionsData.item1 ? "on" : "off"}.svg",
                                              colorFilter: ColorFilter.mode(
                                                  HMSThemeColors
                                                      .onSurfaceHighEmphasis,
                                                  BlendMode.srcIn),
                                              semanticsLabel:
                                                  "caption_toggle_button",
                                            ),
                                          )
                                        : const SizedBox();
                                  }),

                              ///This will be added later
                              const SizedBox(
                                width: 16,
                              ),

                              ///This renders the settings button
                              GestureDetector(
                                onTap: () {
                                  var _meetingStore =
                                      context.read<MeetingStore>();
                                  var _hlsPlayerStore =
                                      context.read<HLSPlayerStore>();
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (ctx) =>
                                          ChangeNotifierProvider.value(
                                            value: _meetingStore,
                                            child: ChangeNotifierProvider.value(
                                                value: _hlsPlayerStore,
                                                child:
                                                    HLSViewerQualitySelectorBottomSheet()),
                                          ));
                                },
                                child: SvgPicture.asset(
                                  "packages/hms_room_kit/lib/src/assets/icons/settings.svg",
                                  colorFilter: ColorFilter.mode(
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                      BlendMode.srcIn),
                                  semanticsLabel: "caption_toggle_button",
                                ),
                              )
                            ],
                          )
                      ],
                    )
                  : const SizedBox();
            }),
      ),
    );
  }
}
