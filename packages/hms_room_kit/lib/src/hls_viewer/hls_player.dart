library;

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_waiting_ui.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

///[HLSPlayer] is a component that is used to show the HLS Player
class HLSPlayer extends StatelessWidget {
  const HLSPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///We use the hlsAspectRatio from the [MeetingStore] to set the aspect ratio of the player
    ///By default the aspect ratio is 9:16
    return Selector<MeetingStore, bool>(
        selector: (_, meetingStore) => meetingStore.hasHlsStarted,
        builder: (_, hasHLSStarted, __) {
          return Stack(
            children: [
              ///Renders the HLS Player if the HLS has started
              ///Otherwise renders the waiting UI
              hasHLSStarted
                  ? InkWell(
                      enableFeedback: false,
                      canRequestFocus: false,
                      splashColor: HMSThemeColors.backgroundDim,

                      ///Toggles the visibility of the stream controls
                      onTap: () {
                        context
                            .read<HLSPlayerStore>()
                            .toggleButtonsVisibility();
                      },
                      child: IgnorePointer(
                        child: HMSHLSPlayer(
                          key: key,
                          showPlayerControls: false,
                          isHLSStatsRequired:
                              context.read<MeetingStore>().isHLSStatsEnabled,
                        ),
                      ),
                    )
                  : Center(child: const HLSWaitingUI()),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HLSViewerHeader(
                    hasHLSStarted: hasHLSStarted,
                  ),

                  ///Renders the bottom navigation bar if the HLS has started
                  ///Otherwise does not render the bottom navigation bar
                  hasHLSStarted
                      ? HLSViewerBottomNavigationBar()
                      : const SizedBox()
                ],
              )
            ],
          );
        });
  }
}
