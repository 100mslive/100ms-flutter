//Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/bottom_sheets/hls_participant_sheet.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          backgroundColor: themeBottomSheetColor,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          builder: (ctx) => ChangeNotifierProvider.value(
              value: context.read<MeetingStore>(),
              child: HLSParticipantSheet()),
          isScrollControlled: true),
      child: Selector<MeetingStore, String?>(
          selector: (_, meetingStore) => meetingStore.highestSpeaker,
          builder: (_, speakerName, __) {
            return (speakerName != null)
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text("🔊 $speakerName",
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.inter()))
                : Text("👥 " + Constant.meetingCode,
                    style: GoogleFonts.inter());
          }),
    );
  }
}
