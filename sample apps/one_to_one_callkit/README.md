# Flutter One To One Audio/Video Calling Application
![Flutter 1-1](https://github.com/100mslive/100ms-flutter/assets/93931528/41816a5b-a3f4-4ed9-b16c-1b3caf91670f)


Welcome to our One-to-One Audio-Video Calling Flutter app named Blitz 100ms.


This application leverages the open source `hms_room_kit` package for efficient audio/video calls, integrates with CallKit for seamless Android/iOS call functionalities, and utilizes Firebase for push notifications.

## Features
Audio and video calling using `hms_room_kit`.
CallKit integration for iOS to handle audio/video calls natively.
Firebase notifications to alert users of incoming calls, even when the app is in the background.

## Getting Started

### Installation

1. Clone the repository

```bash
git clone https://github.com/100mslive/100ms-flutter.git
```

2. Navigate to the project directory

```bash
cd directory_name
```

3. Install dependencies

```bash
flutter pub get
```

> Note 🔑: The app utilizes the `callkit-ui` branch from the `hms_room_kit` repository instead of the published package to integrate a customized calling interface.

4. Set up Firebase for Push Notifications, Google Sign-in, and Cloud functions. Add `GoogleService-Info.plist` to the `ios/Runner` directory and `google-services.json` to `android/app` directory.

5. Create a 100ms account, and setup below templates:

    - Audio Room Template 
    - Video Room Template

    In the above templates, ensure two roles are `speaker` and `listener` with permissions to `publish` and `subscribe` to each other. Also, ensure both roles have `end room` and `room state` permissions.

| Listener | Speaker |
|----------|---------|
|  <img width="494" alt="Screenshot 2024-04-01 at 6 11 46 PM" src="https://github.com/100mslive/100ms-flutter/assets/93931528/c3cfaa68-1872-44a5-91fe-37af8a7232ca"> | <img width="494" alt="Screenshot 2024-04-01 at 6 12 03 PM" src="https://github.com/100mslive/100ms-flutter/assets/93931528/90f24e52-a83c-488f-b753-9bc9bc47ba0f"> |

For room state permissions enable the room state from `Advanced Settings`


<img width="989" alt="Screenshot 2024-04-01 at 12 12 38 AM" src="https://github.com/100mslive/100ms-flutter/assets/93931528/cde6f46e-bc5b-4c06-bc08-edc461871b04">


6. Add the following fields in the below files:

  - Update `CFBundleURLSchemes` in `Info.plist` with your client ID from `GoogleService-Info.plist`
  - Update management token from 100ms dashboard, `Developer section` in `functions/index.js`
  - Add Audio and video template IDs in `createRoom` method in `lib/services/app_utilities.dart`
  - Add authentication client id in `loginUser` method from `GoogleService-Info.plist` file in `lib/services/app_utilities.dart`

7. Deploy cloud functions

```bash
firebase deploy --only functions
```

That's it! You're ready to run the application.

### Running the application

```bash
flutter run
```

## Usage

Upon launching the app, users can initiate audio or video calls to other users through the interface provided by hms_room_kit.

Incoming calls will trigger Firebase notifications, prompting the receiver to accept or decline the call. 

On iOS devices, CallKit integration ensures that the call UI is consistent with the native call experience.

///Add video here
