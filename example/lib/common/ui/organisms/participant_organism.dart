//Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_role_options.dart';

class ParticipantOrganism extends StatefulWidget {
  final HMSPeer peer;

  const ParticipantOrganism({Key? key, required this.peer}) : super(key: key);

  @override
  _ParticipantOrganismState createState() => _ParticipantOrganismState();
}

class _ParticipantOrganismState extends State<ParticipantOrganism> {
  bool isVideoOn = false, isAudioOn = false;
  Color isOffColor = Colors.red.shade300, isOnColor = Colors.green.shade300;
  MeetingStore? _meetingStore;
  @override
  void initState() {
    _meetingStore = context.read<MeetingStore>();
    super.initState();
    checkButtons();
  }

  @override
  Widget build(BuildContext context) {
    // _meetingStore = Provider.of<MeetingStore>(context);
    final width = MediaQuery.of(context).size.width;
    HMSPeer peer = widget.peer;
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width / 3,
              child: Text(
                peer.name,
                style: TextStyle(fontSize: 20.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                if (peer.metadata == "{\"isHandRaised\":true}")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Image.asset(
                      'assets/icons/raise_hand.png',
                      color: Colors.amber.shade300,
                      width: 20,
                      height: 20,
                    ),
                  ),
                if (peer.metadata ==
                    "{\"isHandRaised\":false,\"isBRBOn\":true}")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Text("BRB"),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    if (_meetingStore?.localPeer!.role.permissions.changeRole ??
                        false)
                      showDialog(
                          context: context,
                          builder: (_) => ChangeRoleOptionDialog(
                                peerName: peer.name,
                                getRoleFunction: _meetingStore!.getRoles(),
                                changeRole: (role, forceChange) {
                                  Navigator.pop(context);
                                  _meetingStore!.changeRole(
                                      peer: peer,
                                      roleName: role,
                                      forceChange: forceChange);
                                },
                              ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "${peer.role.name}",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isVideoOn ? isOnColor : isOffColor),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child:
                          Icon(isVideoOn ? Icons.videocam : Icons.videocam_off),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAudioOn ? isOnColor : isOffColor),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void checkButtons() async {
    this.isAudioOn = !await _meetingStore!.isAudioMute(widget.peer);
    this.isVideoOn = !await _meetingStore!.isVideoMute(widget.peer);
    setState(() {});
  }
}
