import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/change_name_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/more_option_item.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

class HLSMoreOptionsBottomSheet extends StatefulWidget {
  const HLSMoreOptionsBottomSheet({super.key});

  @override
  State<HLSMoreOptionsBottomSheet> createState() =>
      _HLSMoreOptionsBottomSheetBottomSheetState();
}

class _HLSMoreOptionsBottomSheetBottomSheetState
    extends State<HLSMoreOptionsBottomSheet> {
  bool isStatsEnabled = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.23,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      HMSTitleText(
                        text: "Options",
                        textColor: HMSThemeColors.onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: HMSThemeColors.onSurfaceHighEmphasis,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Divider(
                  color: HMSThemeColors.borderDefault,
                  height: 5,
                ),
              ),
              Row(
                children: [
                  MoreOptionItem(
                      onTap: () async {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: HMSThemeColors.surfaceDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: context.read<MeetingStore>(),
                              child: const ParticipantsBottomSheet()),
                        );
                      },
                      optionIcon: badge.Badge(
                        badgeStyle: badge.BadgeStyle(
                            badgeColor: HMSThemeColors.surfaceDefault,
                            padding: EdgeInsets.all(
                                context.read<MeetingStore>().peers.length < 1000
                                    ? 5
                                    : 8)),
                        badgeContent: HMSTitleText(
                          text: context
                              .read<MeetingStore>()
                              .peers
                              .length
                              .toString(),
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 10,
                          lineHeight: 16,
                          letterSpacing: 1.5,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (context.read<MeetingStore>().peers.length <
                                          1000
                                      ? 5
                                      : 10)),
                          child: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      optionText: "Participants"),
                  const SizedBox(
                    width: 12,
                  ),
                  MoreOptionItem(
                      onTap: () async {
                        var meetingStore = context.read<MeetingStore>();
                        Navigator.pop(context);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: HMSThemeColors.surfaceDim,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: meetingStore,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(ctx).viewInsets.bottom),
                                  child: const ChangeNameBottomSheet())),
                        );
                      },
                      optionIcon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                      optionText: "Change Name")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}