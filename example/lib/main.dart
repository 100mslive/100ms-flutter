//Dart imports
import 'dart:async';
import 'dart:io';

//Package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:package_info_plus/package_info_plus.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/user_name_dialog_organism.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/preview/preview_page.dart';
import 'package:hmssdk_flutter_example/service/deeplink_service.dart';
import './logs/custom_singleton_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  Wakelock.enable();
  Provider.debugCheckInvalidValueType = null;
  runZonedGuarded(
      () => runApp(HMSExampleApp()), FirebaseCrashlytics.instance.recordError);
}

class HMSExampleApp extends StatelessWidget {
  const HMSExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 13, 107, 184),
          appBarTheme: AppBarTheme(color: Colors.black),
          scaffoldBackgroundColor: Colors.black),
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
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
  CustomLogger logger = CustomLogger();
  bool skipPreview = false;
  bool mirrorCamera = true;
  bool showStats = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    logger.getCustomLogger();
    _initPackageInfo();
  }

  Future<bool> _closeApp() {
    CustomLogger.file?.delete();
    return Future.value(true);
  }

  DeepLinkBloc _bloc = DeepLinkBloc();

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void setRTMPUrl(String roomUrl) {
    List<String> urlSplit = roomUrl.split('/');
    int index = urlSplit.lastIndexOf("meeting");
    if (index != -1) {
      urlSplit[index] = "preview";
    }
    Constant.rtmpUrl = urlSplit.join('/') + "?token=beam_recording";
  }

  void handleClick(int value) {
    switch (value) {
      case 1:
        skipPreview = !skipPreview;
        break;
      case 2:
        mirrorCamera = !mirrorCamera;
        break;
      case 3:
        showStats = !showStats;
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _closeApp,
      child: Scaffold(
          appBar: AppBar(
            title: Text('100ms'),
            actions: [
              PopupMenuButton<int>(
                onSelected: handleClick,
                icon: Icon(CupertinoIcons.gear),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (skipPreview)
                            Text("Enable Preview")
                          else
                            Text(
                              "Disable Preview",
                              style: TextStyle(color: Colors.blue),
                            ),
                          Icon(Icons.preview,
                              color: skipPreview ? Colors.white : Colors.blue),
                        ],
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (mirrorCamera)
                            Text("Disable Mirroring",
                                style: TextStyle(color: Colors.blue))
                          else
                            Text("Enable Mirroring"),
                          Icon(
                            Icons.camera_front,
                            color: mirrorCamera ? Colors.blue : Colors.white,
                          ),
                        ],
                      ),
                      value: 2,
                    ),
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (showStats)
                            Text("Disable Stats",
                                style: TextStyle(color: Colors.blue))
                          else
                            Text("Enable Stats"),
                          Icon(Icons.bar_chart,
                              color: showStats ? Colors.blue : Colors.white),
                        ],
                      ),
                      value: 3,
                    ),
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Version ${_packageInfo.version}"),
                        ],
                      ),
                      value: 4,
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Provider<DeepLinkBloc>(
            create: (context) => _bloc,
            dispose: (context, bloc) => bloc.dispose(),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/100ms.gif",
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Join a Meeting',
                          style: TextStyle(
                              height: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8,
                      ),
                      StreamBuilder(
                          stream: _bloc.state,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data is String) {
                              var url = snapshot.data as String;
                              if (url.isNotEmpty) {
                                roomIdController.text = url;
                              }
                            }
                            return TextField(
                              controller: roomIdController,
                              autofocus: true,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                  hintText: 'Enter Room URL',
                                  suffixIcon: IconButton(
                                    onPressed: roomIdController.clear,
                                    icon: Icon(Icons.clear),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16)))),
                            );
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ))),
                          onPressed: () async {
                            setRTMPUrl(roomIdController.text);
                            String user = await showDialog(
                                context: context,
                                builder: (_) => UserNameDialogOrganism());
                            if (user.isNotEmpty) {
                              bool res = await getPermissions();
                              if (res) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (skipPreview) {
                                  HMSSDKInteractor _hmsSDKInteractor =
                                      HMSSDKInteractor();
                                  _hmsSDKInteractor.showStats = showStats;
                                  _hmsSDKInteractor.mirrorCamera = mirrorCamera;
                                  _hmsSDKInteractor.skipPreview = true;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ListenableProvider.value(
                                          value: MeetingStore(
                                              hmsSDKInteractor:
                                                  _hmsSDKInteractor),
                                          child: MeetingPage(
                                              roomId:
                                                  roomIdController.text.trim(),
                                              flow: MeetingFlow.join,
                                              user: user,
                                              isAudioOn: true))));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ListenableProvider.value(
                                            value: PreviewStore(),
                                            child: PreviewPage(
                                              roomId:
                                                  roomIdController.text.trim(),
                                              user: user,
                                              flow: MeetingFlow.join,
                                              mirror: mirrorCamera,
                                              showStats: showStats,
                                            ),
                                          )));
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.video_call_outlined, size: 48),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Join Meeting',
                                    style: TextStyle(height: 1, fontSize: 24))
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
