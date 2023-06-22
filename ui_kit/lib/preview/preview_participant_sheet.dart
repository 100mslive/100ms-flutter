import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PreviewParticipantSheet extends StatefulWidget {
  const PreviewParticipantSheet({super.key});

  @override
  State<PreviewParticipantSheet> createState() =>
      _PreviewParticipantSheetState();
}

class _PreviewParticipantSheetState extends State<PreviewParticipantSheet> {
  String valueChoose = "Everyone";

  void _updateDropDownValue(dynamic newValue) {
    setState(() {
      valueChoose = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Tuple2<List<HMSPeer>, int> getFilteredPeers(
      String valueChoose, List<HMSPeer> peers) {
    if (valueChoose == "Everyone") {
      return Tuple2(peers, peers.length);
    }
    List<HMSPeer> filteredPeers =
        peers.where((element) => element.role.name == valueChoose).toList();
    return Tuple2(filteredPeers, filteredPeers.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.81,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: themeBottomSheetColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Participants",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButtonHideUnderline(
                      child: Selector<PreviewStore, List<HMSRole>>(
                          selector: (_, previewStore) => previewStore.roles,
                          builder: (context, roles, _) {
                            return HMSDropDown(
                                dropDownItems: <DropdownMenuItem>[
                                  DropdownMenuItem(
                                    value: "Everyone",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/participants.svg",
                                          fit: BoxFit.scaleDown,
                                          color: themeDefaultColor,
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text(
                                          "Everyone",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            letterSpacing: 0.4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "Raised Hand",
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/hand_outline.svg",
                                          fit: BoxFit.scaleDown,
                                          color: themeDefaultColor,
                                          height: 16,
                                        ),
                                        const SizedBox(
                                          width: 11,
                                        ),
                                        Text(
                                          "Raised Hand",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            letterSpacing: 0.4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...roles
                                      .sortedBy((element) =>
                                          element.priority.toString())
                                      .map((role) => DropdownMenuItem(
                                            value: role.name,
                                            child: Text(
                                              "${role.name}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: iconColor),
                                            ),
                                          ))
                                      .toList(),
                                ],
                                dropdownButton: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 8, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: borderColor,
                                          style: BorderStyle.solid,
                                          width: 0.80)),
                                  child: Row(
                                    children: [
                                      Text(
                                        valueChoose,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0.4,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                                buttonStyleData:
                                    const ButtonStyleData(width: 100, height: 35),
                                dropdownStyleData: DropdownStyleData(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: themeSurfaceColor),
                                    offset: const Offset(-10, -10)),
                                iconStyleData: IconStyleData(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  iconEnabledColor: iconColor,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 45,
                                ),
                                selectedValue: valueChoose,
                                updateSelectedValue: _updateDropDownValue);
                          }),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/icons/close_button.svg",
                              width: 40,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Divider(
                    color: dividerColor,
                    height: 5,
                  ),
                ),
                Selector<PreviewStore, Tuple2<List<HMSPeer>, int>>(
                    selector: (_, previewStore) =>
                        getFilteredPeers(valueChoose, previewStore.peers),
                    builder: (_, data, __) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.item2,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  horizontalTitleGap: 5,
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Utilities.getBackgroundColour(
                                            data.item1[index].name),
                                    radius: 16,
                                    child: Text(
                                        Utilities.getAvatarTitle(
                                            data.item1[index].name),
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: themeDefaultColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  title: Text(
                                    data.item1[index].name,
                                    maxLines: 1,
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: themeDefaultColor,
                                        letterSpacing: 0.15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    data.item1[index].role.name,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: themeSubHeadingColor,
                                        letterSpacing: 0.40,
                                        fontWeight: FontWeight.w400),
                                  ));
                            }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
