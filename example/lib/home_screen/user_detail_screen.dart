import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/hms_prebuilt_options.dart';
import 'package:hmssdk_uikit/hmssdk_uikit.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_listenable_button.dart';

class UserDetailScreen extends StatefulWidget {
  final String meetingLink;
  final bool autofocusField;
  UserDetailScreen({required this.meetingLink, this.autofocusField = false});
  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    nameController.text = await Utilities.getStringData(key: "name");
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool res = false;
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/user-music.svg',
              width: width / 4,
            ),
            SizedBox(
              height: 40,
            ),
            Text("Go live in five!",
                style: GoogleFonts.inter(
                    color: themeDefaultColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 4,
            ),
            Text("Let's get started with your name",
                style: GoogleFonts.inter(
                    color: themeSubHeadingColor,
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width * 0.95,
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HMSPrebuilt(
                                roomCode: widget.meetingLink,
                                hmsConfig: HMSPrebuiltOptions(
                                    userName: nameController.text),
                              )));
                },
                autofocus: widget.autofocusField,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.inter(),
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: nameController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              nameController.text = "";
                              setState(() {});
                            },
                            icon: Icon(Icons.clear),
                          ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    fillColor: themeSurfaceColor,
                    filled: true,
                    hintText: 'Enter your name here',
                    hintStyle: GoogleFonts.inter(
                        color: themeHintColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            HMSListenableButton(
                width: width * 0.5,
                onPressed: () async => {
                      log(context.hashCode.toString()),
                      FocusManager.instance.primaryFocus?.unfocus(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HMSPrebuilt(
                                    roomCode: widget.meetingLink,
                                    hmsConfig: HMSPrebuiltOptions(
                                        userName: nameController.text),
                                  )))
                    },
                childWidget: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Started',
                          style: GoogleFonts.inter(
                              color: nameController.text.isEmpty
                                  ? themeDisabledTextColor
                                  : enabledTextColor,
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: nameController.text.isEmpty
                            ? themeDisabledTextColor
                            : enabledTextColor,
                        size: 16,
                      )
                    ],
                  ),
                ),
                textController: nameController,
                errorMessage: "Please enter you name")
          ],
        ),
      )),
    );
  }
}
