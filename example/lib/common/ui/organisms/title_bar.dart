import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../meeting/meeting_store.dart';
import '../../constant.dart';

class TitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
        selector: (_, meetingStore) => meetingStore.highestSpeaker,
        builder: (_, speakerName, __) {
          return (speakerName != null)?Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                        'assets/icons/audio.png',
                      color: Colors.white,
                      height: 16.0,
                      width: 16.0,
                    ),
                Container(
                  width: 70,
                  child: Text(speakerName,overflow: TextOverflow.ellipsis,softWrap: true,)),
              ],
            ),
          ):Text(Constant.meetingCode);
        });
  }
}
