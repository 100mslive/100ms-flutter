//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_dropdown.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:collection/collection.dart';

class ChangeRoleOptionDialog extends StatefulWidget {
  final String peerName;
  final List<HMSRole> roles;
  final Function(HMSRole, bool) changeRole;
  final bool force;
  final HMSPeer peer;
  ChangeRoleOptionDialog({
    required this.peerName,
    required this.roles,
    required this.changeRole,
    required this.peer,
    this.force = true,
  });

  @override
  _ChangeRoleOptionDialogState createState() => _ChangeRoleOptionDialogState();
}

class _ChangeRoleOptionDialogState extends State<ChangeRoleOptionDialog> {
  late bool askPermission;
  HMSRole? valueChoose;

  void _updateDropDownValue(dynamic newValue) {
    valueChoose = newValue;
  }

  @override
  void initState() {
    super.initState();
    askPermission = !widget.force;
    valueChoose = widget.roles[0];
  }

  @override
  Widget build(BuildContext context) {
    String message = "Change the role of ‘${widget.peerName}’ to";
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      contentPadding: EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: "Change Role",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          SizedBox(
            height: 8,
          ),
          SubtitleText(text: message, textColor: themeSubHeadingColor),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: themeSurfaceColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: borderColor, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: <DropdownMenuItem>[
                  ...widget.roles
                      .sortedBy((element) => element.priority.toString())
                      .map((role) => DropdownMenuItem(
                            child: TitleText(
                              text: role.name,
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                            value: role,
                          ))
                      .toList(),
                ],
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: themeDefaultColor,
                    ),
                    selectedValue: valueChoose,
                    updateSelectedValue: _updateDropDownValue)),
          ),
          SizedBox(
            height: 15,
          ),
          if (!widget.peer.isLocal)
            Row(
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: Checkbox(
                      value: askPermission,
                      activeColor: Colors.blue,
                      onChanged: (bool? value) {
                        if (value != null) {
                          askPermission = value;
                          setState(() {});
                        }
                      }),
                ),
                SizedBox(
                  width: 10.5,
                ),
                SizedBox(
                    width: width * 0.5,
                    child: Text(
                      "Request permission from the user",
                      style: GoogleFonts.inter(
                        color: themeDefaultColor,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                      ),
                    )),
              ],
            ),
        ],
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
                      side: BorderSide(
                          width: 1, color: Color.fromRGBO(107, 125, 153, 1)),
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: () => Navigator.pop(context, false),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text('Cancel',
                      style: GoogleFonts.inter(
                          color: themeDefaultColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50)),
                )),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor: MaterialStateProperty.all(hmsdefaultColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: hmsdefaultColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              onPressed: () => {
                if (valueChoose == null)
                  {
                    Utilities.showToast("Please select a role"),
                  }
                else
                  {
                    Navigator.pop(context),
                    widget.changeRole(valueChoose!, !askPermission)
                  }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(
                  'Change',
                  style: GoogleFonts.inter(
                      color: themeDefaultColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.50),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
