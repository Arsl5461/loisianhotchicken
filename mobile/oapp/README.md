# OApp

OApp (display name: Bubba) is a Flutter app for dating, profiles, travel, and real-time messaging.

## Features

- Phone, social, and account-setup authentication flows
- Profile creation, editing, photo management, and dating preferences
- Location selection, travel mode, and travel stories
- Real-time messaging, matches, and contact management
- Privacy, notifications, membership, payments, and account settings

## Stack and SDK

- Flutter 3.38.7 and Dart 3.10.7 (toolchain used for this project)
- Dart SDK constraint: `>=3.9.0 <4.0.0`
- GetX state management and routing
- Dio networking, Socket.IO messaging, and Firebase services
- Stripe payments and Google Maps

## Setup

1. Install Flutter 3.38.7 (Dart 3.10.7) and the iOS/Android toolchains.
2. From this directory, fetch packages:

   ```sh
   flutter pub get
   ```

3. Configure the local `.env` values required by the app, including the API base URL and Stripe publishable key. Keep credentials private.
4. Configure platform credentials for Firebase, Google Maps, and sign-in providers in the existing platform configuration files.

For Android release signing, copy `android/key.properties.example` to
`android/key.properties` and replace its placeholders with your local signing
values. Do not commit the populated file.

## Build and test

Run the analyzer and widget tests:

```sh
flutter analyze lib test
flutter test
```

Build Android:

```sh
flutter build apk --debug
```

Build iOS for a simulator:

```sh
flutter build ios --simulator --no-codesign
```

Run on a connected device or simulator with `flutter run`.
