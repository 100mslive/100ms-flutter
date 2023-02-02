import 'package:flutter/material.dart';
import 'package:pip_flutter/pipflutter_player.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class HLSPlayer extends StatefulWidget {
  HLSPlayer({Key? key}) : super(key: key);

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

    context
        .read<MeetingStore>()
        .setPIPVideoController(false, aspectRatio: 16 / 9);
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
              body: Stack(
                children: [
                  Center(
                      child: FadeTransition(
                    opacity: fadeInFadeOut,
                    child: AspectRatio(
                      aspectRatio: context.read<MeetingStore>().hlsAspectRatio,
                      child: PipFlutterPlayer(
                        controller: controller,
                        key: context.read<MeetingStore>().pipFlutterPlayerKey,
                      ),
                    ),
                  )),
                  if (!context.read<MeetingStore>().isPipActive)
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          animation.reverse();
                          context
                              .read<MeetingStore>()
                              .setPIPVideoController(true);
                          animation.forward();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Go Live",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                      ),
                    )
                ],
              ));
        });
  }
}
