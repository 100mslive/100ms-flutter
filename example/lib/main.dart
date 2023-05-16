//Dart imports
import 'dart:async';

//Package imports
import 'package:bot_toast/bot_toast.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/app_settings_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/home_screen/user_detail_screen.dart';
import 'package:hmssdk_flutter_example/home_screen/qr_code_screen.dart';
import 'package:provider/provider.dart';

bool _initialURILinkHandled = false;
StreamSubscription? _streamSubscription;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // //This sends all the fatal crashes in the application to crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };

  // //This sends all the errors in the application(be it in flutter or native layer) to crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  Provider.debugCheckInvalidValueType = null;

  // Get any initial links
  // final PendingDynamicLinkData? initialLink =
  //     await FirebaseDynamicLinks.instance.getInitialLink();

  runZonedGuarded(() => runApp(HMSExampleApp()),
      (_,__){});
}

class HMSExampleApp extends StatefulWidget {
  final Uri? initialLink;
  HMSExampleApp({Key? key, this.initialLink}) : super(key: key);

  @override
  _HMSExampleAppState createState() => _HMSExampleAppState();
  static _HMSExampleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_HMSExampleAppState>()!;
}

class _HMSExampleAppState extends State<HMSExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Uri? _currentURI;
  bool isDarkMode =
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

  ThemeData _darkTheme = ThemeData(
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: themeBottomSheetColor, elevation: 5),
      brightness: Brightness.dark,
      primaryColor: Color.fromARGB(255, 13, 107, 184),
      scaffoldBackgroundColor: Colors.black);

  ThemeData _lightTheme = ThemeData(
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: themeDefaultColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5),
      primaryTextTheme:
          TextTheme(bodyLarge: TextStyle(color: themeSurfaceColor)),
      primaryColor: hmsdefaultColor,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: Colors.white54);

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
    initDynamicLinks();
    setThemeMode();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initURIHandler() async {
    // if (!_initialURILinkHandled) {
    //   _initialURILinkHandled = true;
    //   try {
    //     if (widget.initialLink != null) {
    //       return;
    //     }
    //     // _currentURI = await getInitialUri();
    //     if (_currentURI != null) {
    //       if (!mounted) {
    //         return;
    //       }
    //       setState(() {});
    //     }
    //   } on PlatformException {
    //     debugPrint("Failed to receive initial uri");
    //   } on FormatException {
    //     if (!mounted) {
    //       return;
    //     }
    //   }
    // }
  }

  void _incomingLinkHandler() {
    // if (!kIsWeb) {
    //   _streamSubscription = uriLinkStream.listen((Uri? uri) {
    //     if (!mounted) {
    //       return;
    //     }
    //     if (uri == null || !uri.toString().contains("100ms.live")) {
    //       return;
    //     }
    //     setState(() {
    //       _currentURI = uri;
    //     });
    //     String tempUri = uri.toString();
    //     if (tempUri.contains("deep_link_id")) {
    //       setState(() {
    //         _currentURI =
    //             Uri.parse(Utilities.fetchMeetingLinkFromFirebase(tempUri));
    //       });
    //     }
    //   }, onError: (Object err) {
    //     if (!mounted) {
    //       return;
    //     }
    //   });
    // }
  }

  Future<void> initDynamicLinks() async {
    // FirebaseDynamicLinks.instance.onLink
    //     .listen((PendingDynamicLinkData dynamicLinkData) {
    //   if (!mounted) {
    //     return;
    //   }
    //   if (dynamicLinkData.link.toString().length == 0) {
    //     return;
    //   }
    //   setState(() {
    //     _currentURI = dynamicLinkData.link;
    //   });
    // }).onError((error) {
    //   print('onLink error');
    //   print(error.message);
    // });

    // if (widget.initialLink != null) {
    //   _currentURI = widget.initialLink;
    //   setState(() {});
    // }
  }

  void setThemeMode() async {
    _themeMode = await Utilities.getBoolData(key: "dark-mode") ?? true
        ? ThemeMode.dark
        : ThemeMode.light;
    if (_themeMode == ThemeMode.light) {
      changeTheme(_themeMode);
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
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
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
  static _HomePageState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>()!;
}

class _HomePageState extends State<HomePage> {
  TextEditingController meetingLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    getData();
  }

  void getData() async {
    String savedMeetingUrl = await Utilities.getStringData(key: 'meetingLink');
    if (widget.deepLinkURL == null && savedMeetingUrl.isNotEmpty) {
      meetingLinkController.text = savedMeetingUrl;
    } else {
      meetingLinkController.text = widget.deepLinkURL ?? "";
    }
  }

  Future<bool> _closeApp() {
    return Future.value(true);
  }

  Future<void> _initPackageInfo() async {

  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    if (widget.deepLinkURL != null) {
      meetingLinkController.text = widget.deepLinkURL!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void joinMeeting() {
    if (meetingLinkController.text.isEmpty) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Utilities.setRTMPUrl(meetingLinkController.text);
    MeetingFlow flow = Utilities.deriveFlow(meetingLinkController.text.trim());
    if (flow == MeetingFlow.meeting || flow == MeetingFlow.hlsStreaming) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => UserDetailScreen(
                    autofocusField: true,
                    meetingLink: meetingLinkController.text.trim(),
                    meetingFlow: flow,
                  )));
    } else {
      Utilities.showToast("Please enter valid url");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _closeApp,
      child: SafeArea(
        child: Scaffold(
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
                          color: themeDefaultColor,
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
                          color: themeSubHeadingColor,
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
                              color: themeDefaultColor,
                              height: 1.5,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
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
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        focusColor: hmsdefaultColor,
                        contentPadding: EdgeInsets.only(left: 16),
                        fillColor: themeSurfaceColor,
                        filled: true,
                        hintText: 'Paste the link here',
                        hintStyle: GoogleFonts.inter(
                            color: hmsHintColor,
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
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: meetingLinkController.text.isEmpty
                                ? themeSurfaceColor
                                : hmsdefaultColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                style: ButtonStyle(
                                    shadowColor: MaterialStateProperty.all(
                                        themeSurfaceColor),
                                    backgroundColor:
                                        meetingLinkController.text.isEmpty
                                            ? MaterialStateProperty.all(
                                                themeSurfaceColor)
                                            : MaterialStateProperty.all(
                                                hmsdefaultColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ))),
                                onPressed: () async {
                                  joinMeeting();
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(60, 12, 8, 12),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TitleText(
                                        key: Key('join_now'),
                                        text: 'Join Now',
                                        textColor:
                                            meetingLinkController.text.isEmpty
                                                ? themeDisabledTextColor
                                                : enabledTextColor,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                              GestureDetector(
                                onTap: (() => showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    context: context,
                                    builder: (ctx) => AppSettingsBottomSheet(
                                          appVersion: "Test IOS",
                                        ))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: SvgPicture.asset(
                                    "assets/icons/more.svg",
                                    color: meetingLinkController.text.isEmpty
                                        ? themeDisabledTextColor
                                        : hmsWhiteColor,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            ],
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => QRCodeScreen()));
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
                          TitleText(
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
