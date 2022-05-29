//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class ChangeRoleOptionDialog extends StatefulWidget {
  final String peerName;
  final Future<List<HMSRole>> getRoleFunction;
  final Function(HMSRole, bool) changeRole;
  final bool force;
  ChangeRoleOptionDialog({
    required this.peerName,
    required this.getRoleFunction,
    required this.changeRole,
    this.force = false,
  });

  @override
  _ChangeRoleOptionDialogState createState() => _ChangeRoleOptionDialogState();
}

class _ChangeRoleOptionDialogState extends State<ChangeRoleOptionDialog> {
  late bool forceValue;
  String valueChoose = "";

  @override
  void initState() {
    super.initState();
    forceValue = widget.force;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.peerName),
      content: Container(
        width: double.infinity,
        child: FutureBuilder<List<HMSRole>>(
          builder: (_, AsyncSnapshot<List<HMSRole>> data) {
            if (data.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else if (data.hasData) {
              if (valueChoose == "") {
                valueChoose = data.data![0].name;
              }
              return Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Role To: "),
                        Flexible(
                          child: DropdownButton2(
                            buttonWidth: MediaQuery.of(context).size.width / 2,
                            value: valueChoose,
                            iconEnabledColor: Colors.white,
                            onChanged: (newvalue) {
                              setState(() {
                                valueChoose = newvalue as String;
                              });
                            },
                            items: data.data!.map((role) {
                              return DropdownMenuItem(
                                child: Text(role.name),
                                value: role.name,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        forceValue = !forceValue;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(forceValue
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          SizedBox(
                            width: 16,
                          ),
                          Text('Force change')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              widget.changeRole(
                                  data.data!.firstWhere(
                                      (element) => element.name == valueChoose),
                                  forceValue);
                            },
                            child: Text("Change Role")),
                      ],
                    )
                  ],
                ),
              );
            }
            return Text('No roles available');
          },
          future: widget.getRoleFunction,
        ),
      ),
    );
  }
}
