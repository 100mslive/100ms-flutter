import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/preview/preview_store.dart';
import 'package:hms_room_kit/service/app_debug_config.dart';

class PreviewJoinButton extends StatelessWidget {
  final PreviewStore previewStore;
  const PreviewJoinButton({super.key, required this.previewStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.fromLTRB(2, 16, 2, 16),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: AppDebugConfig.isStreamingFlow &&
              (previewStore.peer?.role.permissions.hlsStreaming ?? false) &&
              !previewStore.isHLSStreamingStarted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "packages/hms_room_kit/lib/assets/icons/live.svg",
                  height: 20,
                  colorFilter:
                      ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text('Go Live',
                    style: GoogleFonts.inter(
                        color: onPrimaryHighEmphasis,
                        height: 1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            )
          : Text('Join Now',
              style: GoogleFonts.inter(
                  color: onPrimaryHighEmphasis,
                  height: 1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
    );
  }
}
