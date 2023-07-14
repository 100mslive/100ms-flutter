// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/widgets/common_widgets/title_text.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';

// Project imports

class RoleChangeRequestDialog extends StatefulWidget {
  final HMSRoleChangeRequest roleChangeRequest;
  final MeetingStore meetingStore;
  const RoleChangeRequestDialog(
      {super.key, required this.roleChangeRequest, required this.meetingStore});

  @override
  _RoleChangeRequestDialogState createState() =>
      _RoleChangeRequestDialogState();
}

class _RoleChangeRequestDialogState extends State<RoleChangeRequestDialog> {
  @override
  Widget build(BuildContext context) {
    String message =
        "‘${widget.roleChangeRequest.suggestedBy?.name ?? "Anonymus"}’ requested to change your role to ‘${widget.roleChangeRequest.suggestedRole.name}’";
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: GoogleFonts.inter(
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor:
                      MaterialStateProperty.all(themeBottomSheetColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: popupButtonBorderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: TitleText(text: 'Reject', textColor: themeDefaultColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor: MaterialStateProperty.all(colorScheme.error),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: colorScheme.error),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: TitleText(
                  text: 'Accept',
                  textColor: themeDefaultColor,
                ),
              ),
              onPressed: () {
                widget.meetingStore.acceptChangeRole(widget.roleChangeRequest);
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
