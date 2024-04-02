///Dart imports
library;

import 'dart:math' as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[HMSRecordingErrorToast] renders the toast when recording fails to start
class HMSErrorToast extends StatefulWidget {
  final HMSException error;
  final MeetingStore meetingStore;
  final Color? toastColor;
  final double? toastPosition;
  const HMSErrorToast(
      {super.key,
      required this.error,
      required this.meetingStore,
      this.toastColor,
      this.toastPosition});

  @override
  State<HMSErrorToast> createState() => _HMSErrorToastState();
}

class _HMSErrorToastState extends State<HMSErrorToast> {
  bool _showWidget = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) => {_setTimer()});
  }

  void _setTimer() {
    setState(() {
      _showWidget = false;
    });
    context.read<MeetingStore>().removeToast(HMSToastsType.errorToast);
    _showWidget = true;
  }

  @override
  Widget build(BuildContext context) {
    return _showWidget
        ? HMSToast(
            toastColor: widget.toastColor,
            toastPosition: widget.toastPosition,
            subtitle: HMSSubheadingText(
              text: widget.error.description
                  .substring(0, math.min(30, widget.error.description.length)),
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
            cancelToastButton: IconButton(
              icon: Icon(
                Icons.close,
                color: HMSThemeColors.onSurfaceHighEmphasis,
                size: 24,
              ),
              onPressed: () {
                widget.meetingStore.removeToast(HMSToastsType.errorToast);
              },
            ),
          )
        : const SizedBox();
  }
}
