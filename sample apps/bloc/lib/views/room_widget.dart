import 'dart:io';

import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_bloc.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_event.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_state.dart';
import 'package:demo_app_with_100ms_and_bloc/home_page.dart';
import 'package:demo_app_with_100ms_and_bloc/views/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Room extends StatelessWidget {
  final String meetingUrl;
  final String userName;
  final bool isVideoOff;
  final bool isAudioOff;
  final bool isScreenshareActive;
  static Route route(String url, String name, bool v, bool a, bool ss) {
    return MaterialPageRoute<void>(builder: (_) => Room(url, name, v, a, ss));
  }

  const Room(this.meetingUrl, this.userName, this.isVideoOff, this.isAudioOff,
      this.isScreenshareActive,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomOverviewBloc(
          isVideoOff, isAudioOff, userName, meetingUrl, isScreenshareActive)
        ..add(const RoomOverviewSubscriptionRequested()),
      child: RoomWidget(meetingUrl, userName),
    );
  }
}

class RoomWidget extends StatelessWidget {
  final String meetingUrl;
  final String userName;

  const RoomWidget(this.meetingUrl, this.userName, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<RoomOverviewBloc, RoomOverviewState>(
          listener: (ctx, state) {
            if (state.leaveMeeting) {
              Navigator.of(context).pushReplacement(HomePage.route());
            }
          },
          builder: (ctx, state) {
            return ListView.builder(
              itemCount: state.peerTrackNodes.length,
              itemBuilder: (ctx, index) {
                return Card(
                    key: Key(
                        state.peerTrackNodes[index].peer!.peerId.toString()),
                    child: SizedBox(height: 250.0, child: VideoWidget(index)));
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<RoomOverviewBloc, RoomOverviewState>(
        builder: (ctx, state) {
          return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.grey,
              unselectedItemColor: Colors.grey,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(state.isAudioMute ? Icons.mic_off : Icons.mic),
                  label: 'Mic',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      state.isVideoMute ? Icons.videocam_off : Icons.videocam),
                  label: 'Camera',
                ),
                //For screenshare in iOS follow the steps here : https://www.100ms.live/docs/flutter/v2/features/Screen-Share
                if (Platform.isAndroid)
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.screen_share,
                        color: (state.isScreenShareActive)
                            ? Colors.green
                            : Colors.grey,
                      ),
                      label: "ScreenShare"),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.cancel),
                  label: 'Leave Meeting',
                ),
              ],

              //New
              onTap: (index) => _onItemTapped(index, context));
        },
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context
            .read<RoomOverviewBloc>()
            .add(const RoomOverviewLocalPeerAudioToggled());
        break;
      case 1:
        context
            .read<RoomOverviewBloc>()
            .add(const RoomOverviewLocalPeerVideoToggled());
        break;
      case 2:
        context
            .read<RoomOverviewBloc>()
            .add(const RoomOverviewLocalPeerScreenshareToggled());
        break;
      case 3:
        context
            .read<RoomOverviewBloc>()
            .add(const RoomOverviewLeaveRequested());
    }
  }
}
