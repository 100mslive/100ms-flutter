// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class RoleChangeDialogOrganism extends StatefulWidget {
  final HMSRoleChangeRequest roleChangeRequest;

  const RoleChangeDialogOrganism({required this.roleChangeRequest}) : super();

  @override
  _RoleChangeDialogOrganismState createState() =>
      _RoleChangeDialogOrganismState();
}

class _RoleChangeDialogOrganismState extends State<RoleChangeDialogOrganism> {
  @override
  Widget build(BuildContext context) {
    String message =
        (widget.roleChangeRequest.suggestedBy?.name ?? "Anonymus") +
            " requested to change your role to " +
            widget.roleChangeRequest.suggestedRole.name;
    return AlertDialog(
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
        ElevatedButton(
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(),
          ),
          onPressed: () {
            Navigator.pop(context, '');
          },
        ),
        ElevatedButton(
          child: Text(
            'OK',
            style: GoogleFonts.inter(),
          ),
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
        ),
      ],
    );
  }
}
