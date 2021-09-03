import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class ChangeRoleOptionDialog extends StatefulWidget {
  final String peerName;
  final Future<List<HMSRole>> getRoleFunction;
  final Function(HMSRole, bool) changeRole;
  final bool force;
  final isVideoMuted;
  final isAudioMuted;
  final Function(bool,bool) changeTrack;
  ChangeRoleOptionDialog(
      {required this.peerName,
      required this.getRoleFunction,
      required this.changeRole,
      this.force = false,
        this.isVideoMuted,
        this.isAudioMuted,
        required this.changeTrack
      });

  @override
  _ChangeRoleOptionDialogState createState() => _ChangeRoleOptionDialogState();
}

class _ChangeRoleOptionDialogState extends State<ChangeRoleOptionDialog> {
  late bool forceValue;

  @override
  void initState() {
    super.initState();
    forceValue = widget.force;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.peerName),
      content: Container(
        width: double.infinity,
        child: FutureBuilder<List<HMSRole>>(
          builder: (_, AsyncSnapshot<List<HMSRole>> data) {
            if (data.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else if (data.hasData) {
              return Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.data?.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                                title: Text(data.data![index].name),
                                trailing: IconButton(
                                  onPressed: () {
                                    widget.changeRole(
                                        data.data![index], forceValue);
                                  },
                                  icon: Icon(
                                    Icons.done,
                                  ),
                                ));
                          }),
                    ),
                    GestureDetector(
                      onTap: () {
                        forceValue = !forceValue;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(forceValue
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          SizedBox(
                            width: 16,
                          ),
                          Text('Force change')
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeTrack(!widget.isVideoMuted,true);
                      },
                      child: Row(
                        children: [
                          Icon(widget.isVideoMuted
                              ? Icons.videocam
                              : Icons.videocam_off),
                          SizedBox(
                            width: 16,
                          ),
                          Text("${widget.isVideoMuted?"Unmute":"Mute"} video")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.changeTrack(!widget.isAudioMuted,false);
                      },
                      child: Row(
                        children: [
                          Icon(widget.isAudioMuted
                              ? Icons.mic_sharp
                              : Icons.mic_off),
                          SizedBox(
                            width: 16,
                          ),
                          Text("${widget.isAudioMuted?"Unmute":"Mute"} audio")
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Text('No roles available');
          },
          future: widget.getRoleFunction,
        ),
      ),
    );
  }
}
