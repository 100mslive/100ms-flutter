//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class TileBorder extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  final String uid;
  final String name;

  TileBorder(
      {required this.itemHeight,
      required this.itemWidth,
      required this.uid,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, int>(
        selector: (_, meetingStore) => meetingStore.isActiveSpeaker(uid),
        builder: (_, isHighestSpeaker, __) {
          return Container(
            height: itemHeight + 110,
            width: itemWidth - 4,
            decoration: BoxDecoration(
              border: Border.all(
                  color: (isHighestSpeaker != -1)
                      ? Utilities.getBackgroundColour(name)
                      : bottomSheetColor,
                  width: (isHighestSpeaker != -1) ? 4.0 : 0.0),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          );
        });
  }
}
