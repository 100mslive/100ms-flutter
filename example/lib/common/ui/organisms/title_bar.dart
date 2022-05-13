import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../meeting/meeting_store.dart';
import '../../constant.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // TODO: add conditional width sizing

    return Selector<MeetingStore, String?>(
        selector: (_, meetingStore) => meetingStore.highestSpeaker,
        builder: (_, speakerName, __) {
          return (speakerName != null)?Container(
            width: 164,
            child: Text("🔊 $speakerName",overflow: TextOverflow.clip)):Text(Constant.meetingCode);
        });
  }
}
