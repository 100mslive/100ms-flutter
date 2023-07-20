import 'package:flutter/material.dart';
import 'package:hms_room_kit/common/app_color.dart';

class HMSBackButton extends StatelessWidget {
  final Function() onPressed;

  const HMSBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: surfaceDefault,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 16,
          color: onSurfaceHighEmphasis,
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
