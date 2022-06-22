import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class HLSPreviewScreen extends StatefulWidget {
  late String name;

  HLSPreviewScreen({
    required this.name});
  @override
  State<HLSPreviewScreen> createState() => _HLSPreviewScreenState();
}

class _HLSPreviewScreenState extends State<HLSPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Column(
            children: [
              Text("Let's get you started,${widget.name}!",style: GoogleFonts.inter(
                        color: defaultColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600)),
            ],
          ),],
        ),
      ),
    );
  }
}
