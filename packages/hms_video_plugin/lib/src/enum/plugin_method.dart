enum PluginMethod {
  enableVirtualBackground,
  disableVirtualBackground,
  changeVirtualBackground,
  isVirtualBackgroundSupported,
  enableBlurBackground,
  disableBlurBackground,
}

extension PlatformMethodValues on PluginMethod {
  static String getStringFromPlatformMethod(PluginMethod method) {
    switch (method) {
      case PluginMethod.enableVirtualBackground:
        return "enable_virtual_background";
      case PluginMethod.disableVirtualBackground:
        return "disable_virtual_background";
      case PluginMethod.changeVirtualBackground:
        return "change_virtual_background";
      case PluginMethod.enableBlurBackground:
        return "enable_blur_background";
      case PluginMethod.disableBlurBackground:
        return "disable_blur_background";
      case PluginMethod.isVirtualBackgroundSupported:
        return "is_virtual_background_supported";
    }
  }
}
