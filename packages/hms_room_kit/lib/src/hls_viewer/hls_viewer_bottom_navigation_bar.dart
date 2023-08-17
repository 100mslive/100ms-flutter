import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/service/app_debug_config.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/more_settings_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:provider/provider.dart';

class HLSViewerBottomNavigationBar extends StatelessWidget{
  const HLSViewerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Platform.isIOS?32.0:0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ///Leave Button
          HMSEmbeddedButton(
            onTap: () async =>
                {await UtilityComponents.onBackPressed(context)},
            offColor: HMSThemeColors.alertErrorDefault,
            disabledBorderColor: HMSThemeColors.alertErrorDefault,
            isActive: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/leave.svg",
                colorFilter: ColorFilter.mode(
                    HMSThemeColors.alertErrorBrighter, BlendMode.srcIn),
                semanticsLabel: "leave_room_button",
              ),
            ),
          ),
    
          ///Hand Raise Button
                  HMSEmbeddedButton(
            onTap: () => {
              context.read<MeetingStore>().getSessionMetadata(
                  SessionStoreKeyValues.getNameFromMethod(
                      SessionStoreKey.pinnedMessageSessionKey)),
              context.read<MeetingStore>().setNewMessageFalse(),
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: HMSThemeColors.backgroundDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                context: context,
                builder: (ctx) => ChangeNotifierProvider.value(
                    value: context.read<MeetingStore>(),
                    child: const ChatBottomSheet()),
              )
            },
            enabledBorderColor: HMSThemeColors.borderBright,
            onColor: HMSThemeColors.backgroundDim,
            isActive: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                colorFilter: ColorFilter.mode(
                    HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                semanticsLabel: "chat_button",
              ),
            ),
          ),
    
          ///Chat Button
          HMSEmbeddedButton(
            onTap: () => {
              context.read<MeetingStore>().getSessionMetadata(
                  SessionStoreKeyValues.getNameFromMethod(
                      SessionStoreKey.pinnedMessageSessionKey)),
              context.read<MeetingStore>().setNewMessageFalse(),
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: HMSThemeColors.backgroundDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                context: context,
                builder: (ctx) => ChangeNotifierProvider.value(
                    value: context.read<MeetingStore>(),
                    child: const ChatBottomSheet()),
              )
            },
            enabledBorderColor: HMSThemeColors.borderBright,
            onColor: HMSThemeColors.backgroundDim,
            isActive: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                colorFilter: ColorFilter.mode(
                    HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                semanticsLabel: "chat_button",
              ),
            ),
          ),
    
          ///Menu Button
          HMSEmbeddedButton(
            onTap: () async => {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: HMSThemeColors.backgroundDefault,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                context: context,
                builder: (ctx) => ChangeNotifierProvider.value(
                    value: context.read<MeetingStore>(),
                    child: MoreSettingsBottomSheet(
                      isAudioMixerDisabled:
                          AppDebugConfig.isAudioMixerDisabled,
                    )),
              )
            },
            enabledBorderColor: HMSThemeColors.borderBright,
            onColor: HMSThemeColors.backgroundDim,
            isActive: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                  "packages/hms_room_kit/lib/src/assets/icons/menu.svg",
                  colorFilter: ColorFilter.mode(
                      HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  semanticsLabel: "more_button"),
            ),
          ),
        ],
      ),
    );
  
  }

}