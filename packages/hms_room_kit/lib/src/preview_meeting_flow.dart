///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting_screen_controller.dart';
import 'package:hms_room_kit/src/preview/preview_page.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

///[PreviewMeetingFlow] decides whether to render preview or meeting
class PreviewMeetingFlow extends StatefulWidget {
  final HMSPrebuiltOptions? prebuiltOptions;
  final HMSSDKInteractor hmsSDKInteractor;
  final String tokenData;
  const PreviewMeetingFlow(
      {super.key,
      required this.prebuiltOptions,
      required this.hmsSDKInteractor,
      required this.tokenData});

  @override
  State<PreviewMeetingFlow> createState() => _PreviewMeetingFlowState();
}

class _PreviewMeetingFlowState extends State<PreviewMeetingFlow> {
  late PreviewStore store;

  @override
  void initState() {
    super.initState();
    if (!HMSRoomLayout.skipPreview) {
      store = PreviewStore(hmsSDKInteractor: widget.hmsSDKInteractor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HMSRoomLayout.skipPreview
        ? MeetingScreenController(
            user: widget.prebuiltOptions?.userName ??
                widget.prebuiltOptions?.userId ??
                "",
            localPeerNetworkQuality: null,
            options: widget.prebuiltOptions,
            tokenData: widget.tokenData,
            hmsSDKInteractor: widget.hmsSDKInteractor,
          )
        : ListenableProvider.value(
            value: store,
            child: PreviewPage(
              name: widget.prebuiltOptions?.userName ?? "",
              options: widget.prebuiltOptions,
              tokenData: widget.tokenData,
            ));
  }
}
