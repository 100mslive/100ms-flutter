library;

///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/model/transcript_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[TranscriptionView] is a widget that displays the transcription of the meeting
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
              ? Selector<MeetingStore, Tuple2<List<TranscriptStore>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.captions, meetingStore.captions.length),
                  builder: (_, data, __) {
                    return data.item2 > 0
                        ? Selector<MeetingStore, Tuple2<bool, bool>>(
                            selector: (_, meetingStore) => Tuple2(
                                meetingStore.isOverlayChatOpened,
                                meetingStore.toasts.isNotEmpty),
                            builder: (_, isUIElementPresent, __) {
                              return Selector<
                                      MeetingNavigationVisibilityController,
                                      bool>(
                                  selector:
                                      (_, meetingNavigationVisibilityController) =>
                                          meetingNavigationVisibilityController
                                              .showControls,
                                  builder: (_, showControls, __) {
                                    double bottomMargin = showControls
                                        ? Platform.isIOS
                                            ? 110
                                            : 90
                                        : Platform.isIOS
                                            ? 80
                                            : 50;

                                    ///If toasts are present then we need to adjust the bottom margin
                                    bottomMargin += isUIElementPresent.item2
                                        ? showControls
                                            ? 40
                                            : 80
                                        : 0;
                                    return Positioned(
                                      ///If overlay chat is opened then we need to adjust the top margin(shift the chat to top)
                                      ///else we keep it at the bottom
                                      bottom: isUIElementPresent.item1
                                          ? null
                                          : bottomMargin,
                                      top: isUIElementPresent.item1
                                          ? showControls
                                              ? 80
                                              : 50
                                          : null,
                                      left: 5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  15,
                                              height: 100,
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  // color: Colors.red,
                                                  color: Colors.black
                                                      .withAlpha(64),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),

                                              ///Here we render the list of transcriptions
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: data.item2,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ChangeNotifierProvider
                                                        .value(
                                                      value: data.item1[index],
                                                      child: Selector<
                                                              TranscriptStore,
                                                              String>(
                                                          selector: (_,
                                                                  transcriptStore) =>
                                                              transcriptStore
                                                                  .transcript,
                                                          builder: (_,
                                                              transcript, __) {
                                                            ///Here we render the transcriptions
                                                            ///with peer name in bold and transcript in normal font
                                                            return RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  if (index !=
                                                                          0 &&
                                                                      data.item1[index].peerName ==
                                                                          data.item1[index - 1]
                                                                              .peerName)
                                                                    TextSpan(
                                                                      text: "",
                                                                      style: TextStyle(
                                                                          color: HMSThemeColors
                                                                              .onSurfaceHighEmphasis,
                                                                          fontSize:
                                                                              14,
                                                                          height: 20 /
                                                                              14,
                                                                          letterSpacing:
                                                                              0.25),
                                                                    )
                                                                  else
                                                                    TextSpan(
                                                                      text:
                                                                          "${data.item1[index].peerName}: ",
                                                                      style: TextStyle(
                                                                          color: HMSThemeColors
                                                                              .onSurfaceHighEmphasis,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          height: 20 /
                                                                              14,
                                                                          letterSpacing:
                                                                              0.25),
                                                                    ),
                                                                  TextSpan(
                                                                    text:
                                                                        transcript,
                                                                    style: TextStyle(
                                                                        color: HMSThemeColors
                                                                            .onSurfaceHighEmphasis,
                                                                        fontSize:
                                                                            14,
                                                                        height:
                                                                            20 /
                                                                                14,
                                                                        letterSpacing:
                                                                            0.25),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    );
                                                  })),
                                        ],
                                      ),
                                    );
                                  });
                            })
                        : const SizedBox();
                  })
              : const SizedBox();
        });
  }
}
