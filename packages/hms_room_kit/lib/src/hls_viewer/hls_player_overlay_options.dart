library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

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

        CircleAvatar(
          backgroundColor: Colors.red,
          child: Container(
            child: SvgPicture.asset(
                              "packages/hms_room_kit/lib/src/assets/icons/resume.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onSurfaceMediumEmphasis,
                                  BlendMode.srcIn),
                            ),
          ),
        ),

        ///Renders the bottom navigation bar if the HLS has started
        ///Otherwise does not render the bottom navigation bar
        hasHLSStarted ? HLSViewerBottomNavigationBar() : const SizedBox()
      ],
    );
  }
}
