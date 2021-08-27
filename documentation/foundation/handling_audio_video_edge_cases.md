# Handling audio-video edge cases
## Introduction
100ms handles a lot of standard audio/video issues internally without the developer needing to handle it explicitly. This page describes some common issues and how 100ms handles them.

There are 3 major issues of issues that can occur in a audio/video conference

- Device capture exceptions
- Network disconnection/switching network exceptions
- Network bandwidth limitation/large room exceptions

## Device failure

A common issue is a failure to capture mic/camera even though the user has all devices connected. Common causes include differences in OS/browser implementations of device capture APIs, permission not being granted by the user, or the device being in use by another program.

The usual recourse in these exceptions is to prompt a user action - "Grant permission", "Please close any other app using microphone", "Switch to Safari"

100ms' SDKs come with a <span style="color:blue">preview method</span> that can be called before joining a room. This will test for device failures, network connectivity and throw errors with a recommended user action.

## Network disconnection/Switching networks

Another set of common issues are minor network blips. Common causes are when a user moves from one room to another, or switches from wifi to data.

100ms will send a notification within 10s of detecting a network disconnection and will automatically retry when connection is available upto 60s. After 60s, a terminal error is thrown to the client.

## Network bandwidth limitation/large rooms

A common occurrence in large rooms, or constrained networks is dropped frames. This results in robotic voices, frozen frames, pixelated screenshare or entire pieces of audio/video that are lost.

100ms will automatically prioritize connections if network limits are reached. This prioritization can be controlled by developers using the dashboard or 100ms APIs.

eg. A developer can prioritize host's screenshare higher than guests' videos. In low bandwidth constraints, guests' videos will be turned off, while host's screenshare will remain.