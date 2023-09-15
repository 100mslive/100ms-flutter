/// 100ms HMSKeyChangeListener
///
/// 100ms SDK provides callback whenever a key in session metadata is changed
///
/// Implement this listener in the class wherever you wish to listen to changes to those keys
///
/// Remember to call HMSSessionStore's [addKeyChangeListener] method with corresponding keys to get the updates
abstract class HMSKeyChangeListener {
  ///This gets called whenever data corresponding to a key is changed
  ///
  ///This also gets called when key is set for the first time or set to null
  ///
  /// - Parameters:
  ///   - key: the key whose metadata is changed
  ///   - value: new value of the corresponding key
  void onKeyChanged({required String key, required String? value}) {}
}
