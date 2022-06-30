import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class HLSParticipantSheet extends StatefulWidget {
  @override
  State<HLSParticipantSheet> createState() => _HLSParticipantSheetState();
}

class _HLSParticipantSheetState extends State<HLSParticipantSheet> {
  String valueChoose = "Everyone";

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
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
                      color: defaultColor,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: hintColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Selector<MeetingStore,
                            Tuple2<List<HMSRole>, List<HMSPeer>>>(
                        selector: (_, meetingStore) =>
                            Tuple2(meetingStore.roles, meetingStore.peers),
                        builder: (context, data, _) {
                          List<HMSRole> roles = data.item1;
                          return DropdownButton2(
                            isExpanded: true,
                            dropdownWidth:
                                MediaQuery.of(context).size.width * 0.4,
                            buttonWidth: 100,
                            buttonHeight: 32,
                            itemHeight: 48,
                            value: valueChoose,
                            icon: Icon(Icons.keyboard_arrow_down),
                            dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: surfaceColor),
                            offset: Offset(-10, -10),
                            iconEnabledColor: iconColor,
                            // selectedItemHighlightColor: Colors.blue,
                            onChanged: (dynamic newvalue) {
                              setState(() {
                                this.valueChoose = newvalue as String;
                              });
                            },
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text(
                                  "Everyone",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    letterSpacing: 0.4,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                value: "Everyone",
                              ),
                              ...roles
                                  .sortedBy((element) =>
                                      element.priority.toString())
                                  .map((role) => DropdownMenuItem(
                                        child: Text(
                                          "${role.name}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.inter(
                                              color: iconColor),
                                        ),
                                        value: role.name,
                                      ))
                                  .toList(),
                            ],
                          );
                        }),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: borderColor,
                        child: IconButton(
                          icon: SvgPicture.asset("assets/icons/close.svg"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: dividerColor,
                height: 5,
              ),
            ),
            Selector<MeetingStore, Tuple2<List<HMSPeer>, int>>(
                selector: (_, meetingStore) =>
                    Tuple2(meetingStore.peers, meetingStore.peers.length),
                builder: (_, data, __) {
                  List<HMSPeer> copyList = [];

                  copyList.addAll(data.item1);
                  List<HMSPeer> peerList = [];

                  peerList.add(copyList.removeAt(
                      copyList.indexWhere((element) => element.isLocal)));
                  if (valueChoose == "Everyone") {
                    peerList.addAll(copyList.sortedBy(
                        (element) => element.role.priority.toString()));
                  } else {
                    peerList = copyList
                        .where((element) => element.role.name == valueChoose)
                        .toList();
                  }
                  print(peerList);
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: peerList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          horizontalTitleGap: 5,
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "assets/icons/avatar.svg",
                            width: 32,
                          ),
                          title: Text(
                            peerList[index].name +
                                (peerList[index].isLocal ? " (You)" : ""),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                color: defaultColor,
                                letterSpacing: 0.15,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            peerList[index].role.name,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: subHeadingColor,
                                letterSpacing: 0.40,
                                fontWeight: FontWeight.w400),
                          ),
                          trailing: GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              "assets/icons/more.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
