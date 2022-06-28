import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hms_button.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class HLSBottomSheet extends StatefulWidget {
  @override
  State<HLSBottomSheet> createState() => _HLSBottomSheetState();
}

class _HLSBottomSheetState extends State<HLSBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: borderColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: defaultColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "START STREAMING",
                        style: GoogleFonts.inter(
                            color: subHeadingColor,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "HLS",
                        style: GoogleFonts.inter(
                            color: defaultColor,
                            fontSize: 20,
                            letterSpacing: 0.15,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  height: 5,
                  color: dividerColor,
                ),
              ),
              SvgPicture.asset(
                "assets/icons/live.svg",
                color: defaultColor,
                width: 33,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "HLS Streaming",
                style: GoogleFonts.inter(
                    color: defaultColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 0.15),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Stream directly from the browser using any device with multiple hosts and real-time messaging, all within this platform.",
                style: GoogleFonts.inter(
                    color: subHeadingColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.25),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: surfaceColor),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/record.svg",
                            color: defaultColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Record the stream",
                            style: GoogleFonts.inter(
                                color: defaultColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.25),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                              scale: 0.6,
                              transformHitTests: false,
                              child: CupertinoSwitch(
                                  value: false, onChanged: (bool newValue) {}))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              HMSButton(
                  width: MediaQuery.of(context).size.width - 30,
                  onPressed: () {},
                  childWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/live.svg",
                          color: defaultColor,
                          width: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Go Live",
                          style: GoogleFonts.inter(
                              color: defaultColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/info.svg",
                      color: subHeadingColor,
                      width: 15,
                    ),
                    SizedBox(
                      width: 18.5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 65,
                      child: Text(
                        "If recording has to be enabled later, streaming has to be stopped first.",
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: subHeadingColor,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
