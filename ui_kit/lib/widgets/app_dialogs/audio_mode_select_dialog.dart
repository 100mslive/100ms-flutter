//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_dropdown.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/subtitle_text.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';

class AudioModeSelectDialog extends StatefulWidget {
  final HMSAudioMode currentAudioMode;
  final Function(HMSAudioMode) changeAudioMode;

  const AudioModeSelectDialog(
      {super.key,
      required this.currentAudioMode,
      required this.changeAudioMode});

  @override
  _AudioModeSelectDialogState createState() => _AudioModeSelectDialogState();
}

class _AudioModeSelectDialogState extends State<AudioModeSelectDialog> {
  HMSAudioMode? valueChoose;

  void _updateDropDownValue(dynamic newValue) {
    valueChoose = newValue;
  }

  @override
  void initState() {
    super.initState();
    valueChoose = widget.currentAudioMode;
  }

  @override
  Widget build(BuildContext context) {
    String message = "Select the audio mode";
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: "Change Audio Mode",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          const SizedBox(
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
            padding: const EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: themeSurfaceColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: borderColor, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: <DropdownMenuItem>[
                  ...HMSAudioMode.values
                      .map((audioMode) => DropdownMenuItem(
                            value: audioMode,
                            child: TitleText(
                              text: audioMode.name,
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ))
                      .toList(),
                ],
                    iconStyleData: IconStyleData(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: themeDefaultColor,
                    ),
                    selectedValue: valueChoose,
                    updateSelectedValue: _updateDropDownValue)),
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
                      side: const BorderSide(
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
                    Utilities.showToast("Please select audioMode"),
                  }
                else
                  {Navigator.pop(context), widget.changeAudioMode(valueChoose!)}
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
