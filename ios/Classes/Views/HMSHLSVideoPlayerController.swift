//
//  VideoView.swift
//  hmssdk_flutter
//
//  Created by Govind on 16/12/22.
//
import UIKit
import AVFoundation
import Foundation
import Flutter

public class NativeVideoViewController: NSObject, FlutterPlatformView {
    private var viewId: Int64
    private var methodChannel: FlutterMethodChannel
    private var videoView: VideoView?
    private var requestAudioFocus: Bool = true
    private var mute: Bool = false
    private var volume: Double = 1.0

    init(frame:CGRect, viewId:Int64, registrar: FlutterPluginRegistrar) {
        self.viewId = viewId
        self.videoView = VideoView(frame: frame)
        self.methodChannel = FlutterMethodChannel(name: "native_video_view_\(viewId)", binaryMessenger: registrar.messenger())
        super.init()
        self.videoView?.addOnPreparedObserver {
            [weak self] () -> Void in
            self?.onPrepared()
        }
        self.videoView?.addOnFailedObserver {
            [weak self] (message: String) -> Void in
            self?.onFailed(message: message)
        }
        self.videoView?.addOnCompletionObserver {
            [weak self] () -> Void in
            self?.onCompletion()
        }
        self.methodChannel.setMethodCallHandler {
           [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self?.handle(call: call, result: result)
        }
    }
    
    deinit {
        self.videoView = nil
        self.methodChannel.setMethodCallHandler(nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    public func view() -> UIView {
        return videoView!
    }
    
    func handle(call: FlutterMethodCall, result: FlutterResult) -> Void {
        switch(call.method){
        case "player#setVideoSource":
            let arguments = call.arguments as? [String:Any]
            if let args = arguments {
                let videoPath: String? = args["videoSource"] as? String
                let sourceType: String? = args["sourceType"] as? String
                let requestAudioFocus: Bool? = args["requestAudioFocus"] as? Bool
                self.requestAudioFocus = requestAudioFocus ?? false
                if let path = videoPath {
                    let isUrl: Bool = sourceType == "VideoSourceType.network" ? true : false
                    self.configurePlayer()
                    self.videoView?.configure(videoPath: path, isURL: isUrl)
                }
            }
            result(nil)
            break
        case "player#start":
            self.videoView?.play()
            result(nil)
            break
        case "player#pause":
            self.videoView?.pause(restart: false)
            result(nil)
            break
        case "player#stop":
            self.videoView?.stop()
            result(nil)
            break
        case "player#currentPosition":
            var arguments = Dictionary<String, Any>()
            arguments["currentPosition"] = self.videoView?.getCurrentPosition()
            result(arguments)
            break
        case "player#isPlaying":
            var arguments = Dictionary<String, Any>()
            arguments["isPlaying"] = self.videoView?.isPlaying()
            result(arguments)
            break
        case "player#seekTo":
            let arguments = call.arguments as? [String:Any]
            if let args = arguments {
                let position: Int64? = args["position"] as? Int64
                self.videoView?.seekTo(positionInMillis: position)
            }
            result(nil)
            break
        case "player#toggleSound":
            mute = !mute
            self.configureVolume()
            result(nil)
            break
        case "player#setVolume":
            let arguments = call.arguments as? [String:Any]
            if let args = arguments {
                let volume: Double? = args["volume"] as? Double
                if let vol = volume {
                    self.mute = false
                    self.volume = vol
                    self.configureVolume()
                }
            }
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    func configurePlayer(){
        self.handleAudioFocus()
        self.configureVolume()
    }

    func handleAudioFocus(){
        do {
            if requestAudioFocus {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            } else {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }

    func configureVolume(){
        if mute {
            self.videoView?.setVolume(volume: 0.0)
        } else {
            self.videoView?.setVolume(volume: volume)
        }
    }
    
    func onCompletion(){
        self.videoView?.stop()
        self.methodChannel.invokeMethod("player#onCompletion", arguments: nil)
    }
    
    func onPrepared(){
        var arguments = Dictionary<String, Any>()
        let height = self.videoView?.getVideoHeight()
        let width = self.videoView?.getVideoWidth()
        arguments["duration"] = self.videoView?.getDuration()
        arguments["height"] = height
        arguments["width"] = width
        self.methodChannel.invokeMethod("player#onPrepared", arguments: arguments)
    }
    
    func onFailed(message: String){
        var arguments = Dictionary<String, Any>()
        arguments["message"] = message
        self.methodChannel.invokeMethod("player#onError", arguments: arguments)
    }
}

class VideoView : UIView {
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var videoAsset: AVAsset?
    private var initialized: Bool = false
    private var onPrepared: (()-> Void)? = nil
    private var onFailed: ((String) -> Void)? = nil
    private var onCompletion: (() -> Void)? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    deinit {
        self.removeOnFailedObserver()
        self.removeOnPreparedObserver()
        self.removeOnCompletionObserver()
        self.player?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        self.stop()
        self.initialized = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureVideoLayer()
    }
    
    func configure(videoPath: String?, isURL: Bool){
        if !initialized {
            self.initVideoPlayer()
        }
        if let path = videoPath {
            let uri: URL? = isURL ? URL(string: path) : URL(fileURLWithPath: path)
            let asset = AVAsset(url: uri!)
            player?.replaceCurrentItem(with: AVPlayerItem(asset: asset))
            self.videoAsset = asset
            self.configureVideoLayer()
            // Notifies when the video finishes playing.
            NotificationCenter.default.addObserver(self, selector: #selector(onVideoCompleted(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        }
    }
    
    private func configureVideoLayer(){
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resize
        if let playerLayer = self.playerLayer {
            self.clearSubLayers()
            layer.addSublayer(playerLayer)
        }
    }
    
    private func clearSubLayers(){
        layer.sublayers?.forEach{
            $0.removeFromSuperlayer()
        }
    }
    
    private func initVideoPlayer(){
        self.player = AVPlayer(playerItem: nil)
        self.player?.addObserver(self, forKeyPath: "status", options: [], context: nil)
        self.initialized = true
    }
    
    func play(){
        if !self.isPlaying() && self.videoAsset != nil {
            self.player?.play()
        }
    }
    
    func pause(restart:Bool){
        self.player?.pause()
        if(restart){
            self.player?.seek(to: CMTime.zero)
        }
    }
    
    func stop(){
        self.pause(restart: true)
    }
    
    func isPlaying() -> Bool{
        return self.player?.rate != 0 && self.player?.error == nil
    }

    func setVolume(volume:Double){
        self.player?.volume = Float(volume)
    }
    
    func getDuration()-> Int64 {
        let durationObj = self.player?.currentItem?.duration
        return self.transformCMTime(time: durationObj)
    }
    
    func getCurrentPosition() -> Int64 {
        let currentTime = self.player?.currentItem?.currentTime()
        return self.transformCMTime(time: currentTime)
    }
    
    func getVideoHeight() -> Double {
        var height: Double = 0.0
        let videoTrack = self.getVideoTrack()
        if videoTrack != nil {
            height = Double(videoTrack?.naturalSize.height ?? 0.0)
        }
        return height
    }
    
    func getVideoWidth() -> Double {
        var width: Double = 0.0
        let videoTrack = self.getVideoTrack()
        if videoTrack != nil {
            width = Double(videoTrack?.naturalSize.width ?? 0.0)
        }
        return width
    }
    
    func getVideoTrack() -> AVAssetTrack? {
        var videoTrack: AVAssetTrack? = nil
        let tracks = videoAsset?.tracks(withMediaType: .video)
        if tracks != nil && tracks!.count > 0 {
            videoTrack = tracks![0]
        }
        return videoTrack
    }
    
    private func transformCMTime(time:CMTime?) -> Int64 {
        var ts : Double = 0
        if let obj = time {
            ts = CMTimeGetSeconds(obj) * 1000
        }
        return Int64(ts)
    }
    
    func seekTo(positionInMillis: Int64?){
        if let pos = positionInMillis {
            self.player?.seek(to: CMTimeMake(value: pos, timescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    func addOnPreparedObserver(callback: @escaping ()->Void){
        self.onPrepared = callback
    }
    
    func removeOnPreparedObserver() {
        self.onPrepared = nil
    }
    
    private func notifyOnPreaparedObserver(){
        if onPrepared != nil {
            self.onPrepared!()
        }
    }
    
    func addOnFailedObserver(callback: @escaping (String)->Void){
        self.onFailed = callback
    }
    
    func removeOnFailedObserver() {
        self.onFailed = nil
    }
    
    private func notifyOnFailedObserver(message: String){
        if onFailed != nil {
            self.onFailed!(message)
        }
    }
    
    func addOnCompletionObserver(callback: @escaping ()->Void){
        self.onCompletion = callback
    }
    
    func removeOnCompletionObserver() {
        self.onCompletion = nil
    }
    
    private func notifyOnCompletionObserver(){
        if onCompletion != nil {
            self.onCompletion!()
        }
    }
    
    @objc func onVideoCompleted(notification:NSNotification){
        self.notifyOnCompletionObserver()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status = self.player!.status
            switch(status){
            case .unknown:
                print("Status unknown")
                break
            case .readyToPlay:
                self.notifyOnPreaparedObserver()
                break
            case .failed:
                if let error = self.player?.error{
                    let errorMessage = error.localizedDescription
                    self.notifyOnFailedObserver(message: errorMessage)
                }
                break
             default:
                print("Status unknown")
                break
            }
        }
    }
}
