//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
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
        color: surfaceColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width / 3,
              child: Text(
                peer.name,
                style: GoogleFonts.inter(
                  fontSize: 20.0,
                  color: iconColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                if (peer.metadata?.contains("\"isHandRaised\":true") ?? false)
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SvgPicture.asset(
                        "assets/icons/hand.svg",
                        color: Colors.yellow,
                        height: 25,
                      )),
                if (peer.metadata?.contains("\"isBRBOn\":true") ?? false)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SvgPicture.asset(
                      "assets/icons/brb.svg",
                      color: Colors.red,
                      width: 25,
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
                                roles: _meetingStore?.roles ?? [],
                                peer: peer,
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
                      // width: width / 6,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          "${peer.role.name}",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
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
