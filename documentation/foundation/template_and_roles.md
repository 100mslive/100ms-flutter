# Templates and Roles

## Introduction

Template is the blueprint of the room. It defines the settings of the room along with the behavior of users who are part of it. Room will inherit the properties from a template that you have specified while creating it. If you have not specified any template then it will pick the default template. Each template will be identified by its id. E.g. <span style="color:blue">default_videoconf_7e450ffc-8ef1-4572-ab28-b32474107b89</span>

Users can see or modify the templates by visiting <span style="color:blue">Templates</span>

<img src="https://docs.100ms.live/docs/v2/template.png">

## Roles

Role is a collection of permissions that allows you to perform certain set of operations while being part of the room. It has the following attributes

## General Settings

### Name

Every role has a name that should be unique inside a template. This name will be used while generating app tokens and referencing inside a template.

### Publish Strategies

Publish strategies will be used to determine the tracks and their quality which can be published by this role.

### Can share audio

Whether the role is allowed to publish the audio track or not.

### Can share video

Whether the role is allowed to publish the video track or not

### Can share screen

Whether the role is allowed to do screen share or not

### Video quality
Quality of the video track which is going to be published by the role. Currently, 4 video qualities <span style="color:blue">720p</span>, <span style="color:blue">480p</span>, <span style="color:blue">360p</span> and <span style="color:blue">240p</span> are predefined and the user can select one out of these values. This option will be visible only if the Can share video is enabled.

### Screenshare quality
Quality of the screen which is going to be shared by the role. Currently, 2 video qualities <span style="color:blue">720p</span> and <span style="color:blue">1080p</span> are predefined and the user can select one out of these values. This option will be visible only if the Can share screen is enabled.

## Subscribe Strategies
Subscribe strategies will be used to determine what all roles, this role can subscribe to.

### Subscribe to
You can select all the roles of the template which this role will subscribe

## Permissions
Permissions will contain a list of additional privileges that this role will have.

### Can change any participant's role
With this permission, user will be able to change the role of the other participant's who are present in the room

### Can mute any participant
With this permission, user will be able to mute any participant's audio and/or video.

### Can ask participant to unmute
With this permission, user will be able to ask any participant to unmute their audio and/or video.

### Can remove participant from the room
With this permission, user will be able to remove any participant from the current session of the room.

### Can end current session of the room
With this permission, user will be able to end the current session of the room.

#### Note

- As of now templates have only roles section which will be extended in future
- You can modify an existing template to create a new template.