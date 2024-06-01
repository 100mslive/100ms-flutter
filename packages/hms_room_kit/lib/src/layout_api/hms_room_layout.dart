///Dart imports
library;

import 'dart:convert';

///Package imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/layout_api/hms_conferencing_items.dart';

class Theme {
  final String? name;
  final bool? defaultTheme;
  final Map<String, String>? palette;

  Theme({
    this.name,
    this.defaultTheme,
    this.palette,
  });

  factory Theme.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Theme();
    }
    return Theme(
      name: json['name'],
      defaultTheme: json['default'],
      palette: Map<String, String>.from(json['palette']),
    );
  }
}

class ScreenElements {
  final String? title;
  final String? subTitle;

  ScreenElements({
    this.title,
    this.subTitle,
  });

  factory ScreenElements.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ScreenElements();
    }
    return ScreenElements(
      title: json['title'],
      subTitle: json['sub_title'],
    );
  }
}

class Preview {
  final ScreenElements? previewHeader;
  final JoinForm? joinForm;
  final bool? skipPreviewScreen;

  Preview({this.previewHeader, this.joinForm, this.skipPreviewScreen = false});

  factory Preview.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Preview();
    }
    return Preview(
        previewHeader: ScreenElements.fromJson(
            json['default']?['elements']?['preview_header']),
        joinForm: JoinForm.fromJson(json['default']?['elements']?['join_form']),
        skipPreviewScreen: json["skip_preview_screen"]);
  }
}

enum JoinButtonType { JOIN_BTN_TYPE_JOIN_ONLY, JOIN_BTN_TYPE_JOIN_AND_GO_LIVE }

extension JoinButtonTypeValues on JoinButtonType {
  static JoinButtonType getButtonTypeFromName(String joinType) {
    switch (joinType) {
      case 'JOIN_BTN_TYPE_JOIN_ONLY':
        return JoinButtonType.JOIN_BTN_TYPE_JOIN_ONLY;
      case 'JOIN_BTN_TYPE_JOIN_AND_GO_LIVE':
        return JoinButtonType.JOIN_BTN_TYPE_JOIN_AND_GO_LIVE;
      default:
        return JoinButtonType.JOIN_BTN_TYPE_JOIN_ONLY;
    }
  }
}

class JoinForm {
  final JoinButtonType? joinBtnType;
  final String? joinBtnLabel;
  final String? goLiveBtnLabel;

  JoinForm({this.joinBtnLabel, this.joinBtnType, this.goLiveBtnLabel});

  factory JoinForm.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return JoinForm();
    } else {
      return JoinForm(
          joinBtnType:
              JoinButtonTypeValues.getButtonTypeFromName(json['join_btn_type']),
          joinBtnLabel: json['join_btn_label'],
          goLiveBtnLabel: json['go_live_btn_label']);
    }
  }
}

class Screens {
  final Preview? preview;
  final Conferencing? conferencing;
  final Map<String, dynamic>? leave;

  Screens({
    this.preview,
    this.conferencing,
    this.leave,
  });

  factory Screens.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Screens();
    }
    return Screens(
      preview: json.containsKey('preview') == true
          ? Preview.fromJson(json['preview'])
          : null,
      conferencing: json.containsKey('conferencing') == true
          ? Conferencing.fromJson(json['conferencing'])
          : null,
      leave: json['leave'],
    );
  }
}

class AppLogo {
  final String? url;

  AppLogo({this.url});

  factory AppLogo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AppLogo();
    } else {
      return AppLogo(url: json['url']);
    }
  }
}

class AppTypoGraphy {
  final String? typography;

  AppTypoGraphy({this.typography});

  factory AppTypoGraphy.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AppTypoGraphy();
    } else {
      return AppTypoGraphy(typography: json['font_family']);
    }
  }
}

class LayoutData {
  final String? id;
  final String? roleId;
  final String? role;
  final String? templateId;
  final String? appId;
  final List<Theme>? themes;
  final AppTypoGraphy? typography;
  final AppLogo? logo;
  final Screens? screens;

  LayoutData({
    this.id,
    this.roleId,
    this.role,
    this.templateId,
    this.appId,
    this.themes,
    this.typography,
    this.logo,
    this.screens,
  });

  factory LayoutData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LayoutData();
    }
    return LayoutData(
      id: json['id'],
      roleId: json['role_id'],
      role: json['role'],
      templateId: json['template_id'],
      appId: json['app_id'],
      themes: List<Theme>.from(
        (json['themes'] ?? []).map((theme) => Theme.fromJson(theme)),
      ),
      typography: AppTypoGraphy.fromJson(json['typography']),
      logo: AppLogo.fromJson(json['logo']),
      screens: Screens.fromJson(json['screens']),
    );
  }
}

enum PeerRoleType { hlsViewer, conferencing }

class HMSRoomLayout {
  static List<LayoutData>? data;
  static String? limit;
  static String? last;
  static LayoutData? roleLayoutData;
  static PeerRoleType? peerType;
  static Chat? chatData;
  static bool isParticipantsListEnabled = true;
  static bool isBRBEnabled = true;
  static bool isHandRaiseEnabled = true;
  static List<String>? offStageRoles = [];
  static bool skipPreviewForRole = false;
  static bool skipPreview = false;

  static Future<void> getRoomLayout(
      {required HMSSDKInteractor hmsSDKInteractor,
      required String authToken,
      required String? endPoint,
      String? roleName}) async {
    dynamic value = await hmsSDKInteractor.getRoomLayout(
        authToken: authToken, endPoint: endPoint);
    if (value != null && value.runtimeType != HMSException) {
      _setLayout(layoutJson: jsonDecode(value));
      resetLayout(roleName);
    }
  }

  static void resetLayout(String? roleName) {
    if (roleName != null) {
      int? roleIndex =
          data?.indexWhere((layoutData) => layoutData.role == roleName);

      ///Check if that role theme is present
      ///If not we assign the theme at 0th index
      if (roleIndex != null && roleIndex != -1) {
        HMSThemeColors.applyLayoutColors(data?[roleIndex].themes?[0].palette);
        roleLayoutData = data?[roleIndex];
      } else {
        HMSThemeColors.applyLayoutColors(data?[0].themes?[0].palette);
        roleLayoutData = data?[0];
      }
    } else {
      HMSThemeColors.applyLayoutColors(data?[0].themes?[0].palette);
      roleLayoutData = data?[0];
    }
    peerType = roleLayoutData?.screens?.conferencing?.hlsLiveStreaming != null
        ? PeerRoleType.hlsViewer
        : PeerRoleType.conferencing;
    skipPreview = roleLayoutData?.screens?.preview?.skipPreviewScreen ?? false;
    if (peerType == PeerRoleType.conferencing) {
      chatData =
          roleLayoutData?.screens?.conferencing?.defaultConf?.elements?.chat;
      isParticipantsListEnabled = roleLayoutData
              ?.screens?.conferencing?.defaultConf?.elements?.participantList !=
          null;
      isBRBEnabled =
          roleLayoutData?.screens?.conferencing?.defaultConf?.elements?.brb !=
              null;
      isHandRaiseEnabled = roleLayoutData
              ?.screens?.conferencing?.defaultConf?.elements?.handRaise !=
          null;
      offStageRoles = roleLayoutData?.screens?.conferencing?.defaultConf
          ?.elements?.onStageExp?.offStageRoles;
      skipPreviewForRole = roleLayoutData?.screens?.conferencing?.defaultConf
              ?.elements?.onStageExp?.skipPreviewForRoleChange ??
          false;
    } else {
      chatData = roleLayoutData
          ?.screens?.conferencing?.hlsLiveStreaming?.elements?.chat;
      isParticipantsListEnabled = roleLayoutData?.screens?.conferencing
              ?.hlsLiveStreaming?.elements?.participantList !=
          null;
      isBRBEnabled = roleLayoutData
              ?.screens?.conferencing?.hlsLiveStreaming?.elements?.brb !=
          null;
      isHandRaiseEnabled = roleLayoutData
              ?.screens?.conferencing?.hlsLiveStreaming?.elements?.handRaise !=
          null;
      offStageRoles = roleLayoutData?.screens?.conferencing?.hlsLiveStreaming
          ?.elements?.onStageExp?.offStageRoles;
      skipPreviewForRole = roleLayoutData
              ?.screens
              ?.conferencing
              ?.hlsLiveStreaming
              ?.elements
              ?.onStageExp
              ?.skipPreviewForRoleChange ??
          false;
    }
  }

  static void _setLayout({required Map<String, dynamic> layoutJson}) {
    data = List<LayoutData>.from((layoutJson['data'] ?? [])
        .map((appData) => LayoutData.fromJson(appData)));
    limit = layoutJson['limit'].toString();
    last = layoutJson['last'];
  }
}
