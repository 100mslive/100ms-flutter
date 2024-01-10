import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';

class RecipientSelectorWidget extends StatefulWidget {
  const RecipientSelectorWidget({super.key});

  @override
  State<RecipientSelectorWidget> createState() =>
      _RecipientSelectorWidgetState();
}

class _RecipientSelectorWidgetState extends State<RecipientSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize: 0.7,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: HMSThemeColors.surfaceDefault,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HMSTitleText(
                          text: "Send message to",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          letterSpacing: 0.15,
                        ),
                        HMSCrossButton(
                          iconColor: HMSThemeColors.onSecondaryMediumEmphasis,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(
                      height: 1,
                      color: HMSThemeColors.borderBright,
                    ),
                  ),

                  ///TODO: Add search bar here

                  if(HMSRoomLayout.chatData?.isPublicChatEnabled??false)
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/everyone.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceMediumEmphasis,
                            BlendMode.srcIn),
                        width: 20,
                        height: 20,
                      ),
                      title: HMSTitleText(
                        text: "Everyone",
                        textColor: HMSThemeColors.onSurfaceHighEmphasis,
                        fontSize: 14,
                        letterSpacing: 0.1,
                        lineHeight: 20,
                      ),
                      trailing: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                        fit: BoxFit.scaleDown,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Divider(
                      height: 1,
                      color: HMSThemeColors.borderBright,
                    ),
                  ),

                  ///Group based selection
                  if (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                      false)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.zero,
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceMediumEmphasis,
                              BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        ),
                        title: HMSTitleText(
                          text: "ROLE GROUP",
                          textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          lineHeight: 16,
                        ),
                      ),
                    ),

                  if (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                      false)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        children: HMSRoomLayout.chatData!.rolesWhitelist
                            .map((role) => ListTile(
                                  title: HMSTitleText(
                                    text: role,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    fontSize: 14,
                                    letterSpacing: 0.1,
                                    lineHeight: 20,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Divider(
                      height: 1,
                      color: HMSThemeColors.borderBright,
                    ),
                  ),
                
                  ///Participant based selection
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/person.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceMediumEmphasis,
                            BlendMode.srcIn),
                        width: 20,
                        height: 20,
                      ),
                      title: HMSTitleText(
                        text: "DIRECT MESSAGE",
                        textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        lineHeight: 16,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }
}
