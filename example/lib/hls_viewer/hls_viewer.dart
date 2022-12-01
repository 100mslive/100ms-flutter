//Package imports
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pip_flutter/pipflutter_player.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';

class HLSPlayer extends StatefulWidget {
  final String streamUrl;

  HLSPlayer({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    context.read<MeetingStore>().setPIPVideoController(widget.streamUrl, false);
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, PipFlutterPlayerController?>(
        selector: (_, meetingStore) => meetingStore.hlsVideoController,
        builder: (_, controller, __) {
          if (controller == null) {
            return Scaffold();
          }
          return Scaffold(
              key: GlobalKey(),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Text(
                    "LIVE",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    animation.reverse();
                    context
                        .read<MeetingStore>()
                        .setPIPVideoController(widget.streamUrl, true);
                    animation.forward();
                  }),
              body: Center(
                  child: FadeTransition(
                opacity: fadeInFadeOut,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PipFlutterPlayer(
                    controller: controller,
                    key: context.read<MeetingStore>().pipFlutterPlayerKey,
                  ),
                ),
              )));
        });
  }
}
