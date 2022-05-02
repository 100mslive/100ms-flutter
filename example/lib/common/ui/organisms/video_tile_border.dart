import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class VideoTileBorder extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final String uid;
  VideoTileBorder({
    required this.itemHeight,
    required this.itemWidth,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, bool>(
        selector: (_, meetingStore) => meetingStore.isActiveSpeaker(uid),
        builder: (_, isHighestSpeaker, __) {
          return Container(
            height: itemHeight + 110,
            width: itemWidth - 4,
            decoration: BoxDecoration(
                border: Border.all(
                    color: isHighestSpeaker ? Colors.blue : Colors.grey,
                    width: isHighestSpeaker ? 4.0 : 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10))),
          );
        });
  }
}
