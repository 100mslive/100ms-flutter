import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_bloc.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_event.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_state.dart';
import 'package:demo_app_with_100ms_and_bloc/views/video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';

class VideoWidget extends StatefulWidget {
  final int index;

  const VideoWidget(this.index, {Key? key}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomOverviewBloc, RoomOverviewState>(
      builder: (ctx, state) => FocusDetector(
        onFocusGained: () {
          if (state.leaveMeeting && !mounted) {
            return;
          }
          context
              .read<RoomOverviewBloc>()
              .add(RoomOverviewSetOffScreen(false, widget.index));
        },
        onFocusLost: () {
          if (state.leaveMeeting && !mounted) {
            return;
          }
          context
              .read<RoomOverviewBloc>()
              .add(RoomOverviewSetOffScreen(true, widget.index));
        },
        child: (state.peerTrackNodes[widget.index].peer!.isLocal
                    ? !state.isVideoMute
                    : !state.peerTrackNodes[widget.index].isMute!) &&
                !(state.peerTrackNodes[widget.index].isOffScreen)
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      width: 400.0,
                      child:
                          VideoView(state.peerTrackNodes[widget.index].hmsVideoTrack!),
                    ),
                    Text(
                      state.peerTrackNodes[widget.index].peer!.name,
                    )
                  ],
                ),
              )
            : Container(
                height: 200.0,
                width: 400.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 36,
                        child: Text(
                          state.peerTrackNodes[widget.index].peer!.name[0],
                          style: const TextStyle(
                              fontSize: 36, color: Colors.white),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      state.peerTrackNodes[widget.index].peer!.name,
                    )
                  ],
                )),
      ),
    );
  }
}
