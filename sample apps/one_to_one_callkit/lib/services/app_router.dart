///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:one_to_one_callkit/main.dart';
import 'package:one_to_one_callkit/screens/loading_screen.dart';
import 'package:uuid/uuid.dart';

///[AppRoute] class is used to define the routes of the application
class AppRoute {
  static const homePage = '/';
  static const previewPage = '/preview';
  static const loadingPage = '/loading';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    ///[settings.name] is used to get the route name
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MyHomePage());

      case loadingPage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const LoadingScreen());

      case previewPage:
        String? userName, imgURL;
        bool? isVideoCall = false;
        String? roomCode = "";
        Function? onLeave;
        var arguments;

        if (settings.arguments is Map) {
          // Attempt to safely cast to the desired type
          arguments = Map<String?, dynamic>.from(settings.arguments as Map);
        } else {
          // Provide a sensible default or handle the error appropriately
          arguments = null; // Or null, depending on your use case
        }
        if (arguments != null) {
          userName = arguments["user_name"];
          imgURL = arguments["user_img_url"];
          isVideoCall = arguments["is_video_call"];
          roomCode = arguments["room_code"] ?? "";
          onLeave = arguments["on_leave"];
          log("Callkit: Calling preview Page roomCode: $roomCode");

          ///[HMSPrebuilt] is used to create a prebuilt UI for the room
          ///This is the entry point for `hms_room_kit` package
          return MaterialPageRoute(
              settings: settings,
              builder: (_) => HMSPrebuilt(
                  roomCode: roomCode,
                  onLeave: onLeave,
                  options: HMSPrebuiltOptions(
                    userName: userName,
                    userImgUrl: imgURL,
                    isVideoCall: isVideoCall ?? true,
                    userId: const Uuid()
                        .v4(), // pass your custom unique user identifier here
                  )));
        }
      default:
        return null;
    }
    return null;
  }
}
