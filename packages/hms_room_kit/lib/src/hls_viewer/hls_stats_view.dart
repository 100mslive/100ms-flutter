import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSStatsView extends StatelessWidget {
  const HLSStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.black38.withOpacity(0.3),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: ListView(
        shrinkWrap: true,
        children: [
          Selector<MeetingStore, double?>(
              builder: (_, bitrate, __) {
                return Text(
                    "Bitrate : ${bitrate == null ? "-" : (bitrate / 8000)} KBps",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.averageBitrate),
          const SizedBox(
            height: 10,
          ),
          Selector<MeetingStore, double?>(
              builder: (_, bufferedDuration, __) {
                return Text(
                    "Buffered Duration  : ${bufferedDuration == null ? "-" : bufferedDuration / 1000}",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.bufferedDuration),
          const SizedBox(
            height: 10,
          ),
          Selector<MeetingStore, double?>(
              builder: (_, videoWidth, __) {
                return Text("Video Width : ${videoWidth ?? "-"} px",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.videoWidth),
          const SizedBox(
            height: 10,
          ),
          Selector<MeetingStore, double?>(
              builder: (_, videoHeight, __) {
                return Text("Video Height : ${videoHeight ?? "-"} px",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.videoHeight),
          const SizedBox(
            height: 10,
          ),
          Selector<MeetingStore, int?>(
              builder: (_, droppedFrameCount, __) {
                return Text("Dropped Frames : ${droppedFrameCount ?? "-"} ",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.droppedFrameCount),
          const SizedBox(
            height: 10,
          ),
          Selector<MeetingStore, double?>(
              builder: (_, distanceFromLive, __) {
                return Text(
                    "Distance from live edge : ${distanceFromLive == null ? "-" : distanceFromLive / 1000}s",
                    style: GoogleFonts.inter(color: iconColor, fontSize: 12));
              },
              selector: (_, meetingStore) =>
                  meetingStore.hlsPlayerStats?.distanceFromLive),
        ],
      ),
    );
  }
}
