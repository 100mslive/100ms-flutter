import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/user_name_dialog_organism.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(HMSExampleApp());
}

class HMSExampleApp extends StatelessWidget {
  const HMSExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController roomIdController =
      TextEditingController(text: Constant.defaultRoomID);

  void getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('100MS'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.settings))
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Join a meeting'),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: roomIdController,
                decoration: InputDecoration(
                    hintText: 'Enter RoomId e.g. 60cb411533afe',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ))),
                  onPressed: () async {
                    String user = await showDialog(
                        context: context,
                        builder: (_) => UserNameDialogOrganism());
                    if (user.isNotEmpty)
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MeetingPage(
                                roomId: roomIdController.text,
                                user: user,
                                flow: MeetingFlow.join,
                              )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.video_call_outlined),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Join meeting')
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
