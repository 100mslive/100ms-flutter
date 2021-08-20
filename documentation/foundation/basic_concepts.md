# Basic Concepts

## Architecture
100ms is a cloud platform that allows developers to add video and audio conferencing to Web, Android and iOS applications.

The platform provides REST APIs, SDKs, and a dashboard that makes it simple to capture, distribute, record, and render live interactive audio, video.

Any application built using 100ms' SDK has 2 components.

* Client: Use 100ms android, iOS, Web SDKs to manage connections, room states, render audio/video.

* Server: Use 100ms' APIs or dashboard to create rooms, setup room templates, trigger recording or RTMP streaming, access events.

<img src="https://docs.100ms.live/docs/v2/arch.png">

## Basic Concepts

- <span style="color:blue">Room</span> A room is the basic object that 100ms SDKs return on successful connection. This contains references to peers, tracks and everything you need to render a live a/v app.

- <span style="color:blue">Peer</span> A peer is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.

- <span style="color:blue">Track</span> A track represents either the audio or video that a peer is publishing.

- <span style="color:blue">Track</span> A role defines who can a peer see/hear, the quality at which they publish their video, whether they have permissions to publish video/screenshare, mute someone, change someone's role.

- <span style="color:blue">Template</span> A template is a collection of roles, room settings, recording and RTMP settings (if used), that are used by the SDK to decide which geography to connect to, which tracks to return to the client, whether to turn on recording when a room is created, etc. Each room is associated with a template.

- <span style="color:blue">Template</span> Recording is used to save audio/video calls for offline viewing. 100ms supports both individual and composite recordings.

- <span style="color:blue">RTMP</span> RTMP streaming is used to live stream your video conferencing apps to platforms like Facebook, YouTube, Twitch, etc.

- <span style="color:blue">Webhook</span> Webhook is an HTTP(S) endpoint used for pushing the notifications to your application. It will be invoked by 100ms servers to notify events of your room.

## What are the steps to build a live app with 100ms?

1. <b>Create a template</b>: Create a template and define roles, room settings - You can do this using the <span style="color:blue">dashboard</span>.

2. <b>Create a room using the above template</b>: You can do this using the <span style="color:blue">dashboard</span> or our <span style="color:blue">API</span>.

3. <b>Integrate client SDK and join the above room</b>: You'll need to generate a <span style="color:blue">token</span> for each peer that connects to a room.

4. <b>[Optional] Receive events</b>: Create a <span style="color:blue">webhook endpoint</span> to receive server-side notifications about room usage (peer joining/leaving) or recording, RTMP out starting/ending.

## Where should I start?

### Quickstart

If you just want to see 100ms' SDKs in action in under 5 minutes, run one our quickstart app

