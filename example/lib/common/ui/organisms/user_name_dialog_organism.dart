// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class UserNameDialogOrganism extends StatefulWidget {
  const UserNameDialogOrganism({Key? key}) : super(key: key);

  @override
  _UserNameDialogOrganismState createState() => _UserNameDialogOrganismState();
}

class _UserNameDialogOrganismState extends State<UserNameDialogOrganism> {
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        autofocus: true,
        controller: userNameController,
        style: GoogleFonts.inter(),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            hintText: 'Enter your Name',
            hintStyle: GoogleFonts.inter(
              color: iconColor,
            )),
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
            Navigator.pop(context, userNameController.text);
          },
        ),
      ],
    );
  }
}
