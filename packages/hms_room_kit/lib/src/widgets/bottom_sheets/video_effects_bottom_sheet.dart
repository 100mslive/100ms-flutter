library;

///Package imports
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_video_plugin/hms_video_plugin.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/more_option_item.dart';
import 'package:provider/provider.dart';

///[VideoEffectsBottomSheet] is a bottom sheet that is used to change the video effects
class VideoEffectsBottomSheet extends StatefulWidget {
  final HMSVideoTrack? localVideoTrack;

  const VideoEffectsBottomSheet({super.key, this.localVideoTrack});
  @override
  State<VideoEffectsBottomSheet> createState() =>
      _VideoEffectsBottomSheetState();
}

class _VideoEffectsBottomSheetState extends State<VideoEffectsBottomSheet> {
  int blurValue = 0;
  String selectedEffect = "";

  @override
  void initState() {
    super.initState();
    if (AppDebugConfig.isBlurEnabled) {
      setEffect("blur");
    } else if (AppDebugConfig.isVBEnabled) {
      setEffect("background");
    }
    // Only track bottom sheet if we're in Meeting context (not Preview)
    try {
      context.read<MeetingStore>().addBottomSheet(context);
    } catch (e) {
      // Preview context - MeetingStore not available, skip tracking
    }
  }

  @override
  void deactivate() {
    // Only remove tracking if we're in Meeting context (not Preview)
    try {
      context.read<MeetingStore>().removeBottomSheet(context);
    } catch (e) {
      // Preview context - MeetingStore not available, skip tracking
    }
    super.deactivate();
  }

  Future<void> changeBlur(int blurRadius) async {
    // Check if virtual background is supported
    bool isSupported = await HMSVideoPlugin.isSupported();

    if (!isSupported) {
      Utilities.showToast("Virtual background is not supported on this device");
      return;
    }

    setState(() {
      blurValue = blurRadius;
    });

    // Disable virtual background if it's active before enabling blur
    if (AppDebugConfig.isVBEnabled) {
      HMSException? disableResult = await HMSVideoPlugin.disable();
      if (disableResult != null) {
        Utilities.showToast("Error disabling VB: ${disableResult.message}");
      }
      AppDebugConfig.isVBEnabled = false;
    }

    HMSException? result = await HMSVideoPlugin.enableBlur(blurRadius: blurValue);

    if (result == null) {
      AppDebugConfig.isBlurEnabled = true;
      setEffect("blur");
      Utilities.showToast("Blur applied successfully");
    } else {
      Utilities.showToast("Failed to enable blur: ${result.message ?? result.description}");
      AppDebugConfig.isBlurEnabled = false;
    }
  }

  void setEffect(String effect) {
    setState(() {
      selectedEffect = effect;
    });
  }

  // Method to load image from URL
  Future<Uint8List?> loadImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      Utilities.showToast("Failed to load image from URL");
    }
    return null;
  }

  // Method to apply background from URL
  Future<void> applyBackgroundFromUrl(String url) async {
    Uint8List? imageBytes = await loadImageFromUrl(url);
    if (imageBytes != null) {
      if (AppDebugConfig.isVBEnabled) {
        await HMSVideoPlugin.changeVirtualBackground(image: imageBytes);
      } else {
        HMSException? error = await HMSVideoPlugin.enable(image: imageBytes);
        if (error == null) {
          AppDebugConfig.isVBEnabled = true;
          setEffect("background");
        } else {
          Utilities.showToast("Failed to enable virtual background: ${error.message}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: HMSThemeColors.onSurfaceHighEmphasis,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    HMSTitleText(
                      text: "Virtual Background",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                    )
                  ],
                ),
                Row(
                  children: [HMSCrossButton()],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(
                color: HMSThemeColors.borderDefault,
                height: 5,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            HMSSubheadingText(
              text: "Effects",
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MoreOptionItem(
                      onTap: () async {
                        Navigator.pop(context);
                        if (AppDebugConfig.isBlurEnabled) {
                          HMSException? result = await HMSVideoPlugin.disableBlur();
                          if (result == null) {
                            AppDebugConfig.isBlurEnabled = false;
                          } else {
                            Utilities.showToast("Failed to disable blur: ${result.message}");
                          }
                        } else if (AppDebugConfig.isVBEnabled) {
                          HMSException? result = await HMSVideoPlugin.disable();
                          if (result == null) {
                            AppDebugConfig.isVBEnabled = false;
                          } else {
                            Utilities.showToast("Failed to disable virtual background: ${result.message}");
                          }
                        }
                        setEffect("");
                      },
                      optionIcon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/remove_effects.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                      optionText: "No Effect",
                      isActive: true),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: MoreOptionItem(
                      onTap: () async {
                        AppDebugConfig.isVBEnabled = false;
                        await changeBlur(100);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      optionIcon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/max_blur.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                      optionText: " Blur",
                      isActive: true),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: MoreOptionItem(
                      onTap: () async {
                        AppDebugConfig.isBlurEnabled = false;
                        Navigator.pop(context);
                        setEffect("background");
                        XFile? result = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (result != null) {
                          final bytes = await result.readAsBytes();
                          if (AppDebugConfig.isVBEnabled) {
                            await HMSVideoPlugin.changeVirtualBackground(
                                image: bytes);
                          } else {
                            HMSException? error = await HMSVideoPlugin.enable(image: bytes);
                            if (error == null) {
                              AppDebugConfig.isVBEnabled = true;
                            } else {
                              Utilities.showToast("Failed to enable virtual background: ${error.message}");
                            }
                          }
                        }
                      },
                      optionIcon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/video_effects.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                      optionText: "Backgrounds",
                      isActive: true),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),

            // Display default backgrounds from room configuration
            if (HMSRoomLayout.virtualBackgroundConfig != null &&
                HMSRoomLayout.virtualBackgroundConfig!.getImageBackgrounds().isNotEmpty) ...[
              HMSSubheadingText(
                text: "Default Backgrounds",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: HMSRoomLayout.virtualBackgroundConfig!
                      .getImageBackgrounds()
                      .length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final backgroundMedia = HMSRoomLayout.virtualBackgroundConfig!
                        .getImageBackgrounds()[index];
                    return GestureDetector(
                      onTap: () async {
                        if (backgroundMedia.url != null) {
                          AppDebugConfig.isBlurEnabled = false;
                          await applyBackgroundFromUrl(backgroundMedia.url!);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: HMSThemeColors.borderDefault,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            backgroundMedia.url!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: HMSThemeColors.primaryDefault,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image,
                                color: HMSThemeColors.onSurfaceLowEmphasis,
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (selectedEffect == "blur")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/min_blur.svg",
                    height: 18,
                    width: 18,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  ),
                  Expanded(
                      child: SliderTheme(
                    data: SliderThemeData(
                        trackHeight: 2,
                        trackShape: RoundedRectSliderTrackShape(),
                        inactiveTrackColor: HMSThemeColors.secondaryDefault,
                        activeTrackColor: HMSThemeColors.primaryDefault,
                        thumbColor: HMSThemeColors.primaryDefault,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 0)),
                    child: Slider(
                      value: blurValue.toDouble(),
                      onChanged: (value) {},
                      onChangeEnd: (value) {
                        changeBlur(value.toInt());
                      },
                      min: 0,
                      max: 100,
                    ),
                  )),
                  SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/max_blur.svg",
                    height: 18,
                    width: 18,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  )
                ],
              ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
