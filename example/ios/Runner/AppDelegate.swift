import UIKit
import Flutter
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let audioSession = AVAudioSession.sharedInstance()
         do {
             try audioSession.setCategory(.playback)
             try audioSession.setActive(true, options: [])
         } catch {
             print("Setting category to AVAudioSessionCategoryPlayback failed.")
         }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
