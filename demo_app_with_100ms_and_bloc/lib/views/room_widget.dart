import 'package:demo_app_with_100ms_and_bloc/bloc/preview/preview_cubit.dart';
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

  static Route route(String url, String name, bool v, bool a) {
    return MaterialPageRoute<void>(builder: (_) => Room(url, name, v, a));
  }

  const Room(this.meetingUrl, this.userName, this.isVideoOff, this.isAudioOff,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RoomOverviewBloc(isVideoOff, isAudioOff, userName, meetingUrl)
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
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.grey,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.cancel),
                  label: 'Leave Meeting',
                ),
                BottomNavigationBarItem(
                  icon: Icon(state.isAudioMute ? Icons.mic_off : Icons.mic),
                  label: 'Mic',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      state.isVideoMute ? Icons.videocam_off : Icons.videocam),
                  label: 'Camera',
                ),
              ],

              //New
              onTap: (index) => _onItemTapped(index, context));
        },
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) {
      context.read<RoomOverviewBloc>().add(const RoomOverviewLeaveRequested());
    } else if (index == 1) {
      context
          .read<RoomOverviewBloc>()
          .add(const RoomOverviewLocalPeerAudioToggled());
    } else {
      context
          .read<RoomOverviewBloc>()
          .add(const RoomOverviewLocalPeerVideoToggled());
    }
  }
}
