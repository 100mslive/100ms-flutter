///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

///[LoadingScreen] class is used to show the loading screen
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: HMSThemeColors.primaryDefault,
        strokeWidth: 2,
      ),
    );
  }
}
