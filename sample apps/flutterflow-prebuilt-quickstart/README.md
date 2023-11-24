# FlutterFlow & HMS Room Kit App Starter

https://github.com/100mslive/100ms-flutter/assets/93931528/63a04b40-cdab-4712-9eb3-9e92b23c2f09

Welcome to the FlutterFlow and HMS Room Kit App Starter project! This Flutter template provides a solid foundation for building feature-rich mobile applications by combining the power of FlutterFlow for UI design and HMS Room Kit for real-time communication capabilities.

## Features

- **FlutterFlow Integration:** Leverage FlutterFlow's intuitive visual development platform to design stunning user interfaces for your Flutter app effortlessly.

- **HMS Room Kit:** Integrate 100ms HMS Room Kit for seamless real-time communication features such as instant messaging, audio, and video calls into your Flutter application.

## Getting Started

Follow these steps to set up and run the project locally:

1. Clone this repository:

   ```bash
   git clone https://github.com/100mslive/100ms-flutter.git
   ```

2. Navigate to the project directory:

    ```bash
    cd sample\ apps/flutterflow-prebuilt-quickstart
    ```

3. Install the required dependencies:

    ```bash
    flutter pub get
    ```

4. Run the app:
    
    ```bash
    flutter run
    ```

## Documentation

For detailed information on how to use FlutterFlow and integrate HMS Room Kit features, check out the documentation:

- [FlutterFlow Documentation](https://docs.flutterflow.io/)
- [HMS Room Kit Documentation](https://www.100ms.live/docs/flutter/v2/quickstart/prebuilt)

## Steps to run hms_room_kit with flutterflow

`hms_room_kit` manages state and UI out of the box, but there are some conflicts with flutterflow. So, we need to make some changes in the app layer. Please follow the steps below to run the app:

1. Solving dependency conflicts:

<img width="526" alt="Screenshot 2023-11-20 at 11 00 18 AM" src="https://github.com/100mslive/100ms-flutter/assets/93931528/810b96ca-d268-4681-b073-56b4df35de51">

There are several packages which are common in both `flutterflow` and `hms_room_kit`, but with different versions. So, we need to make sure that the versions of these packages are same in both `pubspec.yaml` files. For conflict in packages you will get error like this:

```bash
Error: Failed running flutter pub get...
Because custom_widget depends on flutter_cache_manager 3.3.0 which depends on http ^0.13.0, http ^0.13.0 is required.
So, because custom_widget depends on http ^1.0.0, version solving failed.


You can try the following suggestion to make the pubspec resolve:
* Try upgrading your constraint on flutter_cache_manager: flutter pub add flutter_cache_manager:^3.3.1
```

This can be solved by updating to the higher version of the package. For example, in the above error, we need to update `flutter_cache_manager` to `^3.3.1` in `pubspec.yaml` file.

> 🔑 Note: Flutterflow UI doesn't directly allow changing the package version, either you need to do it in `Custom Widgets` section or you can download the code from flutterflow and change the version in `pubspec.yaml` file locally. We recommend doing the later since it's much easier.

2. Issues with Navigator:

Flutterflow uses `go_router` whereas `hms_room_kit` uses `MaterialPageRoute` for navigation. So, you might face issues while navigating from app screen to `hms_room_kit` screen. To solve this, you will need to use `MaterialPageRoute` while pushing the `hms_room_kit` path while you can continue using `go_router` for other paths.

That's it. You can now use the amazing Prebuilt UI with speed of flutterflow in your application.

If you face any issues or have any questions, please reach out to us on [Discord](https://discord.gg/jD94Fp74Ea)


