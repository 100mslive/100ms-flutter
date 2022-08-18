//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/participant_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class ParticipantsList extends StatefulWidget {
  const ParticipantsList({Key? key}) : super(key: key);

  @override
  _ParticipantsListState createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bottomSheetColor,
        title: Selector<MeetingStore, int>(
            selector: (_, meetingStore) => meetingStore.peers.length,
            builder: (_, length, __) {
              return Row(
                children: [
                  SvgPicture.asset("assets/icons/participants.svg"),
                  Text(
                    " Participants ($length)",
                    style: GoogleFonts.inter(),
                  ),
                ],
              );
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
          selector: (_, meetingStore) =>
              Tuple2(meetingStore.peers, meetingStore.peers.length),
          builder: (_, data, __) {
            return SingleChildScrollView(
              child:
                  Consumer<MeetingStore>(builder: (context, _meetingStore, _) {
                if (data.item2 != 0) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: data.item1
                        .map((peer) => ParticipantOrganism(
                              peer: peer,
                            ))
                        .toList(),
                  );
                } else {
                  return Text(
                    "No Participants",
                    style: GoogleFonts.inter(
                      color: iconColor,
                    ),
                  );
                }
              }),
            );
          },
        ),
      ),
    );
  }
}
