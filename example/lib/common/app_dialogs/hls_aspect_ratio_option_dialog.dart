//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_dropdown.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';

//Project imports
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class AspectRatioOptionDialog extends StatefulWidget {
  final List<String> availableAspectRatios;
  final MeetingStore meetingStore;
  AspectRatioOptionDialog({
    required this.availableAspectRatios,
    required this.meetingStore,
  });

  @override
  _AspectRatioOptionDialogState createState() =>
      _AspectRatioOptionDialogState();
}

class _AspectRatioOptionDialogState extends State<AspectRatioOptionDialog> {
  String? valueChoose;

  void _updateDropDownValue(dynamic newValue) {
    valueChoose = newValue;
  }

  @override
  void initState() {
    valueChoose = widget.availableAspectRatios[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String message = "Select aspect ratio of HLS player";
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
            text: "Change Aspect Ratio",
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
                  ...widget.availableAspectRatios
                      .map((aspectRatio) => DropdownMenuItem(
                            child: TitleText(
                              text: aspectRatio,
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                            value: aspectRatio,
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
              onPressed: () {
                if (valueChoose == null) {
                  Utilities.showToast("Please select a aspect ratio");
                } else {
                  double ratio;
                  if (valueChoose!.contains("Default")) {
                    ratio = Utilities.getHLSPlayerDefaultRatio(
                        MediaQuery.of(context).size);
                  } else {
                    List number = valueChoose!.split(":");
                    ratio = double.parse(number[0]) / double.parse(number[1]);
                  }
                  Utilities.showToast(
                      "Player aspect ratio changed to $valueChoose");
                  widget.meetingStore
                      .setPIPVideoController(true, aspectRatio: ratio);
                  Navigator.pop(context);
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
