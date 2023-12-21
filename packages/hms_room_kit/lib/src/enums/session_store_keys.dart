//Enum to store the session metadata keys
// PINNED_MESSAGE_SESSION_KEY: for pinning messages
// SPOTLIGHT: for adding spotlight feature in application
enum SessionStoreKey {
  pinnedMessageSessionKey,
  spotlight,
  chatState,
  chatPeerBlacklist,
  chatMessageBlacklist,
  pinnedMessages,
  unknown
}

extension SessionStoreKeyValues on SessionStoreKey {
  static String getNameFromMethod(SessionStoreKey method) {
    switch (method) {
      case SessionStoreKey.pinnedMessageSessionKey:
        return "pinnedMessage";
      case SessionStoreKey.spotlight:
        return "spotlight";
      case SessionStoreKey.chatState:
        return "chatState";
      case SessionStoreKey.chatPeerBlacklist:
        return "chatPeerBlacklist";
      case SessionStoreKey.chatMessageBlacklist:
        return "chatMessageBlacklist";
      case SessionStoreKey.pinnedMessages:
        return "pinnedMessages";
      default:
        return "";
    }
  }

  static SessionStoreKey getMethodFromName(String key) {
    switch (key) {
      case "pinnedMessage":
        return SessionStoreKey.pinnedMessageSessionKey;
      case "spotlight":
        return SessionStoreKey.spotlight;
      case "chatState":
        return SessionStoreKey.chatState;
      case "chatPeerBlacklist":
        return SessionStoreKey.chatPeerBlacklist;
      case "chatMessageBlacklist":
        return SessionStoreKey.chatMessageBlacklist;
      case "pinnedMessages":
        return SessionStoreKey.pinnedMessages;
      default:
        return SessionStoreKey.unknown;
    }
  }

  static List<String> getSessionStoreKeys() {
    List<String> keys = [];
    for (var key in SessionStoreKey.values) {
      if (key != SessionStoreKey.unknown) {
        keys.add(getNameFromMethod(key));
      }
    }
    return keys;
  }
}
