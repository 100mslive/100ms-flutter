import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:provider/provider.dart';

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
  }

  void _changeName() {
    if (nameController.text.isNotEmpty &&
        nameController.text.trim() !=
            context.read<MeetingStore>().localPeer?.name) {
      context.read<MeetingStore>().changeName(name: nameController.text);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: HMSThemeColors.onSurfaceHighEmphasis,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
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
                cursorColor: HMSThemeColors.primaryDefault,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.inter(
                    color: HMSThemeColors.onSurfaceHighEmphasis),
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  _changeName();
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    fillColor: HMSThemeColors.surfaceDefault,
                    filled: true,
                    hintText: nameController.text.isEmpty
                        ? 'Enter Name...'
                        : nameController.text,
                    hintStyle: GoogleFonts.inter(
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
                  errorMessage: "Please enter you name",
                  onPressed: () => {_changeName()},
                  childWidget: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Center(
                      child: HMSTitleText(
                        text: "Change",
                        textColor: (nameController.text.isEmpty ||
                                context.read<MeetingStore>().localPeer?.name ==
                                    nameController.text.trim())
                            ? HMSThemeColors.onPrimaryLowEmphasis
                            : HMSThemeColors.onPrimaryHighEmphasis,
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
