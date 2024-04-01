# Flutter One To One Audio/video Calling Application

Welcome to our One To One Audio/video Calling Application(Blitz 100ms), an application built for audio and video calling in Flutter. This application leverages the open source `hms_room_kit` package for efficient audio/video calls, integrates with CallKit for seamless Android/iOS call functionalities, and utilizes Firebase for reliable notifications.

## Features
Audio and video calling using hms_room_kit.
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

4. Setup Firebase for push notifications, google signin and cloud functions. Add `GoogleService-Info.plist` to the `ios/Runner` directory and `google-services.json` to `android/app` directory.

5. Create a 100ms account, and setup below templates:

    - Audio Room Template 
    - Video Room Template

    In above templates make sure having two roles `speaker` and `listener` with permissions to `publish` and `subscribe` each other. Also ensure that both has end room and room state permissions.

    ///Add images here

6. Add following fields in below files:

  - Update `CFBundleURLSchemes` in `Info.plist` with your client ID from `GoogleService-Info.plist`
  - Update management token from 100ms dashboard, Developer section in `functions/index.js`
  - Add Audio and video template ids in `createRoom` method in `lib/services/app_utilities.dart`
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

Upon launching the app, users can initiate audio or video calls to other users through the interface provided by hms_room_kit. Incoming calls will trigger Firebase notifications, prompting the receiver to accept or decline the call. On iOS devices, CallKit integration ensures that the call UI is consistent with the native call experience.

///Add video here
