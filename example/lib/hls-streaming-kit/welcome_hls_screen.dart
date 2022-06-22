import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class WelcomeHLSScreen extends StatefulWidget {
  @override
  State<WelcomeHLSScreen> createState() => _WelcomeHLSScreenState();
}

class _WelcomeHLSScreenState extends State<WelcomeHLSScreen> {

  TextEditingController nameController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            SvgPicture.asset('assets/icons/user-music.svg',width: width/4,),
            SizedBox(
              height: 40,
            ),
            Text("Go live in five!",
                style: GoogleFonts.inter(
                    color: defaultColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 15,
            ),
            Text("Let's get started with your name",
                style: GoogleFonts.inter(
                    color: subHeadingColor,
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: width * 0.95,
              child: TextField(
                style: GoogleFonts.inter(),
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    fillColor: surfaceColor,
                    filled: true,
                    hintText: 'Enter your name here',
                    hintStyle: GoogleFonts.inter(
                        color: hintColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    // suffixIcon: IconButton(
                    //   onPressed: nameController.clear,
                    //   icon: Icon(Icons.clear),
                    // ),
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
            SizedBox(
                    width: width * 0.6,
                    child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: nameController,
                        builder: (context, value, child) {
                          return ElevatedButton(
                            style: ButtonStyle(
                                shadowColor:
                                    MaterialStateProperty.all(surfaceColor),
                                backgroundColor: nameController.text.isEmpty
                                    ? MaterialStateProperty.all(surfaceColor)
                                    : MaterialStateProperty.all(Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ))),
                            onPressed: () async {
                              if (nameController.text.isEmpty) {
                                return;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Get Started',
                                      style: GoogleFonts.inter(
                                          color: nameController.text.isEmpty
                                              ? disabledTextColor
                                              : enabledTextColor,
                                          height: 1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 4,),
                                  Icon(Icons.arrow_forward,color: nameController.text.isEmpty
                                              ? disabledTextColor
                                              : enabledTextColor,size: 16,)
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                 
                  ],
                ),
          )),
    );
  }
}
