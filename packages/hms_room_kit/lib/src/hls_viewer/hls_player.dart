library;

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
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
    return Stack(
      children: [
        HMSHLSPlayer(
          key: key,
          showPlayerControls: false,
          isHLSStatsRequired:
              context.read<MeetingStore>().isHLSStatsEnabled,
        ),
        HLSViewerHeader()
      ],
    );
  }
}
