


# hmssdk_flutter - Dart API docs


<p align="center">
  <a href="https://100ms.live/">
  <img src="https://github.com/100mslive/100ms-flutter/raw/develop/100ms.svg" title="100ms logo" float="left"></a>
</p>
<p><a href="https://docs.100ms.live/"><img src="https://img.shields.io/badge/Read-Documentation-blue" alt="Documentation"></a>
<a href="https://discord.com/invite/kGdmszyzq2"><img src="https://img.shields.io/badge/Community-Join%20on%20Discord-blue" alt="Discord"></a>
<a href="https://join.slack.com/t/100mslive/shared_invite/zt-llwdnz11-vkb2RzptwacwXHO7UeY0CQ"><img src="https://img.shields.io/badge/Community-Join%20on%20Slack-blue" alt="Slack"></a>
<a href="mailto:founders@100ms.live"><img src="https://img.shields.io/badge/Contact-Know%20More-blue" alt="Email"></a></p>
<h1 id="100ms-flutter-sdk-">100ms Flutter SDK 🎉</h1>
<p>Here you will find everything you need to build experiences with video using 100ms iOS/Android SDK. Dive into our SDKs, quick starts, add real-time video, voice, and screen sharing to your web and mobile applications.</p>
<p>📲 Download the Sample iOS app here: <a href="https://testflight.apple.com/join/Uhzebmut">https://testflight.apple.com/join/Uhzebmut</a></p>
<p>🤖 Download the Sample Android app here: <a href="https://appdistribution.firebase.dev/i/b623e5310929ab70">https://appdistribution.firebase.dev/i/b623e5310929ab70</a></p>
<ol>
<li><code>x</code> Generating Auth Token</li>
<li><code>x</code> Join Meeting</li>
<li><code>x</code> Leave Meeting</li>
<li><code>x</code> Show peers with Audio/Video</li>
<li><code>x</code> Change roles for a peer</li>
<li><code>x</code> Mute/Unmute audio</li>
<li><code>x</code> On/Off Video</li>
<li><code>x</code> Switch between front/back cameras</li>
<li><code>x</code> Custom View for video <code>plug and play</code></li>
<li><code>x</code> Preview</li>
</ol>
<h2 id="how-to-run-project">How to run project</h2>
<ol>
<li>In project root, run <code>flutter pub get</code></li>
<li>Change directory to <code>example</code> folder, run <code>flutter packages pub run build_runner build --delete-conflicting-outputs</code></li>
<li>Run either <code>flutter build ios</code> OR <code>flutter build apk</code></li>
<li>Finally, <code>flutter run</code></li>
</ol>
<h2 id="-key-concepts">🧐 Key Concepts</h2>
<ul>
<li><code>Room</code> - A room represents real-time audio, video session, the basic building block of the 100mslive Video SDK</li>
<li><code>Track</code> - A track represents either the audio or video that makes up a stream</li>
<li><code>Peer</code> - A peer represents all participants connected to a room. Peers can be "local" or "remote"</li>
<li><code>Broadcast</code> - A local peer can send any message/data to all remote peers in the room</li>
</ul>
<h2 id="generating-auth-token">Generating Auth Token</h2>
<p>Auth Token is used in HMSConfig instance to setup configuration.
So you need to make an HTTP request. you can use any package we are using <code>http</code> package.
  You will get your token endpoint at your 100ms dashboard and append <code>api/token</code> to that endpoint and make an http post request.</p>
<p>Example:
<code>http.Response response = await http.post(Uri.parse(Constant.getTokenURL),               body: {'room_id': room, 'user_id': user, 'role': Constant.defaultRole});</code>
  after generating token parse it using json.
    <code>var body = json.decode(response.body);         String token = body['token'];</code>
  You will need this token later explained below.</p>
<h2 id="-setup-event-listeners">♻️ Setup event listeners</h2>
<p>100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing <code>HMSUpdateListener</code>. These updates can be used to render the video on screen or to display other info regarding the room.</p>
<pre class="language-dart"><code>abstract class HMSUpdateListener {
  /// This will be called on a successful JOIN of the room by the user
  ///
  /// This is the point where applications can stop showing its loading state
  /// - Parameter room: the room which was joined
  void onJoin({required HMSRoom room});

  /// This is called when there is a change in any property of the Room
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  /// This will be called whenever there is an update on an existing peer
  /// or a new peer got added/existing peer is removed.
  ///
  /// This callback can be used to keep a track of all the peers in the room
  /// - Parameters:
  ///   - peer: the peer who joined/left or was updated
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  /// This is called when there are updates on an existing track
  /// or a new track got added/existing track is removed
  ///
  /// This callback can be used to render the video on screen whenever a track gets added
  /// - Parameters:
  ///   - track: the track which was added, removed or updated
  ///   - trackUpdate: the triggered update type
  ///   - peer: the peer for which track was added, removed or updated
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer});

  /// This will be called when there is an error in the system
  ///
  /// and SDK has already retried to fix the error
  /// - Parameter error: the error that occurred
  void onError({required HMSError error});

  /// This is called when there is a new broadcast message from any other peer in the room
  ///
  /// This can be used to implement chat is the room
  /// - Parameter message: the received broadcast message
  void onMessage({required HMSMessage message});

  /// This is called when someone asks for change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  /// This is called every 1 second with list of active speakers
  ///
  /// ## A HMSSpeaker object contains -
  ///    - peerId: the peer identifier of HMSPeer who is speaking
  ///    - trackId: the track identifier of HMSTrack which is emitting audio
  ///    - audioLevel: a number within range 1-100 indicating the audio volume
  ///
  /// A peer who is not present in the list indicates that the peer is not speaking
  ///
  /// This can be used to highlight currently speaking peers in the room
  /// - Parameter speakers: the list of speakers
  void onUpdateSpeakers({required List&lt;HMSSpeaker&gt; updateSpeakers});

  void onReconnecting();

  void onReconnected();
}
</code></pre>
<h2 id="-how-to-listen-to-track-peer-and-room-updates">🤔 How to listen to Track, Peer and Room updates?</h2>
<p>The HMS SDK sends updates to the application about any change in HMSPeer , HMSTrack or HMSRoom via the callbacks in HMSUpdateListener.
Application need to listen to the corresponding updates in onPeerUpdate , onTrackUpdate or onRoomUpdate</p>
<p>The following are the different types of updates that are emitted by the SDK -</p>
<pre class="language-dart"><code>  HMSPeerUpdate
    case PEER_JOINED A new peer joins the room
    case PEER_LEFT - An existing peer leaves the room
    case BECAME_DOMINANT_SPEAKER - A peer becomes a dominant speaker
    case NO_DOMINANT_SPEAKER - There is silence in the room (No speaker is detected)
    
  HMSTrackUpdate
    case TRACK_ADDED - A new track is added by a remote peer
    case TRACK_REMOVED - An existing track is removed from a remote peer
    case TRACK_MUTED - An existing track of a remote peer is muted
    case TRACK_UNMUTED - An existing track of a remote peer is unmuted
    case TRACK_DESCRIPTION_CHANGED - The optional description of a track of a remote peer is changed
</code></pre>
<h2 id="-how-to-know-the-type-and-source-of-track">🛤 How to know the type and source of Track?</h2>
<p>HMSTrack contain a field called source which denotes the source of the Track. 
Source can have the following values - regular (normal), screen (for screenshare)and plugin (for plugins)</p>
<p>To know the type of track, check the value of type which would be one of the enum values - AUDIO or VIDEO</p>
<h2 id="-provide-joining-configuration">🤝 Provide joining configuration</h2>
<p>To join a room created by following the steps described in the above section, clients need to create a <code>HMSConfig</code> instance and use that instance to call <code>join</code> method of <code>HMSSDK</code></p>
<pre class="language-dart"><code>  // Create a new HMSConfig
     HMSConfig config = HMSConfig(
         userId: userId,
         roomId: roomId,
         authToken: token,
         userName: userName);

</code></pre>
<p><code>userId</code>: should be unique we are using <code>Uuid</code> package to generate one.
 <code>roomId</code>: id of the room which you want to join.
 <code>token</code>:  follow the above step 1 to generate token.
 <code>userName</code>: your name using which you want to join the room.</p>
<h2 id="-join-a-room">🙏 Join a room</h2>
<p>Use the HMSConfig and HMSUpdateListener instances to call the join method on the instance of HMSSDK created above.
Once Join succeeds, all the callbacks keep coming on every change in the room and the app can react accordingly</p>
<pre class="language-dart"><code>  // Basic Usage
  HMSMeeting meeting = HMSMeeting()
  meeting.joinMeeting(config: this.config);

  // Advanced Usage
  Coming soon.
</code></pre>
<h2 id="-leave-room">👋 Leave Room</h2>
<p>Call the leave method on the HMSSDK instance</p>
<pre class="language-dart"><code>  meeting.leave() // to leave a room
</code></pre>
<h2 id="-muteunmute-local-audio">🙊 Mute/Unmute Local Audio</h2>
<pre class="language-dart"><code>  // Turn on
  meeting.switchAudio(isOn:true)
  // Turn off  
  meeting.switchAudio(isOn:false)
</code></pre>
<h2 id="-muteunmute-local-video">🙈 Mute/Unmute Local Video</h2>
<pre class="language-dart"><code>  meeting.startCapturing()

  meeting.stopCapturing()

  meeting.switchCamera()

</code></pre>
<h2 id="-hmstracks-explained">🛤 HMSTracks Explained</h2>
<p><code>HMSTrack</code> is the super-class of all the tracks that are used inside <code>HMSSDK</code>. Its hierarchy looks like this -</p>
<pre class="language-dart"><code>  HMSTrack
      - AudioTrack
          - LocalAudioTrack
          - RemoteAudioTrack
      - VideoTrack
          - LocalVideoTrack
          - RemoteVideoTrack
</code></pre>
<h2 id="-display-a-track">🎞 Display a Track</h2>
<p>To display a video track, first get the <code>HMSVideoTrack</code> &amp; pass it on to <code>HMSVideoView</code> using <code>setVideoTrack</code> function. Ensure to attach the <code>HMSVideoView</code> to your UI hierarchy.</p>
<pre class="language-dart"><code>            VideoView(
                track: videoTrack,
                args: {
                  'height': customHeight,
                  'width': customWidth,
                },
              );

</code></pre>
<h2 id="change-a-role">Change a Role</h2>
<p>To change role, you will provide peerId of selected peer and new roleName from roles. If forceChange is true, the system will prompt user for the change. If forceChange is false, user will get a prompt to accept/reject the role.
After changeRole is called, HMSUpdateListener's onRoleChangeRequest will be called on selected user's end.</p>
<pre class="language-dart"><code>     meeting.changeRole(
            peerId: peerId, roleName: roleName, forceChange: forceChange);
</code></pre>
<h2 id="-chat-messaging">📨 Chat Messaging</h2>
<p>You can send a chat or any other kind of message from local peer to all remote peers in the room.</p>
<p>To send a message first create an instance of <code>HMSMessage</code> object.</p>
<p>Add the information to be sent in the <code>message</code> property of <code>HMSMessage</code>.</p>
<p>Then use the <code>Future&lt;void&gt; sendMessage(String message)</code> function on instance of HMSMeeting.</p>
<p>When you(the local peer) receives a message from others(any remote peer), <code>void onMessage({required HMSMessage message})</code> function of <code>HMSUpdateListener</code> is invoked.</p>
<pre class="language-dart"><code>  // following is an example implementation of chat messaging

  // to send a broadcast message
        String message = 'Hello World!'
        meeting.sendMessage(message);  // meeting is an instance of `HMSMeeting` object

  
  // receiving messages
  // the object conforming to `HMSUpdateListener` will be invoked with `on(message: HMSMessage)`, add your logic to update Chat UI within this listener
  void onMessage({required HMSMessage message}){
      let messageReceived = message.message // extract message payload from `HMSMessage` object that is received
      // update your Chat UI with the messageReceived
  }

 🏃‍♀️ Checkout the sample implementation in the [Example app folder](https://github.com/100mslive/100ms-flutter/tree/main/example).

</code></pre>
<h2 id="-preview">🎞 Preview</h2>
<p>You can use our preview feature to unmute/mute audio/video before joining the room.</p>
<p>You can implement your own preview listener using this <code>abstract class HMSPreviewListener</code></p>
<pre class="language-dart"><code>  abstract class HMSPreviewListener {

    //you will get all error updates here
    void onError({required HMSError error});

    //here you will get room instance where you are going to join and your own local tracks to render the video by checking the type of trackKind and then using the 
    //above mentioned VideoView widget
   void onPreview({required HMSRoom room, required List&lt;HMSTrack&gt; localTracks});
  }
</code></pre>
<h2 id="-setup-guide">🚂 Setup Guide</h2>
<ol>
<li>
<p>Sign up on <a href="https://dashboard.100ms.live/register">https://dashboard.100ms.live/register</a> &amp; visit the Developer tab to access your credentials.</p>
</li>
<li>
<p>Get familiarized with <a href="https://docs.100ms.live/ios/v2/foundation/Security-and-tokens">Tokens &amp; Security here</a></p>
</li>
<li>
<p>Complete the steps in <a href="https://docs.100ms.live/ios/v2/guides/Token">Auth Token Quick Start Guide</a></p>
</li>
<li>
<p>Get the HMSSDK via <a href="https://pub.dev/">pub.dev</a>. Add the <code>hmssdk_flutter'</code> to your pubspec.yaml</p>
</li>
</ol>
<h2 id="android-integration">Android Integration</h2>
<p>Add following permissions in Android AndroidManifest.xml file</p>
<pre class="language-dart"><code>    &lt;uses-feature android:name="android.hardware.camera"/&gt;

    &lt;uses-feature android:name="android.hardware.camera.autofocus"/&gt;

    &lt;uses-permission android:name="android.permission.CAMERA"/&gt;

    &lt;uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/&gt;

    &lt;uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/&gt;

    &lt;uses-permission android:name="android.permission.RECORD_AUDIO"/&gt;

    &lt;uses-permission android:name="android.permission.BLUETOOTH"/&gt;

    &lt;uses-permission android:name="android.permission.INTERNET"/&gt;

    &lt;uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/&gt;
</code></pre>
<h2 id="-pre-requisites">☝️ Pre-requisites</h2>
<ul>
<li>Support for Android API level 24 or higher</li>
<li>Support for Java 8</li>
</ul>
<h2 id="-supported-devices">📱 Supported Devices</h2>
<p>The Android SDK supports Android API level 21 and higher. It is built for armeabi-v7a, arm64-v8a, x86, and x86_64 architectures.</p>
<h2 id="ios-integration">iOS Integration</h2>
<p>Add following permissions in iOS Info.plist file</p>
<pre class="language-dart"><code>    &lt;key&gt;NSMicrophoneUsageDescription&lt;/key&gt;
    &lt;string&gt;{YourAppName} wants to use your microphone&lt;/string&gt;
    
    &lt;key&gt;NSCameraUsageDescription&lt;/key&gt;
    &lt;string&gt;{YourAppName} wants to use your camera&lt;/string&gt;
    
    &lt;key&gt;NSLocalNetworkUsageDescription&lt;/key&gt;
    &lt;string&gt;{YourAppName} App wants to use your local network&lt;/string&gt;
</code></pre>
<h2 id="license">License</h2>
<p>MIT</p>


## Libraries

##### [hms_audio_codec](enum_hms_audio_codec/enum_hms_audio_codec-library.md)
 


##### [hms_audio_setting](model_hms_audio_setting/model_hms_audio_setting-library.md)
 


##### [hms_audio_track](model_hms_audio_track/model_hms_audio_track-library.md)
 


##### [hms_audio_track_setting](model_hms_audio_track_setting/model_hms_audio_track_setting-library.md)
 


##### [hms_camera_facing](enum_hms_camera_facing/enum_hms_camera_facing-library.md)
 


##### [hms_codec](enum_hms_codec/enum_hms_codec-library.md)
 


##### [hms_config](model_hms_config/model_hms_config-library.md)
 


##### [hms_error](model_hms_error/model_hms_error-library.md)
 


##### [hms_error_code](model_hms_error_code/model_hms_error_code-library.md)
 


##### [hms_exception](exceptions_hms_exception/exceptions_hms_exception-library.md)
 


##### [hms_in_sufficient_data](exceptions_hms_in_sufficient_data/exceptions_hms_in_sufficient_data-library.md)
 


##### [hms_local_audio_track](model_hms_local_audio_track/model_hms_local_audio_track-library.md)
 


##### [hms_local_peer](model_hms_local_peer/model_hms_local_peer-library.md)
 


##### [hms_local_video_track](model_hms_local_video_track/model_hms_local_video_track-library.md)
 


##### [hms_message](model_hms_message/model_hms_message-library.md)
100ms HMSMessage [...](model_hms_message/model_hms_message-library.md)


##### [hms_peer](model_hms_peer/model_hms_peer-library.md)
100ms HMSPeer. [...](model_hms_peer/model_hms_peer-library.md)


##### [hms_peer_update](enum_hms_peer_update/enum_hms_peer_update-library.md)
 


##### [hms_permissions](model_hms_permissions/model_hms_permissions-library.md)
 


##### [hms_preview_listener](model_hms_preview_listener/model_hms_preview_listener-library.md)
<a href="model_hms_preview_listener/HMSPreviewListener-class.md">HMSPreviewListener</a> listens to updates when you preview. [...](model_hms_preview_listener/model_hms_preview_listener-library.md)


##### [hms_preview_update_listener_method](enum_hms_preview_update_listener_method/enum_hms_preview_update_listener_method-library.md)
 


##### [hms_publish_setting](model_hms_publish_setting/model_hms_publish_setting-library.md)
 


##### [hms_remote_audio_track](model_hms_remote_audio_track/model_hms_remote_audio_track-library.md)
 


##### [hms_remote_video_track](model_hms_remote_video_track/model_hms_remote_video_track-library.md)
 


##### [hms_role](model_hms_role/model_hms_role-library.md)
<code>Role</code> is a powerful concept that takes a lot of complexity away in handling permissions and supporting features like breakout rooms. [...](model_hms_role/model_hms_role-library.md)


##### [hms_role_change_request](model_hms_role_change_request/model_hms_role_change_request-library.md)
<a href="model_hms_role_change_request/HMSRoleChangeRequest-class.md">HMSRoleChangeRequest</a> contains the info about the role suggested recieved by you [...](model_hms_role_change_request/model_hms_role_change_request-library.md)


##### [hms_room](model_hms_room/model_hms_room-library.md)
100ms HMSRoom [...](model_hms_room/model_hms_room-library.md)


##### [hms_room_update](enum_hms_room_update/enum_hms_room_update-library.md)
 


##### [hms_sdk](model_hms_sdk/model_hms_sdk-library.md)
 


##### [hms_simul_cast_settings](model_hms_simul_cast_settings/model_hms_simul_cast_settings-library.md)
 


##### [hms_speaker](model_hms_speaker/model_hms_speaker-library.md)
 


##### [hms_subscribe_settings](model_hms_subscribe_settings/model_hms_subscribe_settings-library.md)
 


##### [hms_track](model_hms_track/model_hms_track-library.md)
A track represents either the audio or video that a peer is publishing. 


##### [hms_track_kind](enum_hms_track_kind/enum_hms_track_kind-library.md)
 


##### [hms_track_setting](model_hms_track_setting/model_hms_track_setting-library.md)
 


##### [hms_track_source](enum_hms_track_source/enum_hms_track_source-library.md)
 


##### [hms_track_update](enum_hms_track_update/enum_hms_track_update-library.md)
 


##### [hms_update_listener](model_hms_update_listener/model_hms_update_listener-library.md)
HMSUpdateListener listens to all the updates happening inside the room [...](model_hms_update_listener/model_hms_update_listener-library.md)


##### [hms_update_listener_method](enum_hms_update_listener_method/enum_hms_update_listener_method-library.md)
 


##### [hms_video_codec](enum_hms_video_codec/enum_hms_video_codec-library.md)
 


##### [hms_video_resolution](model_hms_video_resolution/model_hms_video_resolution-library.md)
 


##### [hms_video_setting](model_hms_video_setting/model_hms_video_setting-library.md)
 


##### [hms_video_track](model_hms_video_track/model_hms_video_track-library.md)
 


##### [hms_video_track_setting](model_hms_video_track_setting/model_hms_video_track_setting-library.md)
 


##### [hmssdk_flutter](hmssdk_flutter/hmssdk_flutter-library.md)
 


##### [meeting](meeting_meeting/meeting_meeting-library.md)
HMSMeeting will contain all the functionalities related to meeting and preview. [...](meeting_meeting/meeting_meeting-library.md)


##### [platform_method_response](model_platform_method_response/model_platform_method_response-library.md)
PlatformMethodResponse contains all the responses sent back from the platform [...](model_platform_method_response/model_platform_method_response-library.md)


##### [platform_methods](common_platform_methods/common_platform_methods-library.md)
 


##### [platform_service](service_platform_service/service_platform_service-library.md)
PlatformService helps to connect to android or ios depending on device [...](service_platform_service/service_platform_service-library.md)


##### [sdk_store](model_sdk_store/model_sdk_store-library.md)
 


##### [video_view](ui_meeting_video_view/ui_meeting_video_view-library.md)
VideoView used to render video in ios and android devices [...](ui_meeting_video_view/ui_meeting_video_view-library.md)








