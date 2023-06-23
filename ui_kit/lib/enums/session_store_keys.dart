//Enum to store the session metadata keys
// PINNED_MESSAGE_SESSION_KEY: for pinning messages
// SPOTLIGHT: for adding spotlight feature in application
enum SessionStoreKey { PINNED_MESSAGE_SESSION_KEY, SPOTLIGHT, unknown }

extension SessionStoreKeyValues on SessionStoreKey {
  static String getNameFromMethod(SessionStoreKey method) {
    switch (method) {
      case SessionStoreKey.PINNED_MESSAGE_SESSION_KEY:
        return "pinnedMessage";
      case SessionStoreKey.SPOTLIGHT:
        return "spotlight";
      default:
        return "";
    }
  }

  static SessionStoreKey getMethodFromName(String key) {
    switch (key) {
      case "pinnedMessage":
        return SessionStoreKey.PINNED_MESSAGE_SESSION_KEY;
      case "spotlight":
        return SessionStoreKey.SPOTLIGHT;
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
