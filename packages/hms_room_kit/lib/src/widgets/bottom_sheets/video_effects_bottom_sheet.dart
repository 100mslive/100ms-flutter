// library;

// ///Package imports
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hms_room_kit/src/meeting/meeting_store.dart';
// import 'package:hms_video_plugin/hms_video_plugin.dart';
// import 'package:hmssdk_flutter/hmssdk_flutter.dart';
// import 'package:image_picker/image_picker.dart';

// ///Project imports
// import 'package:hms_room_kit/hms_room_kit.dart';
// import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
// import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
// import 'package:hms_room_kit/src/widgets/common_widgets/more_option_item.dart';
// import 'package:provider/provider.dart';

// ///[VideoEffectsBottomSheet] is a bottom sheet that is used to change the video effects
// class VideoEffectsBottomSheet extends StatefulWidget {
//   final HMSVideoTrack? localVideoTrack;

//   const VideoEffectsBottomSheet({super.key, this.localVideoTrack});
//   @override
//   State<VideoEffectsBottomSheet> createState() =>
//       _VideoEffectsBottomSheetState();
// }

// class _VideoEffectsBottomSheetState extends State<VideoEffectsBottomSheet> {
//   int blurValue = 0;
//   String selectedEffect = "";

//   @override
//   void initState() {
//     super.initState();
//     if (AppDebugConfig.isBlurEnabled) {
//       setEffect("blur");
//     } else if (AppDebugConfig.isVBEnabled) {
//       setEffect("background");
//     }
//     context.read<MeetingStore>().addBottomSheet(context);
//   }

//   @override
//   void deactivate() {
//     context.read<MeetingStore>().removeBottomSheet(context);
//     super.deactivate();
//   }

//   void changeBlur(int blurRadius) {
//     setState(() {
//       blurValue = blurRadius;
//     });
//     HMSVideoPlugin.enableBlur(blurRadius: blurValue);
//     AppDebugConfig.isBlurEnabled = true;
//   }

//   void setEffect(String effect) {
//     setState(() {
//       selectedEffect = effect;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 24,
//                         color: HMSThemeColors.onSurfaceHighEmphasis,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     HMSTitleText(
//                       text: "Virtual Background",
//                       textColor: HMSThemeColors.onSurfaceHighEmphasis,
//                       letterSpacing: 0.15,
//                     )
//                   ],
//                 ),
//                 Row(
//                   children: [HMSCrossButton()],
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 16, bottom: 16),
//               child: Divider(
//                 color: HMSThemeColors.borderDefault,
//                 height: 5,
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             HMSSubheadingText(
//               text: "Effects",
//               textColor: HMSThemeColors.onSurfaceHighEmphasis,
//               fontWeight: FontWeight.w600,
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: MoreOptionItem(
//                       onTap: () {
//                         Navigator.pop(context);
//                         if (AppDebugConfig.isBlurEnabled) {
//                           HMSVideoPlugin.disableBlur();
//                           AppDebugConfig.isBlurEnabled = false;
//                         } else if (AppDebugConfig.isVBEnabled) {
//                           HMSVideoPlugin.disable();
//                           AppDebugConfig.isVBEnabled = false;
//                         }
//                         setEffect("");
//                       },
//                       optionIcon: SvgPicture.asset(
//                         "packages/hms_room_kit/lib/src/assets/icons/remove_effects.svg",
//                         height: 20,
//                         width: 20,
//                         colorFilter: ColorFilter.mode(
//                             HMSThemeColors.onSurfaceHighEmphasis,
//                             BlendMode.srcIn),
//                       ),
//                       optionText: "No Effect",
//                       isActive: true),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: MoreOptionItem(
//                       onTap: () {
//                         Navigator.pop(context);
//                         AppDebugConfig.isVBEnabled = false;
//                         changeBlur(100);
//                       },
//                       optionIcon: SvgPicture.asset(
//                         "packages/hms_room_kit/lib/src/assets/icons/max_blur.svg",
//                         height: 20,
//                         width: 20,
//                         colorFilter: ColorFilter.mode(
//                             HMSThemeColors.onSurfaceHighEmphasis,
//                             BlendMode.srcIn),
//                       ),
//                       optionText: " Blur",
//                       isActive: true),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: MoreOptionItem(
//                       onTap: () async {
//                         AppDebugConfig.isBlurEnabled = false;
//                         Navigator.pop(context);
//                         setEffect("background");
//                         XFile? result = await ImagePicker()
//                             .pickImage(source: ImageSource.gallery);
//                         if (result != null) {
//                           final bytes = await result.readAsBytes();
//                           if (AppDebugConfig.isVBEnabled) {
//                             HMSVideoPlugin.changeVirtualBackground(
//                                 image: bytes);
//                           } else {
//                             HMSVideoPlugin.enable(image: bytes);
//                             AppDebugConfig.isVBEnabled =
//                                 !AppDebugConfig.isVBEnabled;
//                           }
//                         }
//                       },
//                       optionIcon: SvgPicture.asset(
//                         "packages/hms_room_kit/lib/src/assets/icons/video_effects.svg",
//                         height: 20,
//                         width: 20,
//                         colorFilter: ColorFilter.mode(
//                             HMSThemeColors.onSurfaceHighEmphasis,
//                             BlendMode.srcIn),
//                       ),
//                       optionText: "Backgrounds",
//                       isActive: true),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             // if (selectedEffect == "blur")
//             //   Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       SvgPicture.asset(
//             //         "packages/hms_room_kit/lib/src/assets/icons/min_blur.svg",
//             //         height: 18,
//             //         width: 18,
//             //         colorFilter: ColorFilter.mode(
//             //             HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
//             //       ),
//             //       Expanded(
//             //           child: SliderTheme(
//             //         data: SliderThemeData(
//             //             trackHeight: 2,
//             //             trackShape: RoundedRectSliderTrackShape(),
//             //             inactiveTrackColor: HMSThemeColors.secondaryDefault,
//             //             activeTrackColor: HMSThemeColors.primaryDefault,
//             //             thumbColor: HMSThemeColors.primaryDefault,
//             //             thumbShape:
//             //                 RoundSliderThumbShape(enabledThumbRadius: 6),
//             //             overlayShape:
//             //                 RoundSliderOverlayShape(overlayRadius: 0)),
//             //         child: Slider(
//             //           value: blurValue.toDouble(),
//             //           onChanged: (value) {},
//             //           onChangeEnd: (value) {
//             //             changeBlur(value.toInt());
//             //           },
//             //           min: 0,
//             //           max: 100,
//             //         ),
//             //       )),
//             //       SvgPicture.asset(
//             //         "packages/hms_room_kit/lib/src/assets/icons/max_blur.svg",
//             //         height: 18,
//             //         width: 18,
//             //         colorFilter: ColorFilter.mode(
//             //             HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
//             //       )
//             //     ],
//             //   ),
//             // const SizedBox(
//             //   height: 16,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
