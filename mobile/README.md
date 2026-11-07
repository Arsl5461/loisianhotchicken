# Louisiana Hot Chicken — Mobile

Flutter app for iOS and Android. Same core features as the web app, using the existing `/api/v1` backend.

## Run

Switch APIs in `lib/core/constants/app_config.dart`:

```dart
static const environment = ApiEnvironment.live;  // or ApiEnvironment.local
```

- Live: `https://lhc-holdings.com/api/v1`
- Local iOS: `http://127.0.0.1:5050/api/v1`
- Local Android emulator: `http://10.0.2.2:5050/api/v1`

```bash
cd mobile
flutter pub get
flutter run
```

Default login:

- Email: `admin@louisianahotchicken.com`
- Password: `ChangeMeNow!123`

## Architecture

Clean Architecture + Riverpod:

`presentation → use case → repository → Dio API client`

Tokens are stored in secure storage. The selected store is sent as `X-Store-Id`.
