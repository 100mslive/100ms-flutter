import 'package:demo_app_with_100ms_and_bloc/bloc/preview/preview_cubit.dart';
import 'package:demo_app_with_100ms_and_bloc/views/room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class Preview extends StatelessWidget {
  final String meetingUrl;
  final String userName;

  const Preview(this.meetingUrl, this.userName, {Key? key}) : super(key: key);

  static Route route(String url, String name) {
    return MaterialPageRoute<void>(builder: (_) => Preview(url, name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PreviewCubit(userName, meetingUrl),
        child: PreviewWidget(meetingUrl, userName));
  }
}

class PreviewWidget extends StatelessWidget {
  final String meetingUrl;
  final String userName;

  const PreviewWidget(this.meetingUrl, this.userName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;


    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PreviewCubit, PreviewState>(
              builder: (context, state) {
                return state.tracks.isEmpty
                    ? SizedBox(
                        height: itemHeight / 1.3,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(
                        height: itemHeight,
                        width: itemWidth,
                        child: Stack(
                          children: [
                            HMSVideoView(
                                track: state.tracks[0],
                                matchParent: true),
                            Positioned(
                              bottom: 20.0,
                              left: itemWidth / 2 - 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    padding: const EdgeInsets.all(14)),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      Room.route(meetingUrl, userName,state.isVideoOff,state.isMicOff));
                                },
                                child: const Text(
                                  "Join Now",
                                  style: TextStyle(height: 1, fontSize: 18),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              right: 50.0,
                              child: IconButton(
                                  onPressed: () {
                                    context.read<PreviewCubit>().toggleAudio();
                                  },
                                  icon: Icon(
                                    state.isMicOff ? Icons.mic_off : Icons.mic,
                                    size: 30.0,
                                    color: Colors.blue,
                                  )),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 50.0,
                              child: IconButton(
                                  onPressed: () {
                                    context.read<PreviewCubit>().toggleVideo();
                                  },
                                  icon: Icon(
                                    state.isVideoOff
                                        ? Icons.videocam_off
                                        : Icons.videocam,
                                    size: 30.0,
                                    color: Colors.blueAccent,
                                  )),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
