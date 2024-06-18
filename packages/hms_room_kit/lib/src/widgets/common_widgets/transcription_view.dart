import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class TranscriptionView extends StatefulWidget {
  const TranscriptionView({Key? key}) : super(key: key);
  @override
  State<TranscriptionView> createState() => _TranscriptionViewState();
}

class _TranscriptionViewState extends State<TranscriptionView> {
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, bool>(
        selector: (_, meetingStore) => meetingStore.isTranscriptionDisplayed,
        builder: (_, isTranscriptionDisplayed, __) {
          return isTranscriptionDisplayed
              ? Selector<MeetingStore, Tuple2<List<HMSTranscription>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.captions, meetingStore.captions.length),
                  builder: (_, data, __) {
                    String transcript = "";
                    for (var i = 0; i < data.item2; i++) {
                      transcript +=
                          "${data.item1[i].peerName}: ${data.item1[i].transcript}\n";
                    }
                    return data.item2 > 0
                        ? Selector<MeetingNavigationVisibilityController, bool>(
                            selector:
                                (_, meetingNavigationVisibilityController) =>
                                    meetingNavigationVisibilityController
                                        .showControls,
                            builder: (_, showControls, __) {
                              double topMargin = showControls
                                  ? Platform.isIOS
                                      ? 250
                                      : 180
                                  : Platform.isIOS
                                      ? 200
                                      : 110;
                              return DraggableWidget(
                                bottomMargin: topMargin,
                                topMargin: showControls ? 80 : 40,
                                horizontalSpace: 8,
                                dragAnimationScale: 1,
                                normalShadow:
                                    BoxShadow(color: Colors.transparent),
                                draggingShadow:
                                    BoxShadow(color: Colors.transparent),
                                initialPosition: AnchoringPosition.bottomRight,
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(64),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: HMSSubtitleText(
                                        text: transcript,
                                        maxLines: 5,
                                        textColor: HMSThemeColors
                                            .onSurfaceHighEmphasis)),
                              );
                            })
                        : const SizedBox();
                  })
              : const SizedBox();
        });
  }
}
