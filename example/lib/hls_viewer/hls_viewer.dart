import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

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

    // context.read<MeetingStore>().setPIPVideoController(widget.streamUrl, false);
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: GlobalKey(),
        body: Stack(
          children: [
            Center(
                child: FadeTransition(
              opacity: fadeInFadeOut,
              child: Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: HMSHLSPlayer(url: widget.streamUrl)),
            )),
            if (!context.read<MeetingStore>().isPipActive)
              Positioned(
                bottom: 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    animation.reverse();
                    // context
                    //     .read<MeetingStore>()
                    //     .setPIPVideoController(widget.streamUrl, true);
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
  }
}
