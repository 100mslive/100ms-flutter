import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/hmssdk_uikit.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: themeBottomSheetColor, elevation: 5),
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 13, 107, 184),
          scaffoldBackgroundColor: Colors.black),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController meetingLinkController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/welcome.svg',
                width: width * 0.95,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text('Experience the power of 100ms',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: 0.25,
                        color: themeDefaultColor,
                        height: 1.17,
                        fontSize: 34,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                    'Jump right in by pasting a room link or scanning a QR code',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        letterSpacing: 0.5,
                        color: themeSubHeadingColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Joining Link",
                        key: const Key('joining_link_text'),
                        style: GoogleFonts.inter(
                            color: themeDefaultColor,
                            height: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              SizedBox(
                width: width * 0.95,
                child: TextField(
                  key: const Key('meeting_link_field'),
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.inter(),
                  controller: meetingLinkController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      focusColor: hmsdefaultColor,
                      contentPadding: const EdgeInsets.only(left: 16),
                      fillColor: themeSurfaceColor,
                      filled: true,
                      hintText: 'Paste the link here',
                      hintStyle: GoogleFonts.inter(
                          color: hmsHintColor,
                          height: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      suffixIcon: meetingLinkController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                meetingLinkController.text = "";
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: width * 0.95,
                child: TextField(
                  key: const Key('name_field'),
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.inter(),
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      focusColor: hmsdefaultColor,
                      contentPadding: const EdgeInsets.only(left: 16),
                      fillColor: themeSurfaceColor,
                      filled: true,
                      hintText: 'Enter the name here',
                      hintStyle: GoogleFonts.inter(
                          color: hmsHintColor,
                          height: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      suffixIcon: nameController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                nameController.text = "";
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: width * 0.95,
                child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: meetingLinkController,
                    builder: (context, value, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: meetingLinkController.text.isEmpty
                              ? themeSurfaceColor
                              : hmsdefaultColor,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all(
                                      themeSurfaceColor),
                                  backgroundColor:
                                      meetingLinkController.text.isEmpty
                                          ? MaterialStateProperty.all(
                                              themeSurfaceColor)
                                          : MaterialStateProperty.all(
                                              hmsdefaultColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ))),
                              onPressed: () async {
                                if (nameController.text.isNotEmpty &&
                                    meetingLinkController.text.isNotEmpty) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => const HMSRoomKit(
                                            roomCode: "bfv-knhs-jgi",
                                          )));
                                } else {
                                  Utilities.showToast(
                                      "Please enter the details");
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 8, 12),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: TitleText(
                                  key: const Key('join_now'),
                                  text: 'Join Now',
                                  textColor:
                                      (meetingLinkController.text.isEmpty ||
                                              nameController.text.isEmpty)
                                          ? themeDisabledTextColor
                                          : enabledTextColor,
                                ),
                              ),
                            )),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: width * 0.95,
                  child: Divider(
                    height: 5,
                    color: dividerColor,
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
