///Package imports
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_creation_widgets/poll_question_bottom_sheet.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[PollQuizForm] widget renders the poll creation form with poll title.
class PollQuizForm extends StatefulWidget {
  final bool isPoll;

  const PollQuizForm({Key? key, required this.isPoll}) : super(key: key);

  @override
  State<PollQuizForm> createState() => _PollQuizFormState();
}

class _PollQuizFormState extends State<PollQuizForm> {
  late TextEditingController _pollNameController;
  bool _hideVoteCount = false;

  @override
  void initState() {
    _pollNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pollNameController.dispose();
    super.dispose();
  }

  ///This method sets the value of the hide vote count switch
  void setHideVoteCount(bool value) {
    setState(() {
      _hideVoteCount = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HMSSubheadingText(
            text: "${widget.isPoll ? "Poll" : "Quiz"} Name",
            textColor: HMSThemeColors.onSurfaceHighEmphasis),
        const SizedBox(
          height: 8,
        ),

        ///Text Field
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
            controller: _pollNameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                fillColor: HMSThemeColors.surfaceDefault,
                filled: true,
                hintText: "Name this ${widget.isPoll ? "Poll" : "Quiz"}",
                hintStyle: HMSTextStyle.setTextStyle(
                    color: HMSThemeColors.onSurfaceLowEmphasis,
                    height: 1.5,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: HMSThemeColors.primaryDefault)),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),

        ///Padding
        const SizedBox(
          height: 24,
        ),

        ///Divider
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
          ),
          child: Divider(
            height: 5,
            color: HMSThemeColors.borderBright,
          ),
        ),

        ///Settings section
        if (widget.isPoll)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: HMSSubheadingText(
                text: "Settings",
                textColor: HMSThemeColors.onSurfaceHighEmphasis),
          ),

        ///Hide vote count switch
        if (widget.isPoll)
          ListTile(
            horizontalTitleGap: 1,
            enabled: false,
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: HMSSubheadingText(
                text: "Hide vote count",
                textColor: HMSThemeColors.onSurfaceMediumEmphasis),
            trailing: SizedBox(
              height: 24,
              width: 40,
              child: FittedBox(
                fit: BoxFit.contain,
                child: CupertinoSwitch(
                  value: _hideVoteCount,
                  onChanged: (value) => setHideVoteCount(value),
                  activeColor: HMSThemeColors.primaryDefault,
                ),
              ),
            ),
          ),

        ///Is the poll anonymous switch
        // ListTile(
        //   horizontalTitleGap: 1,
        //   enabled: false,
        //   dense: true,
        //   contentPadding: EdgeInsets.zero,
        //   title: Row(
        //     children: [
        //       HMSSubheadingText(
        //           text: "Make results anonymous",
        //           textColor: HMSThemeColors.onSurfaceMediumEmphasis),
        //       // const SizedBox(
        //       //   width: 8,
        //       // ),
        //       // SvgPicture.asset(
        //       //   "packages/hms_room_kit/lib/src/assets/icons/info.svg",
        //       //   height: 16,
        //       //   width: 16,
        //       //   colorFilter: ColorFilter.mode(
        //       //       HMSThemeColors.onSurfaceLowEmphasis, BlendMode.srcIn),
        //       // )
        //     ],
        //   ),
        //   trailing: SizedBox(
        //     height: 24,
        //     width: 40,
        //     child: FittedBox(
        //       fit: BoxFit.contain,
        //       child: CupertinoSwitch(
        //         value: _isAnonymous,
        //         onChanged: (value) => setIsAnonymous(value),
        //         activeColor: HMSThemeColors.primaryDefault,
        //       ),
        //     ),
        //   ),
        // ),

        ///Padding
        const SizedBox(
          height: 24,
        ),

        ///Button to add question
        SizedBox(
          height: 40,
          child: HMSListenableButton(
              textController: _pollNameController,
              width: MediaQuery.of(context).size.width - 40,
              onPressed: () {
                if (_pollNameController.text.trim().isEmpty) return;
                var meetingStore = context.read<MeetingStore>();
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: HMSThemeColors.surfaceDim,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  context: context,
                  builder: (ctx) => ChangeNotifierProvider.value(
                      value: meetingStore,
                      child: PollQuestionBottomSheet(
                        pollName: _pollNameController.text.trim(),
                        isPoll: widget.isPoll,
                        rolesThatCanViewResponse: _hideVoteCount
                            ? meetingStore.localPeer != null
                                ? [meetingStore.localPeer!.role]
                                : null
                            : null,
                      )),
                );
              },
              childWidget: HMSTitleText(
                text: 'Create ${widget.isPoll ? "Poll" : "Quiz"}',
                textColor: _pollNameController.text.isEmpty
                    ? HMSThemeColors.onPrimaryLowEmphasis
                    : HMSThemeColors.onPrimaryHighEmphasis,
              )),
        )
      ],
    );
  }
}
