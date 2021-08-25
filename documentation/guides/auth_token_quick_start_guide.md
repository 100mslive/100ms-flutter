# Auth Token Quickstart Guide

## Creating Account in 100ms

Create an account at <a>Dashboard of 100ms</a>

<img src="https://docs.100ms.live/guides/token/create-account.png">

After you have created your account you have to Confirm your Email , check the promotions tab in your Mail Box if you can't find it.

Then login again and you would see this Section. Fill it out

<img src="https://docs.100ms.live/guides/token/build-app.png">

After that's done you would be asked to choose a template we will choose "Video Conferencing" for now then click on "Set up App"

<img src="https://docs.100ms.live/guides/token/template.png">

After you're App is set click on "Go to Dashboard" or <a>Go Here</a>

<img src="https://docs.100ms.live/guides/token/go-to-dashboard.png">

## Token Generation
Any client connecting calling 100ms' service needs to authenticate using an auth token. In production you would have your own servers generating the tokens (see more <a>here</a>), but for a quick start you can use the dashboard to create a token for you. The token will expire in 24hrs and should not be hardcoded into a production app.

### Creating Room
To create a token you first need to create a room. Go over to <a>Room in Dashboard</a> and click on "Create Room" , While creating a room you can specify it's name, roles or enable recording.

<img src="https://docs.100ms.live/guides/token/create-room.png">

You will now see "Room Details" section and we have a `room_id` created, copy it somewhere.

<img src="https://docs.100ms.live/guides/token/room-id.png">

### Getting a Temporary Token

To get a temporary token click on "Join room" button.

<img src="https://docs.100ms.live/guides/token/join-room.png">

In the popup that shows up click on icon with a key shape next to the role you want to join as.

<img src="https://docs.100ms.live/guides/token/copy-token.png">

The token will be copied to your clipboard. Use this along with the `room_id` to proceed with the quickstart guide.