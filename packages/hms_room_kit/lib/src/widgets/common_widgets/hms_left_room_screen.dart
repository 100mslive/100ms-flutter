///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart' as roomlayout;
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[HMSLeftRoomScreen] is the screen that is shown after a user leaves the room
class HMSLeftRoomScreen extends StatelessWidget {
  final bool isEndRoomCalled;
  final bool doesRoleHasStreamPermission;
  const HMSLeftRoomScreen(
      {super.key,
      this.isEndRoomCalled = false,
      this.doesRoleHasStreamPermission = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HMSThemeColors.backgroundDim,
        body: Theme(
          data: ThemeData(
              brightness: Brightness.dark,
              primaryColor: HMSThemeColors.primaryDefault,
              scaffoldBackgroundColor: HMSThemeColors.backgroundDim),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => {
                      ///Here we reset the layout colors and pop the leave screen
                      HMSThemeColors.resetLayoutColors(),
                      Navigator.pop(context)
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: HMSThemeColors.surfaceDefault,
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/close.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/wave_hand.svg",
                    height: 64,
                    width: 64,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  HMSTitleText(
                    ///The text is different if the room is ended by you or by someone else
                    ///If the room end is called, and peer role type is hlsViewer the text is "Stream ended"
                    ///If the room end is called, and peer role type is conferencing the text is "Session ended"
                    ///If you leave the room, and peer role type is hlsViewer the text is "You left the stream"
                    ///If tyou leave the room, and peer role type is conferencing the text is "You left the meeting"
                    text: (doesRoleHasStreamPermission ||
                            roomlayout.HMSRoomLayout.peerType ==
                                roomlayout.PeerRoleType.hlsViewer)
                        ? "You left the stream"
                        : isEndRoomCalled
                            ? "Session ended"
                            : "You left the meeting",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    fontSize: 24,
                    lineHeight: 32,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  HMSTitleText(
                    text: "Have a nice day!",
                    textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 48,
                  ),

                  ///If the room is ended and peer role type is hlsViewer, we don't show the text
                  HMSSubheadingText(

                      ///The text is different if the room is ended by you or by someone else
                      ///If the room end is called, and peer role type is conferencing the text is "Ended by mistake?"
                      ///If you leave the room, the text is "Left by mistake?"
                      text: (doesRoleHasStreamPermission || !(isEndRoomCalled))
                          ? "Left by mistake?"
                          : "Ended by mistake?",
                      textColor: HMSThemeColors.onSurfaceMediumEmphasis),
                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(
                              HMSThemeColors.surfaceDim),
                          backgroundColor: MaterialStateProperty.all(
                              HMSThemeColors.primaryDefault),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () => {
                            HMSThemeColors.resetLayoutColors(),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HMSPrebuilt(
                                          roomCode: Constant.roomCode,
                                          authToken: Constant.authToken,
                                          options: Constant.prebuiltOptions,
                                          onLeave: Constant.onLeave,
                                        ))),
                          },
                      child: SizedBox(
                        height: 48,
                        width:
                            (doesRoleHasStreamPermission || !(isEndRoomCalled))
                                ? 91
                                : 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "packages/hms_room_kit/lib/src/assets/icons/login.svg",
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                  HMSThemeColors.onPrimaryHighEmphasis,
                                  BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            HMSTitleText(
                              ///The text is different if the room is ended or not
                              ///If the room end is called, the text is "Restart"
                              ///If you leave the room, the text is "Rejoin"
                              text: (doesRoleHasStreamPermission ||
                                      !(isEndRoomCalled))
                                  ? "Rejoin"
                                  : "Restart",
                              textColor: HMSThemeColors.onPrimaryHighEmphasis,
                            )
                          ],
                        ),
                      ))
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
