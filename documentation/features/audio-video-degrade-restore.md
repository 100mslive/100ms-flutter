---
title: Auto Video Degrade/Restore
nav: 8
---

Sometimes people have bad internet connections but everyone deserves a good meeting.

When the network is too slow to support audio and video conversations together, the 100ms SDK can automatically turn off downloading other peer's videos, which may improve the audio quality and avoid disconnections.

If the network quality improves, the videos will be restored automatically as well.

To turn on subscribe degradation in your room, open the [templates](https://dashboard.100ms.live/templates) in the dashboard and enable it for roles there. Here's more information about [templates](foundation/templates-and-roles).


## Responding in the app

All `HMSVideoTracks`, within the `HMSPeer`'s have a variable called `isDegraded`.

If `isDegraded` is true, treat it as if the video is turned off. If the UI is not changed, the video tile will appear black.
