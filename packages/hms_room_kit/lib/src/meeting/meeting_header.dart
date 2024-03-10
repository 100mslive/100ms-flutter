///Dart imports
library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_meeting_timer.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';

///This widget is used to show the header of the meeting screen
///It contains the logo, live indicator, recording indicator, number of peers
///and the switch camera and audio device selection buttons
class MeetingHeader extends StatefulWidget {
  const MeetingHeader({super.key});

  @override
  State<MeetingHeader> createState() => _MeetingHeaderState();
}

class _MeetingHeaderState extends State<MeetingHeader> {
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingNavigationVisibilityController, bool>(
        selector: (_, meetingNavigationVisibilityController) =>
            meetingNavigationVisibilityController.showControls,
        builder: (_, showControls, __) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: showControls
                ? (Constant.prebuiltOptions?.isVideoCall ?? false)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ///TODO: Add image url check
                              // if (imgUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: ClipOval(
                                    child: Image.network(
                                  "https://lh3.googleusercontent.com/a/ACg8ocKQA0ztVW296eh8zAz6KuaS7A_b8TzNA_unBRqUv3dg=s96-c",
                                  height: 40,
                                  width: 40,
                                )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HMSTitleText(
                                    text: "Alex K",
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    fontSize: 24,
                                    lineHeight: 32,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  HMSMeetingTimer()
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              HMSEmbeddedButton(
                                  onTap: () async {
                                    context.read<MeetingStore>().leave();
                                    Navigator.pop(context);
                                  },
                                  isActive: true,
                                  onColor: HMSThemeColors.alertErrorDefault,
                                  child: SvgPicture.asset(
                                    'packages/hms_room_kit/lib/src/assets/icons/close.svg',
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    fit: BoxFit.scaleDown,
                                    semanticsLabel: "end_call_button",
                                  )),

                              ///This renders the switch camera button
                              ///If the role is allowed to publish video, we render the switch camera button
                              ///else we render an empty SizedBox
                              ///
                              ///If the video is on we disable the button
                              // Selector<MeetingStore, Tuple2<bool, List<String>?>>(
                              //     selector: (_, meetingStore) => Tuple2(
                              //         meetingStore.isVideoOn,
                              //         meetingStore.localPeer?.role.publishSettings
                              //                 ?.allowed ??
                              //             []),
                              //     builder: (_, data, __) {
                              //       return (data.item2?.contains("video") ?? false)
                              //           ? HMSEmbeddedButton(
                              //               onTap: () => {
                              //                 if (data.item1)
                              //                   {
                              //                     context
                              //                         .read<MeetingStore>()
                              //                         .switchCamera()
                              //                   }
                              //               },
                              //               isActive: true,
                              //               onColor: HMSThemeColors.backgroundDim,
                              //               child: SvgPicture.asset(
                              //                 "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                              //                 colorFilter: ColorFilter.mode(
                              //                     data.item1
                              //                         ? HMSThemeColors
                              //                             .onSurfaceHighEmphasis
                              //                         : HMSThemeColors
                              //                             .onSurfaceLowEmphasis,
                              //                     BlendMode.srcIn),
                              //                 fit: BoxFit.scaleDown,
                              //                 semanticsLabel: "fl_switch_camera",
                              //               ),
                              //             )
                              //           : const SizedBox();
                              //     }),
                            ],
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // if (Constant.prebuiltOptions?.userImgUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ClipOval(
                                    child: Image.network(
                                  "https://lh3.googleusercontent.com/a/ACg8ocKQA0ztVW296eh8zAz6KuaS7A_b8TzNA_unBRqUv3dg=s96-c",
                                  // Constant.prebuiltOptions!.userImgUrl!,
                                  height: 56,
                                  width: 56,
                                )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  HMSTitleText(
                                    text: "Alex K",
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    fontSize: 24,
                                    lineHeight: 32,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  HMSMeetingTimer()
                                ],
                              ),
                            ]),
                      )
                : const SizedBox(),
          );
        });
  }
}
