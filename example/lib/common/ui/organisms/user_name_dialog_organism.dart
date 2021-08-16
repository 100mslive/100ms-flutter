import 'package:flutter/material.dart';

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
              controller: userNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  hintText: 'Enter your name'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, '');
          },
        ),
        ElevatedButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context, userNameController.text);
          },
        ),
      ],
    );
  }
}
