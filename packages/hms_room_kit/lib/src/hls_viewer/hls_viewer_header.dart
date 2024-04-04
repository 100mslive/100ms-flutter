library;

///Dart imports
import 'dart:developer';
import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HLSViewerHeader] is the header of the HLS Viewer screen
class HLSViewerHeader extends StatelessWidget {
  const HLSViewerHeader({super.key});

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
        padding: EdgeInsets.only(left: 12, right: 12, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
          ],
        ),
      ),
    );
  }
}
