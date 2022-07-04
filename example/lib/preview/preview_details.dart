import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hms_listenable_button.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/preview/preview_page.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewDetails extends StatefulWidget {
  final String meetingLink;
  final MeetingFlow meetingFlow;
  PreviewDetails({required this.meetingLink, required this.meetingFlow});
  @override
  State<PreviewDetails> createState() => _PreviewDetailsState();
}

class _PreviewDetailsState extends State<PreviewDetails> {
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
  }

  void showPreview(bool res) async {
    if (nameController.text.isEmpty) {
      Utilities.showToast("Please enter you name");
    } else {
      Utilities.saveStringData(key: "name", value: nameController.text.trim());
      res = await Utilities.getPermissions();
      if (res) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ListenableProvider.value(
                  value: PreviewStore(),
                  child: PreviewPage(
                      meetingFlow: widget.meetingFlow,
                      name: nameController.text,
                      meetingLink: widget.meetingLink),
                )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    color: defaultColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 4,
            ),
            Text("Let's get started with your name",
                style: GoogleFonts.inter(
                    color: subHeadingColor,
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
                  showPreview(res);
                },
                autofocus: true,
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
                    fillColor: surfaceColor,
                    filled: true,
                    hintText: 'Enter your name here',
                    hintStyle: GoogleFonts.inter(
                        color: hintColor,
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
                      FocusManager.instance.primaryFocus?.unfocus(),
                      showPreview(res),
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
                                  ? disabledTextColor
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
                            ? disabledTextColor
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
