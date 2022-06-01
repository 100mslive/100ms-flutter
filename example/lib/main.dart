//Dart imports
import 'dart:async';
import 'dart:io';

//Package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
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

class HMSExampleApp extends StatefulWidget {
  HMSExampleApp({Key? key}) : super(key: key);

  @override
  _HMSExampleAppState createState() => _HMSExampleAppState();
  static _HMSExampleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_HMSExampleAppState>()!;
}

class _HMSExampleAppState extends State<HMSExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeData _darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color.fromARGB(255, 13, 107, 184),
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black);

  ThemeData _lightTheme = ThemeData(
    primaryColor: Color.fromARGB(255, 13, 107, 184),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.black,
    dividerColor: Colors.white54,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      Constant.isDarkMode = _themeMode == ThemeMode.dark ? true : false;
      updateColor();
    });
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
            backgroundColor: Constant.isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            title: Text(
              '100ms',
              style: GoogleFonts.inter(color: iconColor),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    if (Constant.isDarkMode) {
                      HMSExampleApp.of(context).changeTheme(ThemeMode.light);
                    } else {
                      HMSExampleApp.of(context).changeTheme(ThemeMode.dark);
                    }
                  },
                  icon: Constant.isDarkMode
                      ? SvgPicture.asset(
                          'assets/icons/light_mode.svg',
                          color: iconColor,
                        )
                      : SvgPicture.asset(
                          'assets/icons/dark_mode.svg',
                          color: iconColor,
                        )),
              PopupMenuButton<int>(
                onSelected: handleClick,
                icon: SvgPicture.asset(
                  'assets/icons/settings.svg',
                  color: iconColor,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (skipPreview)
                            Text("Enable Preview",
                                style: GoogleFonts.inter(color: iconColor))
                          else
                            Text(
                              "Disable Preview",
                              style: GoogleFonts.inter(color: Colors.blue),
                            ),
                          if (skipPreview)
                            SvgPicture.asset(
                                'assets/icons/preview_state_on.svg',
                                color: iconColor)
                          else
                            SvgPicture.asset(
                              'assets/icons/preview_state_off.svg',
                              color: Colors.blue,
                            ),
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
                                style: GoogleFonts.inter(color: Colors.blue))
                          else
                            Text(
                              "Enable Mirroring",
                              style: GoogleFonts.inter(color: iconColor),
                            ),
                          Icon(
                            Icons.camera_front,
                            color: mirrorCamera ? Colors.blue : iconColor,
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
                                style: GoogleFonts.inter(color: Colors.blue))
                          else
                            Text(
                              "Enable Stats",
                              style: GoogleFonts.inter(color: iconColor),
                            ),
                          SvgPicture.asset(
                            'assets/icons/stats.svg',
                            color: showStats ? Colors.blue : iconColor,
                          ),
                        ],
                      ),
                      value: 3,
                    ),
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Version ${_packageInfo.version}",
                              style: GoogleFonts.inter(color: iconColor)),
                        ],
                      ),
                      value: 4,
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/100ms.gif",
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Text('Join Meeting',
                      style: GoogleFonts.inter(
                          height: 1,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: GoogleFonts.inter(),
                      controller: roomIdController,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                          hintText: 'Enter Room URL',
                          hintStyle: GoogleFonts.inter(),
                          suffixIcon: IconButton(
                            onPressed: roomIdController.clear,
                            icon: Icon(Icons.clear),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)))),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ))),
                    onPressed: () async {
                      if (roomIdController.text.isEmpty) {
                        return;
                      }
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
                                        hmsSDKInteractor: _hmsSDKInteractor),
                                    child: MeetingPage(
                                        roomId: roomIdController.text.trim(),
                                        flow: MeetingFlow.join,
                                        user: user,
                                        isAudioOn: true))));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ListenableProvider.value(
                                      value: PreviewStore(),
                                      child: PreviewPage(
                                        roomId: roomIdController.text.trim(),
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
                      width: 250,
                      padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Join Meeting',
                              style:
                                  GoogleFonts.inter(height: 1, fontSize: 20)),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.arrow_right_alt_outlined, size: 22),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Made with ❤️ by 100ms",
                      style: GoogleFonts.inter(color: iconColor))
                ],
              ),
            ),
          )),
    );
  }
}
