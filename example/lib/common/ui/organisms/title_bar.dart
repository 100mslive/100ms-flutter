//Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_participants_list.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add conditional width sizing

    return GestureDetector(
      onTap:() => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<MeetingStore>(), child: ParticipantsList()))),
      child: Selector<MeetingStore, String?>(
          selector: (_, meetingStore) => meetingStore.highestSpeaker,
          builder: (_, speakerName, __) {
            return (speakerName != null)
                ? Container(
                    width: 164,
                    child: Text("🔊 $speakerName", overflow: TextOverflow.clip))
                : Text("▼ " + Constant.meetingCode);
          }),
    );
  }
}
