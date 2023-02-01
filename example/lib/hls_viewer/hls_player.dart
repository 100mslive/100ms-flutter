import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:tuple/tuple.dart';

class HLSPlayer extends StatefulWidget {
  HLSPlayer({Key? key}) : super(key: key);

  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> {
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, Tuple2<String, double>>(
        selector: (_, meetingStore) =>
            Tuple2(meetingStore.streamUrl, meetingStore.hlsAspectRatio),
        builder: (_, data, __) {
          if (data.item1 == "") {
            return Container();
          }
          return AspectRatio(
            aspectRatio: data.item2,
            child: HMSVideoPlayer(
              url: data.item1,
            ),
          );
        });
  }
}
