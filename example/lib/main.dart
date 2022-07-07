//Dart imports
import 'dart:async';

//Package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/preview/preview_details.dart';
import 'package:hmssdk_flutter_example/qr_code_screen.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni_links/uni_links.dart';

//Project imports
import './logs/custom_singleton_logger.dart';

bool _initialURILinkHandled = false;
StreamSubscription? _streamSubscription;

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
  bool isDarkMode =
      WidgetsBinding.instance?.window.platformBrightness == Brightness.dark;

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

  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        _currentURI = await getInitialUri();
        if (_currentURI != null) {
          if (!mounted) {
            return;
          }
          setState(() {});
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        Utilities.showToast("Malformed URI received");
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }

        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        deepLinkURL: _currentURI == null ? null : _currentURI.toString(),
      ),
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      isDarkMode = themeMode == ThemeMode.dark;
      updateColor(_themeMode);
    });
  }
}

class HomePage extends StatefulWidget {
  final String? deepLinkURL;

  const HomePage({Key? key, this.deepLinkURL}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController meetingLinkController = TextEditingController();
  CustomLogger logger = CustomLogger();
  bool skipPreview = false;
  bool mirrorCamera = true;
  bool showStats = false;
  List<bool> mode = [true, false]; //0-> meeting ,1 -> HLS mode

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    logger.getCustomLogger();
    _initPackageInfo();
    getData();
  }

  void getData() async {
    meetingLinkController.text =
        await Utilities.getStringData(key: 'meetingLink');
    int index = await Utilities.getIntData(key: 'mode');
    mode[index] = true;
    mode[1 - index] = false;
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
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.deepLinkURL != null) {
      meetingLinkController.text = widget.deepLinkURL!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void joinMeeting() {
    if (meetingLinkController.text.isEmpty) {
      return;
    }
    Utilities.saveStringData(
        key: "meetingLink", value: meetingLinkController.text.trim());
    Utilities.saveIntData(key: "mode", value: mode[0] == true ? 0 : 1);
    FocusManager.instance.primaryFocus?.unfocus();
    Utilities.setRTMPUrl(meetingLinkController.text);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PreviewDetails(
                  meetingLink: meetingLinkController.text.trim(),
                  meetingFlow:
                      mode[0] ? MeetingFlow.meeting : MeetingFlow.hlsStreaming,
                )));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HMSExampleApp.of(context).isDarkMode;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _closeApp,
      child: SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   backgroundColor: isDarkMode ? Colors.black : Colors.white,
            //   elevation: 0,
            //   title: Text(
            //     '100ms',
            //     style: GoogleFonts.inter(color: iconColor),
            //   ),
            //   actions: [
            //     IconButton(
            //         onPressed: () {
            //           if (isDarkMode) {
            //             HMSExampleApp.of(context).changeTheme(ThemeMode.light);
            //           } else {
            //             HMSExampleApp.of(context).changeTheme(ThemeMode.dark);
            //           }
            //         },
            //         icon: isDarkMode
            //             ? SvgPicture.asset(
            //                 'assets/icons/light_mode.svg',
            //                 color: iconColor,
            //               )
            //             : SvgPicture.asset(
            //                 'assets/icons/dark_mode.svg',
            //                 color: iconColor,
            //               )),
            //     PopupMenuButton<int>(
            //       onSelected: handleClick,
            //       icon: SvgPicture.asset(
            //         'assets/icons/settings.svg',
            //         color: iconColor,
            //       ),
            //       itemBuilder: (BuildContext context) {
            //         return [
            //           PopupMenuItem(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 if (skipPreview)
            //                   Text("Enable Preview",
            //                       style: GoogleFonts.inter(color: iconColor))
            //                 else
            //                   Text(
            //                     "Disable Preview",
            //                     style: GoogleFonts.inter(color: Colors.blue),
            //                   ),
            //                 if (skipPreview)
            //                   SvgPicture.asset(
            //                       'assets/icons/preview_state_on.svg',
            //                       color: iconColor)
            //                 else
            //                   SvgPicture.asset(
            //                     'assets/icons/preview_state_off.svg',
            //                     color: Colors.blue,
            //                   ),
            //               ],
            //             ),
            //             value: 1,
            //           ),
            //           PopupMenuItem(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 if (mirrorCamera)
            //                   Text("Disable Mirroring",
            //                       style: GoogleFonts.inter(color: Colors.blue))
            //                 else
            //                   Text(
            //                     "Enable Mirroring",
            //                     style: GoogleFonts.inter(color: iconColor),
            //                   ),
            //                 Icon(
            //                   Icons.camera_front,
            //                   color: mirrorCamera ? Colors.blue : iconColor,
            //                 ),
            //               ],
            //             ),
            //             value: 2,
            //           ),
            //           PopupMenuItem(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 if (showStats)
            //                   Text("Disable Stats",
            //                       style: GoogleFonts.inter(color: Colors.blue))
            //                 else
            //                   Text(
            //                     "Enable Stats",
            //                     style: GoogleFonts.inter(color: iconColor),
            //                   ),
            //                 SvgPicture.asset(
            //                   'assets/icons/stats.svg',
            //                   color: showStats ? Colors.blue : iconColor,
            //                 ),
            //               ],
            //             ),
            //             value: 3,
            //           ),
            //           PopupMenuItem(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text("Version ${_packageInfo.version}",
            //                     style: GoogleFonts.inter(color: iconColor)),
            //               ],
            //             ),
            //             value: 4,
            //           ),
            //         ];
            //       },
            //     ),
            //   ],
            // ),
            body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/welcome.svg',
                  width: width * 0.95,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text('Experience the power of 100ms',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          letterSpacing: 0.25,
                          color: defaultColor,
                          height: 1.17,
                          fontSize: 34,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Text(
                      'Jump right in by pasting a room link or scanning a QR code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          letterSpacing: 0.5,
                          color: subHeadingColor,
                          height: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Joining Link",
                          key: Key('joining_link_text'),
                          style: GoogleFonts.inter(
                              color: defaultColor,
                              height: 1.5,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      ToggleButtons(
                          key: Key('mode_toggle_button'),
                          selectedColor: hmsdefaultColor,
                          selectedBorderColor: hmsdefaultColor,
                          borderRadius: BorderRadius.circular(10),
                          textStyle: GoogleFonts.inter(
                              color: defaultColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          children: [Text(" Meeting "), Text("HLS")],
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < mode.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  mode[buttonIndex] = true;
                                } else {
                                  mode[buttonIndex] = false;
                                }
                              }
                            });
                          },
                          isSelected: mode)
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.95,
                  child: TextField(
                    key: Key('meeting_link_field'),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      joinMeeting();
                    },
                    style: GoogleFonts.inter(),
                    controller: meetingLinkController,
                    keyboardType: TextInputType.url,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        focusColor: hmsdefaultColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        fillColor: surfaceColor,
                        filled: true,
                        hintText: 'Paste the link here',
                        hintStyle: GoogleFonts.inter(
                            color: hintColor,
                            height: 1.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        suffixIcon: meetingLinkController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  meetingLinkController.text = "";
                                  setState(() {});
                                },
                                icon: Icon(Icons.clear),
                              ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: width * 0.95,
                  child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: meetingLinkController,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(surfaceColor),
                              backgroundColor: meetingLinkController
                                      .text.isEmpty
                                  ? MaterialStateProperty.all(surfaceColor)
                                  : MaterialStateProperty.all(hmsdefaultColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () async {
                            joinMeeting();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HLSTitleText(
                                  key: Key('join_now'),
                                  text: 'Join Now',
                                  textColor: meetingLinkController.text.isEmpty
                                      ? disabledTextColor
                                      : enabledTextColor,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: width * 0.95,
                    child: Divider(
                      height: 5,
                      color: dividerColor,
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: width * 0.95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(hmsdefaultColor),
                        backgroundColor:
                            MaterialStateProperty.all(hmsdefaultColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () async {
                      bool res = await Utilities.getCameraPermissions();
                      if (res) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QRCodeScreen(
                                      meetingFlow: mode[0]
                                          ? MeetingFlow.meeting
                                          : MeetingFlow.hlsStreaming,
                                    )));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: 18,
                            color: enabledTextColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          HLSTitleText(
                              key: Key("scan_qr_code"),
                              text: 'Scan QR Code',
                              textColor: enabledTextColor)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
