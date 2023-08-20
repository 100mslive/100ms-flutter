import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HMSVideoViewController extends ValueNotifier<bool> {
  final String trackId;
  late EventChannel view_channel;

  HMSVideoViewController(this.trackId) : super(false) {
    view_channel = EventChannel('$trackId');

    view_channel.receiveBroadcastStream().listen((event) {
      log("onFirstFrameRendered ${event.toString()}");
    });
  }
}
