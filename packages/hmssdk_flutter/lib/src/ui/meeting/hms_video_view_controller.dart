import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HMSVideoViewController extends ValueNotifier<bool> {
  final String viewId;
  late EventChannel view_channel;

  HMSVideoViewController(this.viewId) : super(false) {
    view_channel = EventChannel('hms_video_view_$viewId');

    view_channel.receiveBroadcastStream().listen((event) {
      log("onFirstFrameRendered ${event.toString()}");
    });
  }
}
