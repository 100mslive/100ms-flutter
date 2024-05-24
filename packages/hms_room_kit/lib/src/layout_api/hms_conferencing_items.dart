class Conferencing {
  Default? defaultConf;
  HlsLiveStreaming? hlsLiveStreaming;

  Conferencing({this.defaultConf, this.hlsLiveStreaming});

  Conferencing.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      defaultConf = null;
      hlsLiveStreaming = null;
      return;
    }
    defaultConf =
        json.containsKey('default') ? Default.fromJson(json['default']) : null;
    hlsLiveStreaming = json.containsKey('hls_live_streaming')
        ? HlsLiveStreaming.fromJson(json['hls_live_streaming'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (defaultConf != null) {
      data['default'] = defaultConf!.toJson();
    }
    if (hlsLiveStreaming != null) {
      data['hls_live_streaming'] = hlsLiveStreaming!.toJson();
    }
    return data;
  }
}

class Default {
  Elements? elements;

  Default({this.elements});

  Default.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      elements = null;
      return;
    }
    elements = json.containsKey('elements')
        ? Elements.fromJson(json['elements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (elements != null) {
      data['elements'] = elements!.toJson();
    }
    return data;
  }
}

class HlsLiveStreaming {
  Elements? elements;

  HlsLiveStreaming({this.elements});

  HlsLiveStreaming.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      elements = null;
      return;
    }
    elements = json.containsKey('elements')
        ? Elements.fromJson(json['elements'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (elements != null) {
      data['elements'] = elements!.toJson();
    }
    return data;
  }
}

class Header {
  String? title;
  String? description;

  Header({this.title, this.description});

  Header.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      title = null;
      description = null;
      return;
    }
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class Elements {
  Header? header;
  Chat? chat;
  Map<String, dynamic>? participantList;
  VideoTileLayout? videoTileLayout;
  Map<String, dynamic>? emojiReactions;
  OnStageExp? onStageExp;
  Map<String, dynamic>? brb;
  Map<String, dynamic>? handRaise;

  Elements(
      {this.header,
      this.chat,
      this.participantList,
      this.videoTileLayout,
      this.emojiReactions,
      this.onStageExp,
      this.brb,
      this.handRaise});

  Elements.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      header = null;
      chat = null;
      participantList = null;
      videoTileLayout = null;
      emojiReactions = null;
      onStageExp = null;
      brb = null;
      handRaise = null;
      return;
    }

    header = (json.containsKey('header') && json['header'] != null)
        ? Header.fromJson(json['header'])
        : null;
    chat = (json.containsKey('chat') && json['chat'] != null)
        ? Chat.fromJson(json['chat'])
        : null;
    participantList = json['participant_list'];
    videoTileLayout = json.containsKey('video_tile_layout')
        ? VideoTileLayout.fromJson(json['video_tile_layout']['grid'])
        : null;
    emojiReactions = json['emoji_reactions'];
    onStageExp = json.containsKey('on_stage_exp')
        ? OnStageExp.fromJson(json['on_stage_exp'])
        : null;
    brb = json.containsKey("brb") ? json["brb"] : null;
    handRaise = json.containsKey("hand_raise") ? json["hand_raise"] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chat != null) {
      data['chat'] = chat!.toJson();
    }
    data['participant_list'] = participantList;
    if (videoTileLayout != null) {
      data['video_tile_layout'] = {'grid': videoTileLayout!.toJson()};
    }
    data['emoji_reactions'] = emojiReactions;
    if (onStageExp != null) {
      data['on_stage_exp'] = onStageExp!.toJson();
    }
    data['brb'] = brb;
    return data;
  }
}

class OnStageExp {
  String? bringToStageLabel;
  String? removeFromStageLabel;
  String? onStageRole;
  List<String>? offStageRoles;
  bool? skipPreviewForRoleChange;

  OnStageExp({
    this.bringToStageLabel,
    this.removeFromStageLabel,
    this.onStageRole,
    this.offStageRoles,
    this.skipPreviewForRoleChange,
  });

  OnStageExp.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      bringToStageLabel = null;
      removeFromStageLabel = null;
      onStageRole = null;
      offStageRoles = null;
      skipPreviewForRoleChange = null;
      return;
    }
    bringToStageLabel = json['bring_to_stage_label'];
    removeFromStageLabel = json['remove_from_stage_label'];
    onStageRole = json['on_stage_role'];
    offStageRoles =
        json.containsKey('off_stage_roles') && json['off_stage_roles'] is List
            ? List<String>.from(json['off_stage_roles'])
            : null;
    skipPreviewForRoleChange = json.containsKey('skip_preview_for_role_change')
        ? json['skip_preview_for_role_change']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bring_to_stage_label'] = bringToStageLabel;
    data['remove_from_stage_label'] = removeFromStageLabel;
    data['on_stage_role'] = onStageRole;
    if (offStageRoles != null && offStageRoles!.isNotEmpty) {
      data['off_stage_roles'] = offStageRoles;
    }
    data['skip_preview_for_role_change'] = skipPreviewForRoleChange;
    return data;
  }
}

class VideoTileLayout {
  bool? enableLocalTileInset;
  List<String>? prominentRoles;
  bool? enableSpotlightingPeer;

  VideoTileLayout({
    this.enableLocalTileInset,
    this.prominentRoles,
    this.enableSpotlightingPeer,
  });

  VideoTileLayout.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      enableLocalTileInset = null;
      prominentRoles = null;
      enableSpotlightingPeer = null;
      return;
    }
    enableLocalTileInset = json['enable_local_tile_inset'];
    prominentRoles =
        json.containsKey('prominent_roles') && json['prominent_roles'] is List
            ? List<String>.from(json['prominent_roles'])
            : null;
    enableSpotlightingPeer = json['enable_spotlighting_peer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable_local_tile_inset'] = enableLocalTileInset;
    if (prominentRoles != null && prominentRoles!.isNotEmpty) {
      data['prominent_roles'] = prominentRoles;
    }
    data['enable_spotlighting_peer'] = enableSpotlightingPeer;
    return data;
  }
}

class Chat {
  bool? isOpenInitially;
  bool? isOverlay;
  bool? allowPinningMessages;
  String? chatTitle;
  String? messagePlaceholder;
  bool? isPrivateChatEnabled;
  bool? isPublicChatEnabled;
  List<String> rolesWhitelist = [];
  RealTimeControls? realTimeControls;

  Chat(
      {this.isOpenInitially,
      this.isOverlay,
      this.allowPinningMessages,
      this.chatTitle,
      this.messagePlaceholder,
      this.isPrivateChatEnabled,
      this.isPublicChatEnabled,
      this.rolesWhitelist = const []});

  Chat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      isOpenInitially = null;
      isOverlay = null;
      allowPinningMessages = null;
      chatTitle = "Chat";
      messagePlaceholder = "Send a message...";
      isPrivateChatEnabled = false;
      isPublicChatEnabled = false;
      rolesWhitelist = [];
      realTimeControls = null;
      return;
    }
    isOpenInitially = json.containsKey('initial_state')
        ? json['initial_state'].contains("CHAT_STATE_OPEN")
            ? true
            : false
        : null;
    isOverlay = json.containsKey('is_overlay') ? json['is_overlay'] : null;
    allowPinningMessages = json.containsKey('allow_pinning_messages')
        ? json['allow_pinning_messages']
        : null;
    chatTitle = json.containsKey('chat_title') ? json['chat_title'] : "Chat";
    messagePlaceholder = json.containsKey('message_placeholder')
        ? json['message_placeholder']
        : "Send a message...";
    isPrivateChatEnabled = json.containsKey('private_chat_enabled')
        ? json['private_chat_enabled']
        : false;
    isPublicChatEnabled = json.containsKey('public_chat_enabled')
        ? json['public_chat_enabled']
        : false;
    rolesWhitelist =
        json.containsKey('roles_whitelist') && json['roles_whitelist'] is List
            ? List<String>.from(json['roles_whitelist'])
            : [];
    realTimeControls = json.containsKey('real_time_controls')
        ? RealTimeControls.fromJson(json['real_time_controls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (isOpenInitially != null) {
      data['initial_state'] = isOpenInitially;
    }
    if (isOverlay != null) {
      data['is_overlay'] = isOverlay;
    }
    if (allowPinningMessages != null) {
      data['allow_pinning_messages'] = allowPinningMessages;
    }
    if (chatTitle != null) {
      data['chat_title'] = chatTitle;
    }
    if (messagePlaceholder != null) {
      data['message_placeholder'] = messagePlaceholder;
    }
    if (isPrivateChatEnabled != null) {
      data['private_chat_enabled'] = isPrivateChatEnabled;
    }
    if (isPublicChatEnabled != null) {
      data['public_chat_enabled'] = isPublicChatEnabled;
    }
    if (rolesWhitelist.isNotEmpty) {
      data['roles_whitelist'] = rolesWhitelist;
    }
    if (realTimeControls != null) {
      data['real_time_controls'] = realTimeControls!.toJson();
    }
    return data;
  }
}

class RealTimeControls {
  bool? canBlockUser;
  bool? canDisableChat;
  bool? canHideMessage;

  RealTimeControls(
      {this.canBlockUser, this.canDisableChat, this.canHideMessage});

  RealTimeControls.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      canBlockUser = null;
      canDisableChat = null;
      canHideMessage = null;
      return;
    }
    canBlockUser =
        json.containsKey("can_block_user") ? json["can_block_user"] : false;
    canDisableChat =
        json.containsKey("can_disable_chat") ? json["can_disable_chat"] : false;
    canHideMessage =
        json.containsKey("can_hide_message") ? json["can_hide_message"] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (canBlockUser != null) {
      data["can_block_user"] = canBlockUser;
    }
    if (canDisableChat != null) {
      data["can_disable_chat"] = canDisableChat;
    }
    if (canHideMessage != null) {
      data["can_hide_message"] = canHideMessage;
    }
    return data;
  }
}
