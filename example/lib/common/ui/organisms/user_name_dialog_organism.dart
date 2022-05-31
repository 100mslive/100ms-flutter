// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              controller: userNameController,
              style: GoogleFonts.inter(),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  hintText: 'Enter your Name',
                  hintStyle: GoogleFonts.inter()),
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
            Navigator.pop(context, userNameController.text);
          },
        ),
      ],
    );
  }
}
