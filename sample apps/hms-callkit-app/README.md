# One To One Call Application

A sample project for calling made with 100ms and flutter_callkit_incoming.

https://github.com/Decoder07/hms-callkit-demo/assets/93931528/69bd9d0f-65e9-46cd-a50c-4ac7ea9a6446

## Getting Started

- Clone the repo
- Run flutter pub get
- Setup 100ms token service
- Setup firebase service for notifications

That's it now to run the project execute `flutter run`

## How to test

To test the application install the app in two devices.

- Copy the code(FCM token) from one device. Let's call it Device-1
- Paste this token on different device. Let's call this Device-2
- Press the Call Now button on Device-1
- You will receive a notification on Device-2
- Accept the call on Device-2

### Setup 100ms token service

100ms token service takes care of joining room once you receive a call or you wish to call someone.
We will need an authentication token to join the room which we will also send to other peer through payload by which the receiver can also join the room. You can find the code for this in `join_service.dart`.

Here's the code for this:

```dart
Future<String> getAuthToken({required String roomId,required String tokenEndpoint,required String userId,required String role}) async {
  Uri endPoint = Uri.parse(
      tokenEndpoint);
  http.Response response = await http.post(endPoint,
      body: {'user_id': userId, 'room_id': roomId, 'role': role});
  var body = json.decode(response.body);
  return body['token'];
}
```

`getAuthToken` returns the authentication token which we will use for joining the room and also share with the receiver for him to join the room.

Let's understand the parameters of this function:

- roomId

`roomId` refers to the room which you wish to join. You can find the roomId in dashboard's rooms section.

- tokenEndpoint

`tokenEndpoint` is the url which is used to get the authentication token. You can find the `tokenEndpoint` in developer section of 100ms dashboard.

- userId

`userId` can be used to uniquely identify user to perform any specific actions on that user later on.

- role

`role` refers the role which you wish to join the room. Ensure that the given role is present in the room template for given roomId.

### Setup firebase service for notifications

First create a project on firebase. You can find the steps [here](https://medium.com/enappd/adding-firebase-to-your-flutter-app-281b8f391b47)

Since we will be using firebase messaging to deliver notifications ensure that you have a `blaze plan` enabled on firebase and please enable `cloud messaging` and `Firebase Cloud Messaging API` from firebase cloud console.

![cloud-console](https://user-images.githubusercontent.com/93931528/218379651-d35036ff-98f2-4b6c-a298-4a229d3326b7.jpeg)

For setting up firebase notifications please follow [this](https://quickcoder.org/flutter-push-notifications/)

The repo already contains a `functions` folder which has the firebase functions so you can directly deploy them.

That's it you are all set for running the application.

Have any issues. Please reach out to us over [discord](https://100ms.live/discord)
