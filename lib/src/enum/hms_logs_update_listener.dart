enum HMSLogsUpdateListenerMethod { onLogsUpdate, unknown }

extension HMSLogsUpdateListenerMethodValues on HMSLogsUpdateListenerMethod {
  static HMSLogsUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_logs_update':
        return HMSLogsUpdateListenerMethod.onLogsUpdate;
      default:
        return HMSLogsUpdateListenerMethod.unknown;
    }
  }
}
