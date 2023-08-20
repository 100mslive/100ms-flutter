import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/src/enum/hms_video_view_events.dart';

class HMSVideoViewController extends ValueNotifier<bool> {
  final String trackId;
  final Function()? onFirstFrameRendered;
  final Function()? onResolutionChanged;

  late EventChannel viewChannel;

  HMSVideoViewController(
      this.trackId, this.onFirstFrameRendered, this.onResolutionChanged)
      : super(false) {
    viewChannel = EventChannel('hms_video_view_channel');

    viewChannel.receiveBroadcastStream({"name": trackId}).map((event) {
      switch (HMSVideoViewEventsValues.getHMSVideoViewEventFromString(
          event["event_name"])) {
        case HMSVideoViewEvents.onFirstFrameRendered:
          log("Vkohli onFirstFrameRendered ${DateTime.now()} ${trackId} ${event.toString()}}");
          if (onFirstFrameRendered != null) {
            onFirstFrameRendered!();
          }
          break;
        case HMSVideoViewEvents.onResolutionChanged:
          log("Vkohli onResolutionChanged ${DateTime.now()} ${trackId} ${event.toString()}}");
          if (onResolutionChanged != null) {
            onResolutionChanged!();
          }
          break;
        case HMSVideoViewEvents.unknown:
          log("Unknown");
          break;
      }
    }).listen((event) {});
  }
}
