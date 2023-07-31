import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/service/app_debug_config.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

class PreviewJoinButton extends StatelessWidget {
  final PreviewStore previewStore;
  final bool isEmpty;
  final bool isJoining;

  const PreviewJoinButton(
      {super.key,
      required this.previewStore,
      required this.isEmpty,
      required this.isJoining});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: AppDebugConfig.isStreamingFlow &&
              (previewStore.peer?.role.permissions.hlsStreaming ?? false) &&
              !previewStore.isHLSStreamingStarted
          ? isJoining
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: onSurfaceHighEmphasis,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/live.svg",
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                          isEmpty
                              ? onPrimaryLowEmphasis
                              : onPrimaryHighEmphasis,
                          BlendMode.srcIn),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    HMSTitleText(
                      text: 'Go Live',
                      textColor: isEmpty
                          ? onPrimaryLowEmphasis
                          : onPrimaryHighEmphasis,
                    )
                  ],
                )
          : Center(
              child: HMSTitleText(
                text: 'Join Now',
                textColor:
                    isEmpty ? onPrimaryLowEmphasis : onPrimaryHighEmphasis,
              ),
            ),
    );
  }
}
