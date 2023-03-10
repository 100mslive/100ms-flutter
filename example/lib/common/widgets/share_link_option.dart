//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart';

class ShareLinkOptionDialog extends StatefulWidget {
  final List<HMSRole> roles;
  final String roomID;
  ShareLinkOptionDialog({required this.roles, required this.roomID});

  @override
  _ShareLinkOptionDialogState createState() => _ShareLinkOptionDialogState();
}

class _ShareLinkOptionDialogState extends State<ShareLinkOptionDialog> {
  late bool askPermission;
  HMSRole? valueChoose;
  @override
  void initState() {
    super.initState();
    valueChoose = widget.roles[0];
  }

  @override
  Widget build(BuildContext context) {
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
            text: "Share Link",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          SizedBox(
            height: 8,
          ),
          SubtitleText(
              text: "Generate Share Link for the following role:",
              textColor: themeSubHeadingColor),
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
                child: DropdownButton2(
              isExpanded: true,
              dropdownStyleData: DropdownStyleData(
                width: width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeSurfaceColor,
                  border: Border.all(color: borderColor),
                ),
                offset: Offset(-10, -10),
              ),
              buttonStyleData: ButtonStyleData(
                height: 48,
                width: width * 0.7,
                decoration: BoxDecoration(
                  color: themeSurfaceColor,
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 48,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
                iconEnabledColor: themeDefaultColor,
              ),
              value: valueChoose,
              onChanged: (dynamic newvalue) {
                setState(() {
                  valueChoose = newvalue;
                });
              },
              items: <DropdownMenuItem>[
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
            )),
          ),
          SizedBox(
            height: 15,
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
              onPressed: () async {
                if (valueChoose == null) {
                  Utilities.showToast("Please select a role");
                } else {
                  Navigator.pop(context);
                  String meetingLink =
                      await Utilities.getStringData(key: "meetingLink");
                  List<String> codeDomain;
                  if (meetingLink.contains("/meeting/"))
                    codeDomain = meetingLink.split("/meeting/");
                  else
                    codeDomain = meetingLink.split("/preview/");
                  print(meetingLink);
                  meetingLink = codeDomain[0] +
                      "/" +
                      widget.roomID +
                      "/" +
                      valueChoose!.name;
                  await Share.share(
                    meetingLink,
                    subject: "Join Meet",
                  );
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(
                  'Share',
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
