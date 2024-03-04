///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[ChangeNameBottomSheet] is a bottom sheet that is used to change the name of the local peer
///It has following parameters:
///[showPrivacyInfo] is a boolean that is used to show/hide the privacy info
class ChangeNameBottomSheet extends StatefulWidget {
  final bool showPrivacyInfo;
  const ChangeNameBottomSheet({super.key, this.showPrivacyInfo = true});

  @override
  State<ChangeNameBottomSheet> createState() => _ChangeNameBottomSheetState();
}

class _ChangeNameBottomSheetState extends State<ChangeNameBottomSheet> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = context.read<MeetingStore>().localPeer?.name ?? "";
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  ///This function is called when the change name button is clicked
  void _changeName() {
    ///We only change the name
    ///if the name is not empty
    ///and the name is not same as the previous name
    ///
    ///we also trim to remove the spaces from beginning or end
    if (nameController.text.trim().isNotEmpty &&
        nameController.text.trim() !=
            context.read<MeetingStore>().localPeer?.name) {
      context.read<MeetingStore>().changeName(name: nameController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: HMSThemeColors.onSurfaceHighEmphasis,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    HMSTitleText(
                      text: "Change Name",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [HMSCrossButton()],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(
                color: HMSThemeColors.borderDefault,
                height: 5,
              ),
            ),

            ///We show the privacy info only if the [showPrivacyInfo] is true
            if (widget.showPrivacyInfo)
              HMSSubheadingText(
                text:
                    "Your name will be visible to other participants in\n the session.",
                maxLines: 2,
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              ),
            if (widget.showPrivacyInfo)
              const SizedBox(
                height: 16,
              ),
            SizedBox(
              height: 48,
              child: TextField(
                cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                style: HMSTextStyle.setTextStyle(
                    color: HMSThemeColors.onSurfaceHighEmphasis),
                controller: nameController,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  _changeName();
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    fillColor: HMSThemeColors.surfaceDefault,
                    filled: true,
                    hintText: nameController.text.isEmpty
                        ? 'Enter Name...'
                        : nameController.text,
                    hintStyle: HMSTextStyle.setTextStyle(
                        color: HMSThemeColors.onSurfaceLowEmphasis,
                        height: 1.5,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: HMSThemeColors.primaryDefault),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: HMSListenableButton(
                  width: MediaQuery.of(context).size.width - 48,
                  textController: nameController,
                  onPressed: () => {_changeName()},
                  childWidget: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: HMSTitleText(
                        text: "Change",
                        textColor: (nameController.text.trim().isEmpty ||
                                context.read<MeetingStore>().localPeer?.name ==
                                    nameController.text.trim())
                            ? HMSThemeColors.onPrimaryLowEmphasis
                            : HMSThemeColors.onPrimaryHighEmphasis,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
