//Dart imports
import 'dart:async';
import 'dart:ui';

//Package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter_example/app_settings_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/qr_code_screen.dart';
import 'package:hmssdk_flutter_example/room_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni_links/uni_links.dart';
import 'package:uuid/uuid.dart';

bool _initialURILinkHandled = false;
StreamSubscription? _streamSubscription;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //This sends all the fatal crashes in the application to crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //This sends all the errors in the application(be it in flutter or native layer) to crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Provider.debugCheckInvalidValueType = null;

  // Get any initial links
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(HMSExampleApp(initialLink: initialLink?.link));
}

class HMSExampleApp extends StatefulWidget {
  final Uri? initialLink;
  HMSExampleApp({Key? key, this.initialLink}) : super(key: key);

  @override
  _HMSExampleAppState createState() => _HMSExampleAppState();
  static _HMSExampleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_HMSExampleAppState>()!;
}

class _HMSExampleAppState extends State<HMSExampleApp>
    with TickerProviderStateMixin {
  ThemeMode _themeMode = ThemeMode.dark;
  Uri? _currentURI;
  late AnimationController _controller;

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
    _controller = AnimationController(
      duration: Duration(seconds: (5)),
      vsync: this,
    );
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        if (widget.initialLink != null) {
          return;
        }
        _currentURI = await getInitialUri();
        if (_currentURI != null) {
          if (!mounted) {
            return;
          }
          setState(() {});
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException {
        if (!mounted) {
          return;
        }
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        if (uri == null || !uri.toString().contains("100ms.live")) {
          return;
        }
        setState(() {
          _currentURI = uri;
        });
        String tempUri = uri.toString();
        if (tempUri.contains("deep_link_id")) {
          setState(() {
            _currentURI =
                Uri.parse(Utilities.fetchMeetingLinkFromFirebase(tempUri));
          });
        }
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLinkData) {
      if (!mounted) {
        return;
      }
      if (dynamicLinkData.link.toString().length == 0) {
        return;
      }
      setState(() {
        _currentURI = dynamicLinkData.link;
      });
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    if (widget.initialLink != null) {
      _currentURI = widget.initialLink;
      setState(() {});
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
      home: Builder(builder: (context) {
        return Lottie.asset(
          'assets/splash_asset.json',
          controller: _controller,
          animate: true,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              deepLinkURL: _currentURI == null
                                  ? null
                                  : _currentURI.toString(),
                            )),
                  ));
          },
        );
      }),
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
    );
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
  Uuid? uuid;
  String uuidString = "";

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
    _initPackageInfo();
    getData();
  }

  void getData() async {
    String savedMeetingUrl = await Utilities.getStringData(key: 'meetingLink');
    uuidString = await Utilities.getStringData(key: "uuid");
    if (uuidString.isEmpty) {
      uuid = Uuid();
      uuidString = uuid!.v4();
      Utilities.saveStringData(key: "uuid", value: uuidString);
    }
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
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    if (widget.deepLinkURL != null) {
      meetingLinkController.text = widget.deepLinkURL!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void joinMeeting() async {
    if (meetingLinkController.text.trim().isEmpty) {
      return;
    }

    Map<String, String>? endPoints;
    if (meetingLinkController.text.trim().contains("app.100ms.live")) {
      List<String?>? roomData =
          RoomService.getCode(meetingLinkController.text.trim());

      //If the link is not valid then we might not get the code and whether the link is a
      //PROD or QA so we return the error in this case
      if (roomData == null || roomData.isEmpty) {
        return;
      }

      ///************************************************************************************************** */

      ///This section can be safely commented out as it's only required for 100ms internal usage

      //qaTokenEndPoint is only required for 100ms internal testing
      //It can be removed and should not affect the join method call
      //For _endPoint just pass it as null
      //the endPoint parameter in getAuthTokenByRoomCode can be passed as null
      //Pass the layoutAPIEndPoint as null the qa endPoint is only for 100ms internal testing

      ///If you wish to set your own token end point then you can pass it in the endPoints map
      ///The key for the token end point is "tokenEndPointKey"
      ///The key for the init end point is "initEndPointKey"
      ///The key for the layout api end point is "layoutAPIEndPointKey"
      if (roomData[1] == "false") {
        endPoints = RoomService.setEndPoints();
      }

      ///************************************************************************************************** */

      Constant.roomCode = roomData[0] ?? '';
    } else {
      Constant.roomCode = meetingLinkController.text.trim();
    }

    Utilities.saveStringData(
        key: "meetingLink", value: meetingLinkController.text.trim());
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => HMSPrebuilt(
                roomCode: Constant.roomCode,
                options: HMSPrebuiltOptions(
                    userImgUrl: "https://www.desipainters.com/dp/05/17709/17709.jpg",
                    userName: "Alex",
                    // AppDebugConfig.nameChangeOnPreview
                    //     ? null
                    //     : "Flutter User",
                    endPoints: endPoints,
                    userId:
                        uuidString, // pass your custom unique user identifier here
                    iOSScreenshareConfig: HMSIOSScreenshareConfig(
                        appGroup: "group.flutterhms",
                        preferredExtension:
                            "live.100ms.flutter.FlutterBroadcastUploadExtension")))));
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
                      style: HMSTextStyle.setTextStyle(
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
                      style: HMSTextStyle.setTextStyle(
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
                      Text("Room Code",
                          key: Key('room_code_text'),
                          style: HMSTextStyle.setTextStyle(
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
                    key: Key('room_code_field'),
                    textInputAction: TextInputAction.done,
                    cursorColor: HMSThemeColors.primaryDefault,
                    onSubmitted: (value) {
                      joinMeeting();
                    },
                    style: HMSTextStyle.setTextStyle(),
                    controller: meetingLinkController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        focusColor: hmsdefaultColor,
                        contentPadding: EdgeInsets.only(left: 16),
                        fillColor: themeSurfaceColor,
                        filled: true,
                        hintText: 'Paste the room code or link here',
                        hintStyle: HMSTextStyle.setTextStyle(
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
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                              ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: HMSThemeColors.primaryDefault, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
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
                                      const EdgeInsets.fromLTRB(12, 12, 8, 12),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      HMSTitleText(
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
                                          appVersion: _packageInfo.version +
                                              " (${_packageInfo.buildNumber})",
                                        ))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                    colorFilter: ColorFilter.mode(
                                        meetingLinkController.text.isEmpty
                                            ? themeDisabledTextColor
                                            : hmsWhiteColor,
                                        BlendMode.srcIn),
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
                                      uuidString: uuidString,
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
                          HMSTitleText(
                              key: Key("scan_qr_code"),
                              text: 'Scan QR Code',
                              textColor: enabledTextColor)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
