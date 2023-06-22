//Package imports

import 'package:flutter/material.dart';
import 'package:hms_callkit/home_page.dart';
import 'package:hms_callkit/hmssdk/meeting_page.dart';
import 'package:hms_callkit/hmssdk/preview_page.dart';
import 'package:hms_callkit/receive_call.dart';

class AppRoute {
  static const homePage = '/home_page';

  static const callingPage = '/meeting_page';
  static const previewPage = '/preview_page';
  static const receiveCallPage = '/receive-call-page';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
            builder: (_) => const HomePage(), settings: settings);
      case callingPage:
        return MaterialPageRoute(
            builder: (_) => MeetingPage(
                  authToken: settings.arguments as String?,
                  userName: 'Test User',
                ),
            settings: settings);
      case previewPage:
        return MaterialPageRoute(
            builder: (_) => PreviewPage(
                  authToken: settings.arguments as String?,
                  userName: 'Test User',
                ),
            settings: settings);
      case receiveCallPage:
        return MaterialPageRoute(
            builder: (_) => ReceiveCall(
                callKitParams: settings.arguments as Map<String, dynamic>));
      default:
        return null;
    }
  }
}
