library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_webview.dart';

///[WhiteboardTile] is a widget that renders the whiteboard tile
class WhiteboardTile extends StatefulWidget {
  const WhiteboardTile({Key? key}) : super(key: key);
  @override
  State<WhiteboardTile> createState() => _WhiteboardTileState();
}

class _WhiteboardTileState extends State<WhiteboardTile> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const WhiteboardWebView(),
        Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                context.read<WhiteboardScreenshareStore>().toggleFullScreen();
              },
              child: PointerInterceptor(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDim.withAlpha(64),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Selector<WhiteboardScreenshareStore, bool>(
                        selector: (_, whiteboardScreenshareStore) =>
                            whiteboardScreenshareStore.isFullScreen,
                        builder: (_, isFullScreen, __) {
                          return SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/${isFullScreen ? "minimize" : "maximize"}.svg",
                            height: 16,
                            width: 16,
                            semanticsLabel: "maximize_label",
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          );
                        }),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
