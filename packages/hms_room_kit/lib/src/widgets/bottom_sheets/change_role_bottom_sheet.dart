library;

///Dart imports
import 'dart:math' as Math;

///Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';

///[ChangeRoleBottomSheet] is a bottom sheet that allows the user to change the role of a peer it contains a dropdown to select the new role for the peer
class ChangeRoleBottomSheet extends StatefulWidget {
  final String peerName;
  final List<HMSRole> roles;
  final Function(HMSRole, bool) changeRole;
  final bool force;
  final HMSPeer peer;
  const ChangeRoleBottomSheet({
    super.key,
    required this.peerName,
    required this.roles,
    required this.changeRole,
    required this.peer,
    this.force = true,
  });

  @override
  ChangeRoleBottomSheetState createState() => ChangeRoleBottomSheetState();
}

class ChangeRoleBottomSheetState extends State<ChangeRoleBottomSheet> {
  HMSRole? roleSelected;

  void _updateDropDownValue(dynamic newValue) {
    roleSelected = newValue;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    roleSelected = widget.roles[0];
  }

  @override
  Widget build(BuildContext context) {
    String message =
        "Switch the role of '${widget.peerName.substring(0, Math.min(30, widget.peerName.length))}' from '${widget.peer.role.name.substring(0, Math.min(20, widget.peer.role.name.length))}' to ";
    return FractionallySizedBox(
      heightFactor: 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HMSTitleText(
                  text: "Switch Role",
                  fontSize: 20,
                  letterSpacing: 0.15,
                  textColor: HMSThemeColors.onSecondaryHighEmphasis,
                ),
                HMSCrossButton()
              ],
            ),
            HMSSubtitleText(
              text: message,
              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              maxLines: 2,
            ),
            const SizedBox(
              height: 24,
            ),
            DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: <DropdownMenuItem>[
                  ...widget.roles
                      .where((role) => ((role.name != widget.peer.role.name) &&
                          (role.name != '__internal_recorder')))
                      .sortedBy((element) => element.priority.toString())
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: HMSTitleText(
                              text: role.name,
                              textColor: HMSThemeColors.onSurfaceHighEmphasis,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ))
                      .toList(),
                ],
                    iconStyleData: IconStyleData(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconEnabledColor: HMSThemeColors.onSurfaceHighEmphasis,
                    ),
                    selectedValue: roleSelected,
                    updateSelectedValue: _updateDropDownValue)),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      roleSelected == null
                          ? HMSThemeColors.primaryDisabled
                          : HMSThemeColors.primaryDefault),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              onPressed: () => {
                Navigator.pop(context),
                if (roleSelected != null)
                  {widget.changeRole(roleSelected!, true)}
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: HMSTitleText(
                            text: "Switch Role",
                            textColor: HMSThemeColors.onPrimaryHighEmphasis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
