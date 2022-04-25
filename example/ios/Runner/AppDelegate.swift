import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?

    private let linkStreamHandler = LinkStreamHandler()

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        let channelController = window.rootViewController as! FlutterViewController

        methodChannel = FlutterMethodChannel(name: "deeplink.100ms.dev/channel", binaryMessenger: channelController as! FlutterBinaryMessenger)

        methodChannel?.setMethodCallHandler { call, result in
            guard call.method == "initialLink" else {
                result(FlutterMethodNotImplemented)
                return
            }
        }

        let eventController = window.rootViewController as! FlutterViewController
        eventChannel = FlutterEventChannel(name: "deeplink.100ms.dev/events", binaryMessenger: eventController as! FlutterBinaryMessenger)

        eventChannel?.setStreamHandler(linkStreamHandler)

        UIApplication.shared.isIdleTimerDisabled = true

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        eventChannel?.setStreamHandler(linkStreamHandler)
        return linkStreamHandler.handleLink(url.absoluteString)
    }

    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(#function, url.absoluteString)
            return linkStreamHandler.handleLink(url.absoluteString)
        }
        return true
    }
}

class LinkStreamHandler: NSObject, FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    // links will be added to this queue until the sink is ready to process them
    var queuedLinks = [String]()

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        queuedLinks.forEach({ events($0) })
        queuedLinks.removeAll()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func handleLink(_ link: String) -> Bool {
        guard let eventSink = eventSink else {
            queuedLinks.append(link)
            return false
        }
        eventSink(link)
        return true
    }
}
