///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

///This renders the network indicator with the network quality
///
///The network quality is fetched from the [PreviewStore]
///The network quality is shown only if the network quality is not null and not -1
///The network quality is shown only if the [isHidden] is false
class PreviewNetworkIndicator extends StatelessWidget {
  final PreviewStore previewStore;
  const PreviewNetworkIndicator({super.key, required this.previewStore});

  @override
  Widget build(BuildContext context) {
    return ((previewStore.networkQuality != null &&
            previewStore.networkQuality != -1))
        ? Positioned(
            bottom: 168,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HMSThemeColors.backgroundDim.withAlpha(64)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (previewStore.networkQuality != null &&
                        previewStore.networkQuality != -1)
                      SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/network_${previewStore.networkQuality}.svg',
                        fit: BoxFit.contain,
                        semanticsLabel: "fl_network_icon_label",
                      ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
