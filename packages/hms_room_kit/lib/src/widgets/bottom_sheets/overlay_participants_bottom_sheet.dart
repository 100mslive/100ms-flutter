import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';

class OverlayParticipantsBottomSheet extends StatefulWidget {
  const OverlayParticipantsBottomSheet({Key? key}) : super(key: key);

  @override
  State<OverlayParticipantsBottomSheet> createState() =>
      _OverlayParticipantsBottomSheetState();
}

class _OverlayParticipantsBottomSheetState
    extends State<OverlayParticipantsBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<MeetingStore, int>(
                    selector: (_, meetingStore) => meetingStore.peersInRoom,
                    builder: (_, peersInRoom, __) {
                      return HMSSubheadingText(
                        text: "Participants ($peersInRoom)",
                        textColor: HMSThemeColors.onSurfaceHighEmphasis,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                const HMSCrossButton(),
              ],
            ),
            const Expanded(child: ParticipantsBottomSheet())
          ],
        ),
      ),
    ));
  }
}
