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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HLSViewerHeader(
          hasHLSStarted: hasHLSStarted,
        ),

        ///This renders the pause/play button
        hasHLSStarted ? HLSViewerMidSection() : const SizedBox(),

        ///Renders the bottom navigation bar if the HLS has started
        ///Otherwise does not render the bottom navigation bar
        hasHLSStarted ? HLSViewerBottomNavigationBar() : const SizedBox()
      ],
    );
  }
}
