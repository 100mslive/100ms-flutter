enum HMSKeyChangeListenerMethod { onKeyChanged, unknown }

extension HMSKeyChangeListenerMethodValues on HMSKeyChangeListenerMethod {
  static HMSKeyChangeListenerMethod getMethodFromName(String name) {
    switch (name) {
      case "on_key_changed":
        return HMSKeyChangeListenerMethod.onKeyChanged;
      default:
        return HMSKeyChangeListenerMethod.unknown;
    }
  }
}
