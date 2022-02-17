//Package imports
import 'package:flutter/material.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/participant_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class ParticipantsList extends StatefulWidget {
  const ParticipantsList({Key? key}) : super(key: key);

  @override
  _ParticipantsListState createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  @override
  Widget build(BuildContext context) {
    final _meetingStore = Provider.of<MeetingStore>(context);
    List<HMSPeer> peers = _meetingStore.peers;
    return Scaffold(
      appBar: AppBar(
        title: Text("Participants"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Consumer<MeetingStore>(builder: (context, _meetingStore, _) {
            if (peers.isNotEmpty) {
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: peers
                    .map((peer) => ParticipantOrganism(
                          peer: peer,
                        ))
                    .toList(),
              );
            } else {
              return Text(("No Participants"));
            }
          }),
        ),
      ),
    );
  }
}
