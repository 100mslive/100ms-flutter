///Dart imports
import 'dart:developer';

///Package imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:one_to_one_callkit/call_type.dart';
import 'package:one_to_one_callkit/screens/user_list_view.dart';
import 'package:one_to_one_callkit/services/app_router.dart';
import 'package:one_to_one_callkit/services/app_utilities.dart';
import 'package:one_to_one_callkit/services/call_services.dart';
import 'package:one_to_one_callkit/services/navigation_service.dart';
import 'package:one_to_one_callkit/services/user_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Callkit: background message received");
  if (message.data["body"] != null) {
    var body = CallServices.parseStringToMap(message.data["body"]);
    var roomCode = message.data["roomInfo"];
    CallType callType =
        message.data["callType"] == "1" ? CallType.video : CallType.audio;
    log("Callkit $body");
    CallServices.receiveCall(
        UserDataModel(
            email: body["email"],
            userName: body["user_name"],
            fcmToken: body["fcm_token"],
            imgUrl: body["img_url"]),
        roomCode,
        callType);
  }
  log("Callkit: ${message.notification!.title.toString()}");
  log("Callkit: ${message.notification!.body.toString()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: HMSThemeColors.backgroundDefault, elevation: 5),
          brightness: Brightness.dark,
          primaryColor: HMSThemeColors.primaryDefault,
          scaffoldBackgroundColor: HMSThemeColors.backgroundDefault),
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.homePage,
      navigatorKey: NavigationService.navigationKey,
      navigatorObservers: <NavigatorObserver>[NavigationService.routeObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool isAuthorized = false;
  AppUtilities? appUtilities;

  @override
  void initState() {
    super.initState();
    CallServices.addCallkitUpdates();
    appUtilities = AppUtilities();
    googleSignIn();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await CallServices.getCurrentCall();
    if (currentCall != null &&
        NavigationService.instance.isCurrent(AppRoute.homePage)) {
      NavigationService.instance
          .pushNamedIfNotCurrent(AppRoute.previewPage, args: currentCall);
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///[_isUserLoggedIn] checks and listen whether user is logged in or not
  bool _isUserLoggedIn() {
    var auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        log('Callkit: User is currently signed out!');
        appUtilities?.setLoggedInUserFCM(
            userName: user?.displayName,
            email: user?.email,
            imgUrl: user?.photoURL);
        setState(() {
          isAuthorized = false;
        });
      } else {
        log('Callkit: User is signed in!');
        setState(() {
          isAuthorized = true;
        });
      }
    });

    if (auth.currentUser != null) {
      log("Callkit: User already logged in");
      appUtilities?.setLoggedInUserFCM(
          userName: auth.currentUser?.displayName,
          email: auth.currentUser?.email,
          imgUrl: auth.currentUser?.photoURL);
      return true;
    }
    log("Callkit: User is not logged in");
    return false;
  }

  ///[googleSignIn] is used to login the user
  void googleSignIn() async {
    ///Here we set the [isAuthorized] to true to show loader
    setState(() {
      isAuthorized = false;
    });

    ///If user is logged in already we stop showing the loader and fetch users.
    if (_isUserLoggedIn()) {
      setState(() {
        isAuthorized = true;
      });
      return;
    }

    ///If the user is not logged in we loing the user
    try {
      UserCredential? userCredential = await appUtilities?.loginUser();
      User? user = userCredential?.user;

      ///If the email or displayName or photoURL is null we don't signup the user
      if (user?.email != null &&
          user?.displayName != null &&
          user?.photoURL != null) {
        appUtilities?.signUpUser(
            email: user!.email!,
            userName: user.displayName!,
            imgUrl: user.photoURL!);
        setState(() {
          isAuthorized = true;
        });
      } else {
        log("Callkit: email: ${user?.email}, name: ${user?.displayName}, photoURL: ${user?.photoURL} is null");
      }
    } catch (error) {
      log(error.toString());
    }
  }

  ///If user is not authorized we show the error dialog
  void showNotAuthorizedDialog(String email) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Text(
              "Your email $email is not authorized to access the application. Please login using 100ms email.",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        ///If the user is authorized we show the user list view
        ///else we show the loader
        body: isAuthorized
            ? ChangeNotifierProvider.value(
                value: appUtilities?.userDataStore,
                child: UserListView(
                  appUtilities: appUtilities,
                ))
            : const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
      ),
    );
  }
}
