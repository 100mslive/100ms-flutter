library;

///Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_stream_description.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';

///[HLSPlayerDesktopControls] is the desktop controls for the HLS Player
class HLSPlayerDesktopControls extends StatefulWidget {
  final Orientation orientation;
  const HLSPlayerDesktopControls({Key? key, required this.orientation})
      : super(key: key);

  @override
  State<HLSPlayerDesktopControls> createState() =>
      _HLSPlayerDesktopControlsState();
}

class _HLSPlayerDesktopControlsState extends State<HLSPlayerDesktopControls> {
  bool showDescription = false;

  ///[toggleDescription] toggles the visibility of description
  void toggleDescription() {
    setState(() {
      showDescription = !showDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Renders HLS Stream Description and Chat Bottom Sheet
        widget.orientation == Orientation.portrait
            ? HLSStreamDescription(
                showDescription: showDescription,
                toggleDescription: toggleDescription)
            : const SizedBox(),

        ///Renders Chat Bottom Sheet only if the description is not visible
        if (!showDescription)
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: const ChatBottomSheet(
              isHLSChat: true,
            ),
          ))
      ],
    );
  }
}
