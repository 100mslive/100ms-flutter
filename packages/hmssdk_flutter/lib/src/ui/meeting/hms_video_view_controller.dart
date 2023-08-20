import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HMSVideoViewController extends ValueNotifier<bool> {
  final String trackId;
  late EventChannel view_channel;

  HMSVideoViewController(this.trackId) : super(false) {
    view_channel = EventChannel('hms_video_view_channel');

    view_channel.receiveBroadcastStream({"name": trackId}).map((event) {
      log("Vkohli receiveBroadcastStream ${DateTime.
      now()} ${trackId} ${event.toString()}}");
    }).listen((event) {});
  }
}
