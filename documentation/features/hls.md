---
title: HLS Streaming
nav: 13.2
---

HLS Streaming allows for scaling to millions of viewers in near real time. You can give a link of your
webapp which will be converted to a HLS feed by our server and can be played across devices for consumption.

Behind the scenes, this will be achieved by having a bot join your room and stream what it sees and hears. Once the feed is ready, the server will give a url which can be played using any HLS Player.

> Note that the media server serving the content in this case is owned by 100ms. If you're looking for a way to stream
on YouTube, Twitch etc., please have a look at our RTMP streaming docs [here](./RTMP-recording).

## Starting HLS

To start HLS you'll need to pass in a meeting URL. The 100ms bot will open this URL to join your room, so
it must allow access without any user level interaction. In the future it'll be possible to start HLS for multiple such URLs for the same room.

For this purpose the API supports taking in an array, although currently only the first element of the array will be used. To distinguish between multiple urls an additional field `metadata` can be optionally passed. The `meetingUrl` and `metadata` are clubbed together to form what we'll call a `variant`.

You can call `meeting.startHlsStreaming` with a `HMSHLSConfig` having an array of such variants.




```dart

    meeting.startHlsStreaming(hmsHLSMeetingUrlVariant,hmsActionResultListener:null);

```


> Want to see how this works in a live project? [Take a look](https://github.com/100mslive/100ms-android/blob/bba78d425c4e59e1344dc18f50b6494f5160a89f/app/src/main/java/live/hms/app2/ui/meeting/MeetingViewModel.kt#L933) at our advanced sample app.

## Current Room Status

The current status for the room is always reflected in the `HMSRoom` object.

Here are the relevant properties inside the `HMSRoom` object which you can read to get the current hls streaming status of the room namely: `hlsStreamingState`.

The object contains a boolean `running` which lets you know if it's active on the room right now as well as list of active variants.


1. **hlsStreamingState** an instance of `HMSHLSStreamingState`, which looks like:

```dart
data class HMSHLSStreamingState(
        val running : Boolean,
        val variants : List<HMSHLSVariant?>,
)
```

This represents a livestream to one or more HLS urls in the container of `HMSHLSVariant`. Which looks like:
```dart
class HMSHLSVariant(
    hlsStreamUrl: String?,
    meetingUrl: String?,
    metadata: String?,
    startedAt: double?
)
```

The room status should be checked in following two places -

1. In the `onJoin(room: HMSRoom)` callback of `HMSUpdateListener`
    The properties mentioned above will be on the `HMSRoom` object.
2. In the `onRoomUpdate(type: HMSRoomUpdate, hmsRoom: HMSRoom)` callback of `HMSUpdateListener`.
    The `HMSRoomUpdate` type will be `HMSRoomUpdate.HLS_STREAMING_STATE_UPDATED`.

## Tips

* If you're using the dashboard webapp from 100ms, please make sure to use a role which doesn't have publish permissions for beam tile to not show up.
* If using your own webapp, do put in place retries for API calls like tokens etc. just in case any call fails. As human users we're used to reloading the page in these scenarios which is difficult to achieve in the automated case.
* Make sure to not disable the logs for the passed in meeting URL. This will allow for us to have more visibility into the room, refreshing the page if join doesn't happen within a time interval.
