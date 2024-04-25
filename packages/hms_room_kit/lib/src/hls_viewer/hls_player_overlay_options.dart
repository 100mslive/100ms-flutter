library;

///Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_mid_section.dart';

///[HLSPlayerOverlayOptions] renders the overlay options for the HLS Player
class HLSPlayerOverlayOptions extends StatelessWidget {
  final bool hasHLSStarted;

  const HLSPlayerOverlayOptions({super.key, required this.hasHLSStarted});
  @override
  Widget build(BuildContext context) {
    ///Here top and bottom navigation bar are in Column
    ///while mid section is above the Column
    ///This is done to avoid overflowing in case of
    ///large transcription
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HLSViewerHeader(
              hasHLSStarted: hasHLSStarted,
            ),

            ///Renders the bottom navigation bar if the HLS has started
            ///Otherwise does not render the bottom navigation bar
            hasHLSStarted ? HLSViewerBottomNavigationBar() : const SizedBox()
          ],
        ),

        ///This renders the pause/play button
        Align(
          alignment: Alignment.center,
          child: hasHLSStarted ? HLSViewerMidSection() : const SizedBox(),
        )
      ],
    );
  }
}
