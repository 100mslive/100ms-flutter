//Package imports
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:pip_flutter/pipflutter_player.dart';
import 'package:pip_flutter/pipflutter_player_configuration.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:pip_flutter/pipflutter_player_data_source.dart';
import 'package:pip_flutter/pipflutter_player_data_source_type.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

//Project imports
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';

class HLSPlayer extends StatefulWidget {
  final String streamUrl;

  HLSPlayer({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> {
  @override
  void initState() {
    super.initState();

    PipFlutterPlayerConfiguration pipFlutterPlayerConfiguration =
        const PipFlutterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    PipFlutterPlayerDataSource dataSource = PipFlutterPlayerDataSource(
      PipFlutterPlayerDataSourceType.network,
      widget.streamUrl,
    );
    context.read<MeetingStore>().hlsVideoController =
        PipFlutterPlayerController(pipFlutterPlayerConfiguration);
    context
        .read<MeetingStore>()
        .hlsVideoController!
        .setupDataSource(dataSource);
    context.read<MeetingStore>().hlsVideoController!.setControlsEnabled(false);
    context.read<MeetingStore>().hlsVideoController!.play();
    context
        .read<MeetingStore>()
        .hlsVideoController!
        .seekTo(Duration(seconds: 0));

    context
        .read<MeetingStore>()
        .hlsVideoController!
        .setPipFlutterPlayerGlobalKey(
            context.read<MeetingStore>().pipFlutterPlayerKey);

    // context.read<MeetingStore>().hlsVideoController =
    //     VideoPlayerController.network(
    //   widget.streamUrl,
    // )..initialize().then((_) {
    //         context.read<MeetingStore>().hlsVideoController!.play();
    //         setState(() {});
    //       });
  }

  @override
  void dispose() async {
    super.dispose();
    try {
      context.read<MeetingStore>().hlsVideoController?.dispose();
      context.read<MeetingStore>().hlsVideoController = null;
    } catch (e) {
      //To handle the error when the user calls leave from hls-viewer role.
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, PipFlutterPlayerController?>(
        selector: (_, meetingStore) => meetingStore.hlsVideoController,
        builder: (_, controller, __) {
          return Scaffold(
              key: GlobalKey(),
              body: Center(
                  child: AspectRatio(
                aspectRatio: context
                    .read<MeetingStore>()
                    .hlsVideoController!
                    .getAspectRatio()!,
                child: PipFlutterPlayer(
                  controller: controller!,
                  key: context.read<MeetingStore>().pipFlutterPlayerKey,
                ),
              )));
        });
  }
}
