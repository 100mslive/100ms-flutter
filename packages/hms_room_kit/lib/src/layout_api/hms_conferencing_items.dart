class Conferencing {
  Default? defaultConf;
  HlsLiveStreaming? hlsLiveStreaming;

  Conferencing({this.defaultConf, this.hlsLiveStreaming});

  Conferencing.fromJson(Map<String, dynamic> json) {
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

  Default.fromJson(Map<String, dynamic> json) {
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

  HlsLiveStreaming.fromJson(Map<String, dynamic> json) {
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

class Elements {
  Chat? chat;
  Map<String, dynamic>? participantList;
  VideoTileLayout? videoTileLayout;
  Map<String, dynamic>? emojiReactions;
  OnStageExp? onStageExp;

  Elements({
    this.chat,
    this.participantList,
    this.videoTileLayout,
    this.emojiReactions,
    this.onStageExp,
  });

  Elements.fromJson(Map<String, dynamic> json) {
    chat = json.containsKey('chat') ? Chat.fromJson(json['chat']) : null;
    participantList = json['participant_list'];
    videoTileLayout = json.containsKey('video_tile_layout')
        ? VideoTileLayout.fromJson(json['video_tile_layout']['grid'])
        : null;
    emojiReactions = json['emoji_reactions'];
    onStageExp = json.containsKey('on_stage_exp')
        ? OnStageExp.fromJson(json['on_stage_exp'])
        : null;
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
    return data;
  }
}

class OnStageExp {
  String? bringToStageLabel;
  String? removeFromStageLabel;
  String? onStageRole;
  List<String>? offStageRoles;

  OnStageExp({
    this.bringToStageLabel,
    this.removeFromStageLabel,
    this.onStageRole,
    this.offStageRoles,
  });

  OnStageExp.fromJson(Map<String, dynamic> json) {
    bringToStageLabel = json['bring_to_stage_label'];
    removeFromStageLabel = json['remove_from_stage_label'];
    onStageRole = json['on_stage_role'];
    offStageRoles =
        json.containsKey('off_stage_roles') && json['off_stage_roles'] is List
            ? List<String>.from(json['off_stage_roles'])
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

  VideoTileLayout.fromJson(Map<String, dynamic> json) {
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
  String? initialState;
  bool? isOverlay;
  bool? allowPinningMessages;

  Chat({this.initialState, this.isOverlay, this.allowPinningMessages});

  Chat.fromJson(Map<String, dynamic> json) {
    initialState =
        json.containsKey('initial_state') ? json['initial_state'] : null;
    isOverlay = json.containsKey('is_overlay') ? json['is_overlay'] : null;
    allowPinningMessages = json.containsKey('allow_pinning_messages')
        ? json['allow_pinning_messages']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (initialState != null) {
      data['initial_state'] = initialState;
    }
    if (isOverlay != null) {
      data['is_overlay'] = isOverlay;
    }
    if (allowPinningMessages != null) {
      data['allow_pinning_messages'] = allowPinningMessages;
    }
    return data;
  }
}
