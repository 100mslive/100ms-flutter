import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class AppSettingsBottomSheet extends StatefulWidget {
  final String appVersion;

  const AppSettingsBottomSheet({required this.appVersion});
  @override
  State<AppSettingsBottomSheet> createState() => _AppSettingsBottomSheetState();
}

class _AppSettingsBottomSheetState extends State<AppSettingsBottomSheet> {
  bool skipPreview = false;
  bool mirrorCamera = true;
  bool showStats = false;
  bool isSoftwareDecoderDisabled = true;
  bool isAudioMixerDisabled = true;
  bool isAutoSimulcast = true;
  bool isDebugMode = false;
  HMSAudioMode currentAudioMode = HMSAudioMode.VOICE;
  bool isStreamingFlow = true;
  bool nameChangeOnPreview = true;
  bool isVirtualBackgroundEnabled = false;

  var versions = {};

  @override
  void initState() {
    super.initState();
    _getAppSettings();
  }

  Future<void> _getAppSettings() async {
    final String sdkVersions = await rootBundle
        .loadString('packages/hmssdk_flutter/assets/sdk-versions.json');
    versions = json.decode(sdkVersions);
    if (versions['flutter'] == null) {
      throw const FormatException("flutter version not found");
    }
    if (Platform.isIOS && versions['ios'] == null) {
      throw const FormatException("ios version not found");
    }
    if (Platform.isAndroid && versions['android'] == null) {
      throw const FormatException("android version not found");
    }
    skipPreview = await Utilities.getBoolData(key: 'skip-preview') ?? false;
    mirrorCamera = await Utilities.getBoolData(key: 'mirror-camera') ?? true;
    showStats = await Utilities.getBoolData(key: 'show-stats') ?? false;
    isSoftwareDecoderDisabled =
        await Utilities.getBoolData(key: 'software-decoder-disabled') ?? true;
    isAudioMixerDisabled =
        await Utilities.getBoolData(key: 'audio-mixer-disabled') ?? true;
    isAutoSimulcast =
        await Utilities.getBoolData(key: 'is-auto-simulcast') ?? true;
    int audioModeIndex = await Utilities.getIntData(key: 'audio-mode');
    currentAudioMode = HMSAudioMode.values[audioModeIndex];

    isDebugMode =
        await Utilities.getBoolData(key: 'enable-debug-mode') ?? false;

    isStreamingFlow =
        await Utilities.getBoolData(key: 'is_streaming_flow') ?? true;

    nameChangeOnPreview =
        await Utilities.getBoolData(key: 'name-change-on-preview') ?? true;

    isVirtualBackgroundEnabled =
        await Utilities.getBoolData(key: 'is_virtual_background_enabled') ??
            false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    _setDebugData();
  }

  void _setDebugData() {
    AppDebugConfig.isAudioMixerDisabled = isAudioMixerDisabled;
    AppDebugConfig.isAutoSimulcast = isAutoSimulcast;
    AppDebugConfig.isSoftwareDecoderDisabled = isSoftwareDecoderDisabled;
    AppDebugConfig.mirrorCamera = mirrorCamera;
    AppDebugConfig.showStats = showStats;
    AppDebugConfig.skipPreview = skipPreview;
    AppDebugConfig.isDebugMode = isDebugMode;
    AppDebugConfig.nameChangeOnPreview = true;
    AppDebugConfig.isVirtualBackgroundEnabled = isVirtualBackgroundEnabled;
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://discord.gg/YtUqvA6j');
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  void setAudioMode(HMSAudioMode newMode) {
    currentAudioMode = newMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "App Settings",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/close_button.svg",
                        width: 40,
                        // color: defaultColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: dividerColor,
                height: 5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // ListTile(
                  //   enabled: false,
                  //   horizontalTitleGap: 2,
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: SvgPicture.asset(
                  //     isDarkMode
                  //         ? "packages/hms_room_kit/lib/src/assets/icons/dark_mode.svg"
                  //         : 'packages/hms_room_kit/lib/src/assets/icons/light_mode.svg',
                  //     fit: BoxFit.scaleDown,
                  //     colorFilter:  ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                  //   ),
                  //   title: Text(
                  //     "Dark Mode",
                  //     semanticsLabel: "fl_dark_light_mode",
                  //     style: HMSTextStyle.setTextStyle(
                  //         fontSize: 14,
                  //         color: themeDefaultColor,
                  //         letterSpacing: 0.25,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  //   trailing: CupertinoSwitch(
                  //       value: isDarkMode,
                  //       activeColor: hmsdefaultColor,
                  //       onChanged: ((value) => {
                  //             Utilities.saveBoolData(
                  //                 key: 'dark-mode', value: value),
                  //             isDarkMode = !isDarkMode,
                  //             if (!isDarkMode)
                  //               HMSExampleApp.of(context)
                  //                   .changeTheme(ThemeMode.light)
                  //             else
                  //               HMSExampleApp.of(context)
                  //                   .changeTheme(ThemeMode.dark),
                  //             setState(() {})
                  //           })),
                  // ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/bug.svg",
                      fit: BoxFit.scaleDown,
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Enable Debug Mode",
                      semanticsLabel: "fl_enable_debug_mode",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: isDebugMode,
                        onChanged: (value) => {
                              isDebugMode = value,
                              Utilities.saveBoolData(
                                  key: 'enable-debug-mode', value: value),
                              AppDebugConfig.isDebugMode = value,
                              setState(() {})
                            }),
                  ),
                  // ListTile(
                  //   horizontalTitleGap: 2,
                  //   enabled: false,
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: SvgPicture.asset(
                  //     "packages/hms_room_kit/lib/src/assets/icons/preview_state_on.svg",
                  //     fit: BoxFit.scaleDown,
                  //     colorFilter:  ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                  //   ),
                  //   title: Text(
                  //     "Skip Preview",
                  //     semanticsLabel: "fl_preview_enable",
                  //     style: HMSTextStyle.setTextStyle(
                  //         fontSize: 14,
                  //         color: themeDefaultColor,
                  //         letterSpacing: 0.25,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  //   trailing: CupertinoSwitch(
                  //       activeColor: hmsdefaultColor,
                  //       value: skipPreview,
                  //       onChanged: (value) => {
                  //             skipPreview = value,
                  //             Utilities.saveBoolData(
                  //                 key: 'skip-preview', value: value),
                  //             setState(() {})
                  //           }),
                  // ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.cameraswitch_outlined,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Mirror Camera",
                      semanticsLabel: "fl_mirror_camera_enable",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: mirrorCamera,
                        onChanged: (value) => {
                              mirrorCamera = value,
                              Utilities.saveBoolData(
                                  key: 'mirror-camera', value: value),
                              AppDebugConfig.mirrorCamera = value,
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                      fit: BoxFit.scaleDown,
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Name Change On Preview",
                      semanticsLabel: "fl_disable_name_change_on_preview",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: nameChangeOnPreview,
                        onChanged: (value) => {
                              nameChangeOnPreview = value,
                              Utilities.saveBoolData(
                                  key: 'name-change-on-preview', value: value),
                              AppDebugConfig.nameChangeOnPreview = value,
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/stats.svg',
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Enable Stats",
                      semanticsLabel: "fl_stats_enable",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: showStats,
                        onChanged: (value) => {
                              showStats = value,
                              Utilities.saveBoolData(
                                  key: 'show-stats', value: value),
                              AppDebugConfig.showStats = value,
                              setState(() {})
                            }),
                  ),
                  if (Platform.isAndroid)
                    ListTile(
                      horizontalTitleGap: 2,
                      enabled: false,
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/decoder.svg',
                        colorFilter: ColorFilter.mode(
                            themeDefaultColor, BlendMode.srcIn),
                      ),
                      title: Text(
                        "Software Decoder",
                        semanticsLabel: "fl_software_decoder_enable",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: CupertinoSwitch(
                          activeColor: hmsdefaultColor,
                          value: isSoftwareDecoderDisabled,
                          onChanged: (value) => {
                                isSoftwareDecoderDisabled = value,
                                Utilities.saveBoolData(
                                    key: 'software-decoder-disabled',
                                    value: value),
                                AppDebugConfig.isSoftwareDecoderDisabled =
                                    value,
                                setState(() {})
                              }),
                    ),
                  if (Platform.isIOS)
                    ListTile(
                      horizontalTitleGap: 2,
                      enabled: true,
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/settings.svg',
                        colorFilter: ColorFilter.mode(
                            themeDefaultColor, BlendMode.srcIn),
                      ),
                      title: Text(
                        "Disable Audio Mixer",
                        semanticsLabel: "fl_track_settings",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: CupertinoSwitch(
                          activeColor: hmsdefaultColor,
                          value: isAudioMixerDisabled,
                          onChanged: (value) => {
                                isAudioMixerDisabled = value,
                                Utilities.saveBoolData(
                                    key: 'audio-mixer-disabled', value: value),
                                AppDebugConfig.isAudioMixerDisabled = value,
                                setState(() {})
                              }),
                    ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/simulcast.svg',
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Enable Auto Simulcast",
                      semanticsLabel: "fl_auto_simulcast",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: isAutoSimulcast,
                        onChanged: (value) => {
                              isAutoSimulcast = value,
                              Utilities.saveBoolData(
                                  key: 'is-auto-simulcast', value: value),
                              AppDebugConfig.isAutoSimulcast = value,
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/local_capture.svg',
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Enable Virtual Background",
                      semanticsLabel: "fl_virtual_background",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: isVirtualBackgroundEnabled,
                        onChanged: (value) => {
                              isVirtualBackgroundEnabled = value,
                              Utilities.saveBoolData(
                                  key: 'is_virtual_background_enabled',
                                  value: value),
                              AppDebugConfig.isVirtualBackgroundEnabled = value,
                              setState(() {})
                            }),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AudioModeSelectDialog(
                              currentAudioMode: currentAudioMode,
                              changeAudioMode: (newMode) {
                                setAudioMode(newMode);
                                Utilities.saveIntData(
                                    key: "audio-mode", value: newMode.index);
                              }));
                    },
                    child: ListTile(
                      horizontalTitleGap: 2,
                      enabled: false,
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/audio_mode.svg",
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                            themeDefaultColor, BlendMode.srcIn),
                      ),
                      title: Text(
                        "Audio Mode",
                        semanticsLabel: "fl_audio_mode",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(currentAudioMode.name),
                    ),
                  ),

                  ///Since we are not supporting toasts commenting this out for now
                  ///
                  // ListTile(
                  //     horizontalTitleGap: 2,
                  //     onTap: () async {
                  //       Navigator.pop(context);
                  //       showModalBottomSheet(
                  //           isScrollControlled: true,
                  //           backgroundColor: themeBottomSheetColor,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           context: context,
                  //           builder: (ctx) =>
                  //               const NotificationSettingsBottomSheet());
                  //     },
                  //     contentPadding: EdgeInsets.zero,
                  //     leading: SvgPicture.asset(
                  //       "packages/hms_room_kit/lib/src/assets/icons/notification.svg",
                  //       fit: BoxFit.scaleDown,
                  //       colorFilter: ColorFilter.mode(
                  //           themeDefaultColor, BlendMode.srcIn),
                  //     ),
                  //     title: Text(
                  //       "Modify Notifications",
                  //       semanticsLabel: "fl_notification_setting",
                  //       style: HMSTextStyle.setTextStyle(
                  //           fontSize: 14,
                  //           color: themeDefaultColor,
                  //           letterSpacing: 0.25,
                  //           fontWeight: FontWeight.w600),
                  //     )),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: true,
                    onTap: _launchUrl,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/bug.svg',
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                    ),
                    title: Text(
                      "Ask on Discord",
                      semanticsLabel: "fl_ask_feedback",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: ListTile(
                      horizontalTitleGap: 2,
                      enabled: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        "App Version",
                        semanticsLabel: "app_version",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 12,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        widget.appVersion,
                        semanticsLabel: "app_version",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 12,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: ListTile(
                      horizontalTitleGap: 2,
                      enabled: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        "HMSSDK Version",
                        semanticsLabel: "hmssdk_version",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 12,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Text(
                        versions["flutter"] ?? "",
                        semanticsLabel: "hmssdk_version",
                        style: HMSTextStyle.setTextStyle(
                            fontSize: 12,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),

                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      Platform.isAndroid
                          ? "Android SDK Version"
                          : "iOS SDK Version",
                      semanticsLabel: Platform.isAndroid
                          ? "android_sdk_version"
                          : "iOS_sdk_version",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 12,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      Platform.isAndroid
                          ? versions["android"] ?? ""
                          : versions["ios"] ?? "",
                      semanticsLabel: Platform.isAndroid
                          ? "android_sdk_version"
                          : "iOS_sdk_version",
                      style: HMSTextStyle.setTextStyle(
                          fontSize: 12,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
              child: Center(
                  child: HMSTitleText(
                      text: "Made with ❤️ by 100ms",
                      textColor: themeDefaultColor)),
            )
          ],
        ),
      ),
    );
  }
}
